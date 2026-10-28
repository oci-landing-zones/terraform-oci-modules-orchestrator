"""Check ordering in an actual `terraform graph -type=plan` DOT export."""

from collections import defaultdict
from pathlib import Path
import re
import sys


graph = defaultdict(set)
for source, dependency in re.findall(r'"([^"\n]+)" -> "([^"\n]+)"', Path(sys.argv[1]).read_text()):
    graph[source].add(dependency)


def requires(source, dependency):
    pending = [f"[root] {source} (expand)"]
    target = f"[root] {dependency} (expand)"
    visited = set()
    while pending:
        node = pending.pop()
        if node == target:
            return True
        if node not in visited:
            visited.add(node)
            pending.extend(graph[node])
    return False


chain = [
    "time_sleep.tag_defaults_propagation",
    "oci_identity_tag_default.these",
    "module.oci_lz_compartments",
    "time_sleep.tag_propagation",
    "module.oci_lz_tags",
]
for source, dependency in zip(chain, chain[1:]):
    assert requires(source, dependency), f"Missing dependency: {source} -> {dependency}"
    assert not requires(dependency, source), f"Reverse dependency: {dependency} -> {source}"

modules = set()
for path in Path(__file__).resolve().parents[1].glob("*.tf"):
    modules.update(re.findall(r'^module "([^"]+)"', path.read_text(), re.MULTILINE))
services = {f"module.{name}" for name in modules - {"oci_lz_tags", "oci_lz_compartments"}}
services.add("oci_objectstorage_bucket.these")
for service in sorted(services):
    assert requires(service, chain[0]), f"Service does not wait for tag defaults: {service}"

print(f"Tag/compartment/default ordering verified for {len(services)} service entry points.")
