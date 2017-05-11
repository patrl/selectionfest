--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Control.Monad (liftM)
import           Hakyll
import           Text.Pandoc.Options


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
  match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

  match "documents/*" $ do
        route   idRoute
        compile copyFileCompiler

  match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

  match "*.md" $ do
        route   $ setExtension "html"
        compile $ bibtexCompiler "cls/chicago-author-date.csl" "bib/elliott_mybib.bib"
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls


  match "bib/*" $ compile biblioCompiler

  match "cls/*" $ compile cslCompiler

  match "*.html" $ do
    route idRoute
    compile $ do
      let indexCtx =
            defaultContext

      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

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
