
module Scrappers.Mangahere (scrapper) where

import Text.XML.HXT.Core
import Data.Monoid
import Data.Char
import Scrappers.Util
import RSS

scrapper :: Scrapper
scrapper = (scrap_feed, scrap_item)

weblink :: String
weblink = "http://www.mangahere.cc"

scrap_feed :: ArrowXml a => a XmlTree RSSFeed
scrap_feed = deep $
     isElem >>> hasName "ul"
 >>> hasAttr "class" >>> hasAttrValue "class" (== "detail_topText")
  /> isElem >>> hasName "li"
 >>> ( (getChildren >>> isElem >>> hasName "label"
                     /> isElem >>> hasName "h2"
                     /> isText >>> getText
       )
   &&& (getChildren >>> isElem >>> hasName "p"
                    >>> hasAttr "id" >>> hasAttrValue "id" (== "show")
                     /> isText >>> getText
       )
     )
 >>^ \(title,desc) -> RSSFeed { feed_title       = title
                              , feed_link        = weblink
                              , feed_description = desc
                              }

scrap_item :: ArrowXml a => a XmlTree RSSItem
scrap_item = deep $
     isElem >>> hasName "div"
 >>> hasAttr "class" >>> hasAttrValue "class" (== "detail_list")
  /> isElem >>> hasName "ul"
  /> isElem >>> hasName "li"
  /> isElem >>> hasName "span"
 >>> hasAttr "class" >>> hasAttrValue "class" (== "left")
 >>> ( (getChildren >>> isElem >>> hasName "a"
                    >>> hasAttr "href" >>> getAttrValue "href"
       )
   &&& ( ( getChildren >>> ( ( isElem >>> hasName "a"
                            /> isText >>> getText
                             )
                         <+> ( isText >>> getText )
                           )
         ) >. sanitize . mconcat
       )
     )
 >>^ \(link,title) -> RSSItem { item_title       = title
                              , item_link        = "http:" <> link
                              , item_description = title <> " -- http:" <> link
                              }
 where sanitize' :: String -> String
       sanitize' (' ' : ' ' : str) = sanitize $ ' ' : str
       sanitize' (x : str)         = x : sanitize str
       sanitize' []                = []
       sanitize :: String -> String
       sanitize str = sanitize' $ map (\c -> if isSpace c then ' ' else c) str

