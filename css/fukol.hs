{-# LANGUAGE OverloadedStrings #-}
import           Clay

test :: Css
test = body ?
       do background black
          color      green
          border     dashed (px 2) yellow

main :: IO ()
main = putCss test

-- .fukol-grid {
--   display: flex; /* 1 */
--   flex-wrap: wrap; /* 2 */
--   margin: -0.5em; /* 5 (edit me!) */
-- }

-- .fukol-grid > * {
--   flex: 1 0 5em; /* 3 (edit me!) */
--   margin: 0.5em; /* 4 (edit me!) */
-- }
