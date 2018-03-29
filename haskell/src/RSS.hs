
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

generateFeed :: ArrowXml a => RSSFeed -> a b RSSItem -> a b XmlTree
generateFeed (RSSFeed title link description) item_arrow =
    mkelem "rss" [ sattr "version"    "2.0"
                 , sattr "xmlns:atom" "http://www.w3.org/2005/Atom"
                 ]
        [ selem "title"       [ txt title       ]
        , selem "link"        [ txt link        ]
        , selem "description" [ txt description ]
        , item_arrow >>> generateItem
        ]

