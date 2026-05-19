# vegetation-conversion

Vegetation Conversion Python Utilities.

This package provides utilities for converting vegetation indices used in PT-JPL workflows.

[Gregory H. Halverson](https://github.com/gregory-halverson-jpl) (they/them)  
[gregory.h.halverson@jpl.nasa.gov](mailto:gregory.h.halverson@jpl.nasa.gov)  
NASA Jet Propulsion Laboratory 329G

## Installation

```bash
pip install vegetation-conversion
```

## Usage

Import this package as `vegetation_conversion`:

```python
import vegetation_conversion
```

### 1. `SAVI_from_NDVI(NDVI)`
- Description: Converts NDVI to a SAVI proxy using an empirical linear transformation.
- Scientific basis:
	- SAVI was originally developed to reduce soil background influence in sparse vegetation by introducing a soil adjustment factor, $L$, in:
		```math
		SAVI = \frac{(NIR - Red)(1 + L)}{NIR + Red + L}
		```
	- In workflows where only NDVI is available, PT-JPL implementations commonly use a linear NDVI-to-SAVI approximation to maintain compatibility with downstream canopy/energy-partitioning steps.
	- This package preserves the PT-JPL parity mapping:
		```math
		SAVI = 0.45 \cdot NDVI + 0.132
		```
	- This mapping is not a universal physical replacement for the original SAVI expression; it is an empirically tuned conversion used for model continuity.
- Parameters:
	- `NDVI`: Normalized Difference Vegetation Index as `numpy.ndarray` or `rasters.Raster`.
- Returns:
	- SAVI proxy with same container type (`numpy.ndarray` or `rasters.Raster`).
- Citation: Huete (1988).

### 2. `fAPAR_from_SAVI(SAVI)`
- Description: Estimates the fraction of absorbed photosynthetically active radiation (fAPAR) from SAVI.
- Scientific basis:
	- fAPAR represents the fraction of incoming PAR absorbed by green vegetation canopy and is a key state variable controlling photosynthesis, transpiration, and coupled land-atmosphere fluxes.
	- Empirical remote-sensing studies have shown approximately linear relationships between vegetation indices and canopy radiation absorption metrics over practical operating ranges.
	- This package uses the PT-JPL parity relation:
		```math
		fAPAR = 1.3632 \cdot SAVI - 0.048
		```
	- Output is physically bounded by clipping to $[0, 1]$, where 0 denotes no absorbed PAR and 1 denotes full absorption.
- Parameters:
	- `SAVI`: Soil-Adjusted Vegetation Index as `numpy.ndarray` or `rasters.Raster`.
- Returns:
	- `fAPAR` in $[0, 1]$ with same container type (`numpy.ndarray` or `rasters.Raster`).
- Citation: Fisher et al. (2008).

### 3. `fIPAR_from_NDVI(NDVI)`
- Description: Estimates the fraction of intercepted photosynthetically active radiation (fIPAR) from NDVI.
- Scientific basis:
	- fIPAR characterizes canopy interception of incoming PAR and is frequently used in ecosystem productivity and evapotranspiration partitioning frameworks.
	- The PT-JPL-compatible mapping first constrains NDVI to plausible bounds and then applies a linear offset:
		```math
		fIPAR = \text{clip}(\text{clip}(NDVI, 0, 1) - 0.05, 0, 1)
		```
	- The inner clipping limits NDVI to standard normalized range; subtracting 0.05 applies an empirical threshold for low-vegetation/background conditions; the outer clipping enforces physical limits for a fraction.
- Parameters:
	- `NDVI`: Normalized Difference Vegetation Index as `numpy.ndarray` or `rasters.Raster`.
- Returns:
	- `fIPAR` in $[0, 1]$ with same container type (`numpy.ndarray` or `rasters.Raster`).
- Citation: Gower et al. (1999).

## References

- Fisher, J. B., et al. (2008). The land surface water and energy budget of the western United States based on MODIS satellite data. Water Resources Research, 44(9), W09422. https://doi.org/10.1029/2007WR006057
- Gower, S. T., Kucharik, C. J., & Norman, J. M. (1999). Direct and indirect estimation of leaf area index, fAPAR, and net primary production of terrestrial ecosystems. Remote Sensing of Environment, 70(1), 29-51. https://doi.org/10.1016/S0034-4257(99)00056-7
- Huete, A. R. (1988). A soil-adjusted vegetation index (SAVI). Remote Sensing of Environment, 25(3), 295-309. https://doi.org/10.1016/0034-4257(88)90106-X
