
module Filters.Rename (filter) where

import Prelude      hiding (filter)
import Text.XML.HXT.Core
import Filters.Util

filter :: Filter
filter (newname : _) = processTopDown $ rss_transform newname
filter []            = arr id

rss_transform :: ArrowXml a => String -> a XmlTree XmlTree
rss_transform name = ifA (isElem >>> hasName "rss")
                       (replaceChildren $ getChildren >>> transform name)
                       (arr id)

transform :: ArrowXml a => String -> a XmlTree XmlTree
transform name = ifA (isElem >>> hasName "title")
                   (selem "title" [ constA name >>> mkText ])
                   (arr id)

