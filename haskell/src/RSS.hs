
module RSS ( RSSFeed(..), RSSItem(..)
           , generateFeed
           ) where

import Text.XML.HXT.Core

data RSSFeed = RSSFeed
             { feed_title       :: String
             , feed_link        :: String
             , feed_description :: String
             }

data RSSItem = RSSItem
             { item_title       :: String
             , item_link        :: String
             , item_description :: String
             }

generateItem :: ArrowXml a => a RSSItem XmlTree
generateItem =
    selem "item"
        [ selem "title"       [ arr item_title       >>> mkText ]
        , selem "link"        [ arr item_link        >>> mkText ]
        , selem "description" [ arr item_description >>> mkText ]
        ]

generateFeed :: ArrowXml a => a b RSSFeed -> a b RSSItem -> a b XmlTree
generateFeed feed_arrow item_arrow =
     (feed_arrow &&& item_arrow)
 >>> mkelem "rss" [ sattr "version"    "2.0"
                  , sattr "xmlns:atom" "http://www.w3.org/2005/Atom"
                  ]
         [ selem "title"       [ arr fst >>> arr feed_title       >>> mkText ]
         , selem "link"        [ arr fst >>> arr feed_link        >>> mkText ]
         , selem "description" [ arr fst >>> arr feed_description >>> mkText ]
         , arr snd >>> generateItem
         ]

