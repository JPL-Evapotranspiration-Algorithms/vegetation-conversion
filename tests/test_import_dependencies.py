import pytest


dependencies = [
    "numpy",
    "rasters",
]


@pytest.mark.parametrize("dependency", dependencies)
def test_dependency_import(dependency):
    __import__(dependency)
