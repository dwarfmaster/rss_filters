
module Filters (Filter, filters) where

import           Filters.Util
import qualified Filters.Rename as RN

filters :: [(String, Filter)]
filters = [ ("rename" , RN.filter)
          ]

