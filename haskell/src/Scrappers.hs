
module Scrappers (Scrapper, scrappers) where

import           Scrappers.Util
import qualified Scrappers.Mangareader as MR
import qualified Scrappers.Mangahere   as MH
import qualified Scrappers.Mangainn    as MI

scrappers :: [(String, Scrapper)]
scrappers = [ ("mangareader" , MR.scrapper)
            , ("mangahere"   , MH.scrapper)
            , ("mangainn"    , MI.scrapper)
            ]

