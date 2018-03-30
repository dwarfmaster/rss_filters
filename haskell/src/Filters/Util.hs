
module Filters.Util where

import Text.XML.HXT.Core

-- Assumes the in and out data are well formed RSS feed
-- Can depend on command line arguments
type Filter = [String] -> IOSLA (XIOState ()) XmlTree XmlTree

