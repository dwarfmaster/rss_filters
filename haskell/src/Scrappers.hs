
module Scrappers (Scrapper, scrappers) where

import           Scrappers.Util
import qualified Scrappers.Mangareader as MR
import qualified Scrappers.Mangahere   as MH

scrappers :: [(String, Scrapper)]
scrappers = [ ("mangareader" , MR.scrapper)
            , ("mangahere"   , MH.scrapper)
            ]

