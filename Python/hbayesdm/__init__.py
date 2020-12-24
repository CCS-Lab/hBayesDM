# -*- coding: utf-8 -*-
try:
    import importlib.metadata as importlib_metadata
except ModuleNotFoundError:
    import importlib_metadata

import hbayesdm
from hbayesdm.diagnostics import *

__all__ = []
__all__ += hbayesdm.diagnostics.__all__

# Load version from the metadata
__version__ = importlib_metadata.version(__name__)
