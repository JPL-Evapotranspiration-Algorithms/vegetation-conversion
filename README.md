# vegetation-conversion

Vegetation Conversion Python Utilities.

This package provides utilities for converting vegetation indices used in PT-JPL workflows.

[Gregory H. Halverson](https://github.com/gregory-halverson-jpl) (they/them)  
[gregory.h.halverson@jpl.nasa.gov](mailto:gregory.h.halverson@jpl.nasa.gov)  
NASA Jet Propulsion Laboratory 329G

## Installation

Install from source in editable mode:

```bash
pip install -e .[dev]
```

## Usage

Import this package as `vegetation_conversion`:

```python
import vegetation_conversion
```

### 1. `SAVI_from_NDVI(NDVI)`
- Description: Converts NDVI to Soil-Adjusted Vegetation Index using an empirical linear relationship.
- Formula: `SAVI = NDVI * 0.45 + 0.132`

### 2. `fAPAR_from_SAVI(SAVI)`
- Description: Converts SAVI to fraction of absorbed PAR.
- Formula: `fAPAR = clip(SAVI * 1.3632 - 0.048, 0, 1)`

### 3. `fIPAR_from_NDVI(NDVI)`
- Description: Converts NDVI to fraction of intercepted PAR.
- Formula: `fIPAR = clip(clip(NDVI, 0, 1) - 0.05, 0, 1)`

## Development

- Run tests: `make test`
- Build package: `make build`
