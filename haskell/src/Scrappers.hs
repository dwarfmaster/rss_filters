
module Scrappers (Scrapper, scrappers) where

import           Scrappers.Util
import qualified Scrappers.Mangareader as MR

scrappers :: [(String, Scrapper)]
scrappers = [ ("mangareader", MR.scrapper)
            ]

