"""Offline contract tests. No OCI provider, credentials or infrastructure required."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
TF = os.environ.get("TERRAFORM_BIN", "terraform")


def cluster(cni="native"):
    return {"name": "example", "compartment_id": "COMP", "is_enhanced": True,
            "cni_type": cni, "networking": {"vcn_id": "VCN",
            "api_endpoint_subnet_id": "CP", "services_subnet_id": ["LB"]}}


def pool(ref="prod"):
    return {"name": "workers", "cluster_id": ref, "size": 1,
            "networking": {"workers_subnet_id": "WORKERS", "pods_subnet_id": "PODS"},
            "node_config_details": {"node_shape": "VM.Standard.E5.Flex",
            "image": r"9\.[0-9]+", "cloud_init": {"heredoc_script": "#!/bin/bash\necho bootstrap"}}}


class CompatibilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.path = Path(cls.tmp.name)
        config = {
            "variable": {"clusters": {"type": "any", "default": None},
                         "workers": {"type": "any", "default": None},
                         "envelopes": {"type": "any", "default": None}},
            "module": {
                "adapter": {"source": str(ROOT / "modules/oke-compatibility"),
                            "clusters_configuration": "${var.clusters}",
                            "workers_configuration": "${var.workers}"},
                "inputs": {"source": str(ROOT / "modules/oke-inputs"),
                           "configurations": "${var.envelopes}"}},
            "output": {"clusters": {"value": "${module.adapter.clusters}"},
                       "workers": {"value": "${module.adapter.workers}"},
                       "envelopes": {"value": "${module.inputs.configurations}"}}}
        cls.extend_config(config)
        (cls.path / "main.tf.json").write_text(json.dumps(config))
        subprocess.run([TF, "init", "-backend=false", "-input=false", "-no-color"],
                       cwd=cls.path, check=True, capture_output=True)

    @classmethod
    def extend_config(cls, config):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def plan(self, clusters=None, workers=None, envelopes=None, error=None):
        (self.path / "terraform.tfvars.json").write_text(json.dumps(
            {"clusters": clusters, "workers": workers, "envelopes": envelopes}))
        result = subprocess.run([TF, "plan", "-input=false", "-no-color", "-out=plan"],
                                cwd=self.path, capture_output=True, text=True)
        if error:
            self.assertNotEqual(result.returncode, 0)
            self.assertIn(error, result.stdout + result.stderr)
            return
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        out = subprocess.run([TF, "show", "-json", "plan"], cwd=self.path,
                             check=True, capture_output=True, text=True)
        return {k: v["value"] for k, v in json.loads(out.stdout)["planned_values"]["outputs"].items()}

    def test_empty(self):
        out = self.plan()
        self.assertEqual(out["clusters"], {})
        self.assertEqual(out["workers"], {})

    def test_native_bootstrap_and_defaults(self):
        p = pool()
        out = self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}})
        self.assertEqual(out["clusters"]["prod"]["cluster_type"], "enhanced")
        w = out["workers"]["prod"]["worker_pools"]["np"]
        self.assertEqual(w["os_version"], "9")
        self.assertEqual(w["pod_subnet_id"], "PODS")
        self.assertFalse(w["pv_transit_encryption"])
        self.assertTrue(w["disable_default_cloud_init"])
        self.assertEqual(w["cloud_init"][0]["content"], p["node_config_details"]["cloud_init"]["heredoc_script"])
        self.assertEqual(w["placement_ads"], [1])
        self.assertIsNone(w["placement_fds"])

    def test_multi_cluster_overlay_cis2(self):
        c = cluster("flannel")
        c.update(cis_level="2", encryption={"kube_secret_kms_key_id": "KEY"})
        c["options"] = {"kubernetes_network_config": {"pods_cidr": "10.244.0.0/16"}}
        p = pool("preprod")
        p["cis_level"] = "2"
        p["networking"].pop("pods_subnet_id")
        p["node_config_details"]["encryption"] = {"kms_key_id": "KEY", "enable_encrypt_in_transit": True}
        out = self.plan({"clusters": {"prod": cluster(), "preprod": c}},
                        {"node_pools": {"np1": pool(), "np2": p}})
        self.assertEqual(set(out["workers"]["prod"]["worker_pools"]), {"np1"})
        w = out["workers"]["preprod"]["worker_pools"]["np2"]
        self.assertTrue(w["pv_transit_encryption"])
        self.assertIsNone(w["pod_subnet_id"])
        self.assertEqual(w["volume_kms_key_id"], "KEY")

    def test_explicit_empty_tags_replace_defaults(self):
        c = cluster()
        c["freeform_tags"] = {}
        out = self.plan({"default_freeform_tags": {"default": "tag"}, "clusters": {"prod": c}})
        self.assertEqual(out["clusters"]["prod"]["freeform_tags"], {})

    def test_custom_image(self):
        p = pool()
        p["node_config_details"]["image"] = "ocid1.image.oc1.example"
        out = self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}})
        w = out["workers"]["prod"]["worker_pools"]["np"]
        self.assertEqual(w["image_id"], "ocid1.image.oc1.example")
        self.assertIsNone(w["os_version"])

    def test_virtual_pool(self):
        p = {"name": "virtual", "size": 1, "cluster_id": "prod", "pod_shape": "Pod.Standard.E4.Flex",
             "networking": {"workers_subnet_id": "WORKERS", "pods_subnet_id": "PODS"}}
        out = self.plan({"clusters": {"prod": cluster()}}, {"virtual_node_pools": {"vp": p}})
        self.assertEqual(out["workers"]["prod"]["worker_pools"]["vp"]["mode"], "virtual-node-pool")

    def test_invalid_worker_inputs(self):
        cases = [("external", "external clusters"), ("cis", "CIS levels must match"),
                 ("compartment", "cross-compartment"), ("image", "arbitrary image regexes")]
        for case, message in cases:
            with self.subTest(case=case):
                p = pool()
                if case == "external": p["cluster_id"] = "ocid1.cluster.external"
                if case == "cis": p["cis_level"] = "2"
                if case == "compartment": p["compartment_id"] = "OTHER"
                if case == "image": p["node_config_details"]["image"] = ".*"
                self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}}, error=message)

    def test_public_endpoint_rejected(self):
        c = cluster()
        c["networking"]["is_api_endpoint_public"] = True
        self.plan({"clusters": {"prod": c}}, error="public endpoints")

    def test_malformed_cluster_envelope(self):
        self.plan({"cluster_configuration": cluster()}, error="must contain a clusters map")

    def test_heterogeneous_placement(self):
        p = pool()
        p["node_config_details"]["placement"] = [{"availability_domain": 1},
            {"availability_domain": 2, "fault_domain": 1}]
        self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}},
                  error="heterogeneous per-AD")

    def test_unsupported_cloud_init(self):
        p = pool()
        p["node_config_details"]["cloud_init"] = {"file": "bootstrap.sh"}
        self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}},
                  error="other bootstrap formats")

    def test_envelope_aliases(self):
        for prefix in ("", "oke_"):
            with self.subTest(prefix=prefix):
                value = {"clusters": {"prod": cluster()}}
                out = self.plan(envelopes={prefix + "clusters_configuration": value})
                self.assertEqual(out["envelopes"]["clusters"], value)

    def test_ambiguous_envelopes_rejected(self):
        self.plan(envelopes={"oke_clusters_configuration": {}, "clusters_configuration": {}},
                  error="Supply only one OKE JSON envelope")


@unittest.skipUnless((ROOT / ".terraform/modules/oci_lz_oke/cis-oke/modules/configuration").is_dir(),
                     "Run terraform init in the repository root for downstream contract tests")
class DownstreamContractTests(CompatibilityTests):
    """Repeat all valid mappings through the pinned module's real typed schema."""
    @classmethod
    def extend_config(cls, config):
        config["module"]["downstream"] = {
            "source": str(ROOT / ".terraform/modules/oci_lz_oke/cis-oke/modules/configuration"),
            "for_each": "${module.adapter.clusters}",
            "cluster_configuration": "${each.value}",
            "workers_configuration": "${module.adapter.workers[each.key]}"}
        config["output"]["downstream"] = {"value":
            "${{for k, m in module.downstream : k => {cluster = m.contract.cluster_configuration, pools = m.normalized_worker_pools}}}"}

    def test_schema_keeps_bootstrap_and_pool_keys(self):
        p = pool()
        out = self.plan({"clusters": {"prod": cluster()}}, {"node_pools": {"np": p}})
        pools = out["downstream"]["prod"]["pools"]
        self.assertEqual(set(pools), {"np"})
        self.assertEqual(pools["np"]["cloud_init"][0]["content"],
                         p["node_config_details"]["cloud_init"]["heredoc_script"])
        self.assertFalse(pools["np"]["pv_transit_encryption"])

    def test_downstream_rejects_basic_cluster(self):
        c = cluster()
        c["is_enhanced"] = False
        self.plan({"clusters": {"prod": c}}, error="Only enhanced clusters")

    def test_downstream_rejects_native_pod_cidr(self):
        c = cluster()
        c["options"] = {"kubernetes_network_config": {"pods_cidr": "10.244.0.0/16"}}
        self.plan({"clusters": {"prod": c}}, error="Native CNI clusters must omit")


if __name__ == "__main__":
    unittest.main()
