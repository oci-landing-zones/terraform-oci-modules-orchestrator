"""Provider-free contract tests for deferred tag defaults (Terraform >= 1.5)."""

import json
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class TagDefaultsTest(unittest.TestCase):
    def evaluate(self, configuration):
        # Evaluate the production locals with Terraform, rather than reimplementing HCL.
        self.assertTrue((ROOT / "tag-defaults.tf").exists(), "Deferred tag defaults are not implemented")
        source = (ROOT / "tag-defaults.tf").read_text()
        locals_source = source.split('resource "oci_identity_tag_default"', 1)[0]
        with tempfile.TemporaryDirectory(prefix="tag-defaults-test-") as directory:
            path = Path(directory)
            (path / "main.tf").write_text(
                'variable "tags_configuration" { type = any }\n' + locals_source
            )
            (path / "input.tfvars.json").write_text(
                json.dumps({"tags_configuration": configuration})
            )
            result = subprocess.run(
                ["terraform", "console", "-no-color", "-var-file=input.tfvars.json"],
                cwd=path,
                input='jsonencode({configuration = local.tags_configuration_without_defaults, defaults = local.tag_defaults})\n',
                text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("Error:", result.stderr)
            return json.loads(json.loads(result.stdout))

    def test_disabled_and_empty_configuration(self):
        for config in (None, {}, {"namespaces": None}, {"namespaces": {}}):
            with self.subTest(config=config):
                result = self.evaluate(config)
                self.assertEqual(result["defaults"], {})
                if config is None:
                    self.assertIsNone(result["configuration"])

    def test_defaults_are_deferred_without_losing_tag_metadata(self):
        config = {
            "default_compartment_id": "TENANCY-ROOT",
            "default_defined_tags": {},
            "namespaces": {
                "COST": {"name": "cost", "tags": {
                    "OWNER": {"name": "owner", "valid_values": ["none", "team"],
                              "tag_defaults": {"REQUIRED": {
                                  "compartment_ids": ["NEW-CMP", "EXTERNAL-CMP", "ocid1.compartment.test", "TENANCY-ROOT"],
                                  "default_value": "none", "is_user_required": True}}},
                    "OPTIONAL": {"name": "optional", "tag_defaults": None},
                }},
                "ROLE": {"name": "role", "tags": {"ROLE": {"name": "role"}}},
                "EMPTY": {"name": "empty", "tags": None},
            },
        }
        result = self.evaluate(config)
        self.assertEqual(set(result["defaults"]), {
            "REQUIRED.NEW-CMP", "REQUIRED.EXTERNAL-CMP",
            "REQUIRED.ocid1.compartment.test", "REQUIRED.TENANCY-ROOT",
        })
        for key, default in result["defaults"].items():
            self.assertEqual(default["tag_key"], "OWNER")
            self.assertEqual(default["compartment_id"], key.removeprefix("REQUIRED."))
            self.assertTrue(default["is_user_required"])
            self.assertEqual(default["default_value"], "none")
        owner = result["configuration"]["namespaces"]["COST"]["tags"]["OWNER"]
        self.assertIsNone(owner["tag_defaults"])
        self.assertEqual(owner["valid_values"], ["none", "team"])
        self.assertEqual(result["configuration"]["default_defined_tags"], {})

    def test_optional_required_flag_defaults_to_false(self):
        for flag in ({}, {"is_user_required": None}, {"is_user_required": False}):
            config = {"namespaces": {"NS": {"name": "ns", "tags": {
                "TAG": {"name": "tag", "tag_defaults": {"DEFAULT": {
                    "compartment_ids": ["CMP"], "default_value": "none", **flag,
                }}}
            }}}}
            self.assertFalse(self.evaluate(config)["defaults"]["DEFAULT.CMP"]["is_user_required"])


if __name__ == "__main__":
    unittest.main()
