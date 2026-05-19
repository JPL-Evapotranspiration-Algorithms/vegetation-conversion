# vegetation-conversion Migration Plan

## Objective
Extract the PT-JPL `vegetation_conversion` sub-module into this standalone `vegetation-conversion` package, keeping behavior and API consistent with current PT-JPL usage while aligning repository structure and packaging conventions with `meteorology-conversion`.

## Scope Decisions
- PT-JPL integration timing: deferred to a follow-up pull request.
- API compatibility: strict parity with current public functions only.
- Packaging baseline: fully mirror `meteorology-conversion` conventions.

## In Scope
- Create standalone package structure and metadata in this repository.
- Port existing vegetation conversion functions with no formula changes.
- Add baseline tests for imports, dependencies, and deterministic outputs.
- Add build/test workflow and documentation consistent with `meteorology-conversion`.

## Out of Scope
- Switching PT-JPL runtime imports in the same effort.
- Adding new vegetation algorithms beyond the existing public API.
- Refactoring formulas, coefficients, or clipping behavior.

## Source of Truth (Current PT-JPL Module)
Public API to preserve exactly:
1. `SAVI_from_NDVI(NDVI)`
2. `fAPAR_from_SAVI(SAVI)`
3. `fIPAR_from_NDVI(NDVI)`

Behavioral parity requirements:
- Preserve current equations and coefficients.
- Preserve clipping behavior for bounded outputs.
- Preserve support for both `numpy.ndarray` and `rasters.Raster` inputs.
- Preserve function names and import surface.

## Target Repository Layout

```text
vegetation-conversion/
├── pyproject.toml
├── makefile
├── README.md
├── vegetation_conversion/
│   ├── __init__.py
│   ├── vegetation_conversion.py
│   ├── SAVI_from_NDVI.py
│   ├── fAPAR_from_SAVI.py
│   ├── fIPAR_from_NDVI.py
│   └── version.py
└── tests/
    ├── test_import_vegetation_conversion.py
    ├── test_import_dependencies.py
    └── test_vegetation_conversion.py
```

## Phased Plan

### Phase 1: Parity Contract and Baseline
1. Confirm PT-JPL source behavior for all 3 functions.
2. Document exact formulas, clipping rules, and type behavior.
3. Lock v1 scope to strict parity (no extra APIs).

Deliverable:
- Signed-off parity contract (this file + test expectations).

### Phase 2: Scaffolding and Packaging Alignment
1. Add package directory and module exports.
2. Add `version.py` using `importlib.metadata` pattern consistent with `meteorology-conversion`.
3. Add `pyproject.toml` with:
   - setuptools/wheel build system
   - Python version floor
   - core dependencies: `numpy`, `rasters`
   - dev dependencies for build/test/release
4. Add `makefile` targets aligned with `meteorology-conversion` (`clean`, `test`, `build`, `install`, `dist`, etc.).

Deliverable:
- Installable package skeleton with aligned metadata.

### Phase 3: Functional Port
1. Port function implementations from PT-JPL without formula drift.
2. Preserve scientific references and docstring intent.
3. Ensure top-level import pattern mirrors existing package style.

Deliverable:
- `vegetation_conversion` module with strict API parity.

### Phase 4: Tests and Verification
1. Add import smoke test for package import.
2. Add dependency import tests (parametrized).
3. Add deterministic numeric tests for each conversion function.
4. Add edge-case clipping tests:
   - out-of-range NDVI handling for `fIPAR_from_NDVI`
   - lower/upper bounds for `fAPAR_from_SAVI`

Deliverable:
- Passing pytest suite validating parity and package health.

### Phase 5: Documentation and Release Readiness
1. Expand README to include:
   - package purpose
   - installation instructions
   - usage examples
   - API summary and references
2. Run local readiness checks:
   - editable install
   - `pytest`
   - `python -m build`
3. Choose initial release version and publish plan.

Deliverable:
- Release-ready standalone package repository.

## Acceptance Criteria
- Public API exposes exactly the 3 parity functions plus `__version__`.
- All tests pass locally.
- Build succeeds for sdist and wheel.
- Package metadata and workflow match `meteorology-conversion` style.
- No PT-JPL code changes are included in this extraction PR.

## Risks and Mitigations
1. Dependency mismatch (`rasters` behavior differences)
- Mitigation: include explicit dependency tests and parity examples.

2. Formula drift during copy/cleanup
- Mitigation: deterministic tests with known input/output values.

3. API surface drift from wildcard exports
- Mitigation: verify import surface in dedicated tests.

## Follow-Up Plan (Separate PR)
After this package is released:
1. Update PT-JPL to depend on published `vegetation-conversion`.
2. Replace internal vegetation imports in PT-JPL model pipeline.
3. Keep a short compatibility period if needed, then deprecate/remove internal duplicate module.

## Suggested Commit Breakdown
1. Scaffold package structure and metadata.
2. Port vegetation conversion implementation files.
3. Add tests for imports, dependencies, and numerical parity.
4. Expand README and finalize release readiness updates.
