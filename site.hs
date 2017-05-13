--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Control.Monad (liftM)
import           Hakyll
import           Text.Pandoc.Options
import qualified Data.ByteString.Lazy.Char8 as C
import           Text.Jasmine


--------------------------------------------------------------------------------

compressJsCompiler :: Compiler (Item String)
compressJsCompiler = do
  let minifyJS = C.unpack . minify . C.pack . itemBody
  s <- getResourceString
  return $ itemSetBody (minifyJS s) s

main :: IO ()
main = hakyllWith config $ do
  match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

  match "documents/*" $ do
        route   idRoute
        compile copyFileCompiler

  match "node_modules/tachyons/css/tachyons.min.css" $ do
        route $ customRoute (const "css/tachyons.min.css")
        compile copyFileCompiler

  match "node_modules/jquery/dist/jquery.slim.min.js" $ do
        route $ customRoute (const "js/jquery.slim.min.js")
        compile copyFileCompiler

  match "js/*" $ do
    route   idRoute
    compile compressJsCompiler

  match "*.md" $ do
        route   $ setExtension "html"
        compile $ bibtexCompiler "cls/chicago-author-date.csl" "bib/elliott_mybib.bib"
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls


  match "bib/*" $ compile biblioCompiler

  match "cls/*" $ compile cslCompiler

  match "templates/*" $ compile templateBodyCompiler

config :: Configuration
config = defaultConfiguration
    { deployCommand = "git stash && git checkout develop && stack exec site clean && stack exec site build && git fetch --all && git checkout -b master --track origin/master && cp -a _site/. . && git add -A && git commit -m \"Publish.\" && git push origin master:master && git checkout develop && git branch -D master && git stash pop"
    }

bibtexCompiler :: String -> String -> Compiler (Item String)
bibtexCompiler cslFileName bibFileName = do
    csl <- load $ fromFilePath cslFileName
    bib <- load $ fromFilePath bibFileName
    liftM writePandoc
        (getResourceBody >>= readPandocBiblio def csl bib)
