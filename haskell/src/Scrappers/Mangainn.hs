
module Scrappers.Mangainn (scrapper) where

import Text.XML.HXT.Core
import Data.Monoid
import Data.Char
import Scrappers.Util
import RSS

scrapper :: Scrapper
scrapper = (scrap_feed, scrap_item)

weblink :: String
weblink = "http://www.mangainn.net"

scrap_feed :: ArrowXml a => a XmlTree RSSFeed
scrap_feed = deep $
     isElem >>> hasName "div"
 >>> hasAttr "class" >>> hasAttrValue "class" (== "container manga-info")
 >>> ( (deep $ isElem >>> hasName "img"
           >>> hasAttr "class" >>> hasAttrValue "class" (== "img-responsive mobile-img")
           >>> hasAttr "alt" >>> getAttrValue "alt"
       )
   &&& (deep $ isElem >>> hasName "div"
           >>> hasAttr "class" >>> hasAttrValue "class"
                                                (== "note note-default margin-top-15")
            /> isText >>> getText
       )
     )
 >>^ \(title,desc) -> RSSFeed { feed_title       = title
                              , feed_link        = weblink
                              , feed_description = sanitize desc
                              }

scrap_item :: ArrowXml a => a XmlTree RSSItem
scrap_item = deep $
     isElem >>> hasName "ul"
 >>> hasAttr "class" >>> hasAttrValue "class" (== "chapter-list")
  /> isElem >>> hasName "li"
  /> isElem >>> hasName "a"
 >>> ( ( hasAttr "href" >>> getAttrValue "href" )
   &&& ( getChildren >>> isElem >>> hasName "span"
                     >>> hasAttr "class" >>> hasAttrValue "class" (== "val")
                      /> isText >>> getText
       )
     )
 >>^ \(link,title) -> RSSItem { item_title       = sanitize title
                              , item_link        = link
                              , item_description = sanitize title <> " -- " <> link
                              }

sanitize' :: String -> String
sanitize' (' ' : ' ' : str) = sanitize $ ' ' : str
sanitize' (x : str)         = x : sanitize str
sanitize' []                = []
sanitize :: String -> String
sanitize str = sanitize' $ map (\c -> if isSpace c then ' ' else c) str

