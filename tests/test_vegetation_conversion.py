import numpy as np

from vegetation_conversion import SAVI_from_NDVI, fAPAR_from_SAVI, fIPAR_from_NDVI


def test_SAVI_from_NDVI_formula():
    ndvi = np.array([0.0, 0.5, 1.0])
    expected = ndvi * 0.45 + 0.132
    actual = SAVI_from_NDVI(ndvi)
    np.testing.assert_allclose(actual, expected)


def test_fAPAR_from_SAVI_formula_and_clipping():
    savi = np.array([-1.0, 0.0, 0.5, 1.0, 2.0])
    expected = np.clip(savi * 1.3632 - 0.048, 0, 1)
    actual = fAPAR_from_SAVI(savi)
    np.testing.assert_allclose(actual, expected)


def test_fIPAR_from_NDVI_formula_and_clipping():
    ndvi = np.array([-1.0, 0.0, 0.2, 1.0, 2.0])
    expected = np.clip(np.clip(ndvi, 0, 1) - 0.05, 0, 1)
    actual = fIPAR_from_NDVI(ndvi)
    np.testing.assert_allclose(actual, expected)
