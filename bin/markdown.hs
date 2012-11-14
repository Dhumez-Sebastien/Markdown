module Main where

import Markdown
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import System.Environment
import Data.List (partition)
import Data.Text (Text)
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text.IO as T
import qualified Data.Text as T

convert :: [String] -> Text -> IO ()
convert opts = render . parseMarkdown
    where render = if "-n" `elem` opts
                      then print
                      else BL.putStr . renderHtml . renderBlocks

-- main loop

main :: IO ()
main = do
  args <- getArgs
  let isOpt ('-':_) = True
      isOpt _       = False
  let (opts, files) = partition isOpt args
  case files of
       [] -> T.getContents >>= convert opts
       _  -> mapM T.readFile files >>= convert opts . T.unlines

