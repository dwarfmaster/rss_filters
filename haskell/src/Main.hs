
module Main where

import Text.XML.HXT.Core
import Text.XML.HXT.Arrow.XmlState.RunIOStateArrow
import System.Environment
import RSS
import Scrappers
import Filters

runScrapper :: Scrapper -> [String] -> IOSLA (XIOState ()) () ()
runScrapper scrapper args = let (afeed, aitem) = scrapper args in
     readDocument [ withValidate  no
                  , withParseHTML yes
                  , withWarnings  no
                  ]
                  ""
 >>> generateFeed afeed aitem
 >>> writeDocument [ withIndent yes ] ""
 >>^ const ()

runFilter :: Filter -> [String] -> IOSLA (XIOState ()) () ()
runFilter flt args = let arrow = flt args in
     readDocument [ withValidate no
                  , withWarnings no
                  ]
                  ""
 >>> arrow
 >>> writeDocument [ withIndent yes ] ""
 >>^ const ()

run :: String -> [String] -> IO ()
run cmd args = case lookup cmd scrappers of
                   Just sc -> runIOSLA (runScrapper sc args)
                                       (initialState ())
                                       ()
                           >> return ()
                   Nothing -> case lookup cmd filters of
                                Just flt -> runIOSLA (runFilter flt args)
                                                     (initialState ())
                                                     ()
                                         >> return ()            
                                Nothing  -> return ()

main :: IO ()
main = do
    ags <- getArgs
    case ags of
      cmd:args -> run cmd args
      []       -> putStrLn "usage: program command_name [scrapper_arg*]"

