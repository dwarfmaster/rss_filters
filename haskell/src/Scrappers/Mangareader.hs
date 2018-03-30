{-# LANGUAGE TupleSections #-}

module Scrappers.Mangareader (scrapper) where

import Text.XML.HXT.Core
import Data.Monoid
import Data.Maybe (isNothing)
import Scrappers.Util
import RSS

scrapper :: Scrapper
scrapper = const (scrap_feed, scrap_item)

weblink :: String
weblink = "https://www.mangareader.net"

scrap_feed :: ArrowXml a => a XmlTree RSSFeed
scrap_feed = (
   ( deep $
           isElem >>> hasName "div"
       >>> hasAttr "id" >>> hasAttrValue "id" (== "mangaproperties")
        /> isElem >>> hasName "h1"
        /> isText >>> getText
   )
   &&&
   ( deep $
           isElem >>> hasName "div"
       >>> hasAttr "id" >>> hasAttrValue "id" (== "readmangasum")
        /> isElem >>> hasName "p"
        /> isText >>> getText
   )
 ) >>^ \(title,desc) -> RSSFeed title weblink desc

scrap_item :: ArrowXml a => a XmlTree RSSItem
scrap_item = deep $
     isElem >>> hasName "div"
 >>> hasAttr "id" >>> hasAttrValue "id" (== "latestchapters")
  /> isElem >>> hasName "ul"
  /> isElem >>> hasName "li"
  /> ( ( (isElem >>> hasName "a" >>> ( (getAttrValue "href" >>^ Just)
                                   &&& (getChildren >>> isText >>> getText)
                                     )
         )
     <+> (isText >>> getText >>^ (Nothing,))
       )
    >. foldl (\(a,b) (c,d) -> (getAnyM a c, b <> d)) (Nothing, "")
   >>> isA (not . isNothing . fst)
   >>^ \(Just link, title) -> RSSItem { item_title        = title
                                      , item_link         = weblink <> link
                                      , item_description  = title <> " -- " <> link
                                      }
     )
 where getAnyM :: Maybe a -> Maybe a -> Maybe a
       getAnyM (Just x) _ = Just x
       getAnyM _        y = y

