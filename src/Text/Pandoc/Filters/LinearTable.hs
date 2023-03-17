{-|
Module      : LinearTable
Description : An easy way to create tables with wrapped text in Markdown.
Copyright   : (c) 2020-2023 Amy de Buitléir
License     : BSD--3
Maintainer  : amy@nualeargais.ie
Stability   : experimental
Portability : POSIX

See <https://github.com/mhwombat/pandoc-linear-table> for information
on how to use this filter.
-}

{-# LANGUAGE OverloadedStrings #-}

module Text.Pandoc.Filters.LinearTable
  (
    transform,
    formatLinearTable
  ) where

import Data.Foldable    (foldl')
import Data.Text        qualified as T
import Text.Pandoc      qualified as P
import Text.Pandoc.Walk (walk)


-- | A transformation that can be used with Hakyll.
transform :: P.Pandoc -> P.Pandoc
transform = walk formatLinearTable

-- | Exported for use by the executable.
formatLinearTable :: P.Block -> P.Block
formatLinearTable x@(P.CodeBlock (_,cs,_) s)
  | null cs                  = x
  | head cs == "linear-table" = toTable . splitRows $ T.lines s
  | otherwise                = x
formatLinearTable x = x

toTable :: [[T.Text]] -> P.Block
toTable xss = P.Table attr defaultTableCaption colSpecs
                    defaultTableHeader [toTableBody xss]
                    defaultTableFooter
  where attr = ("",["linear-table"],[])
        colSpecs = replicate nCols defaultColSpec
        nCols = maximum $ map length xss


toTableBody :: [[T.Text]] -> P.TableBody
toTableBody = P.TableBody P.nullAttr (P.RowHeadColumns 0) []
                  . map toTableRow


toTableRow :: [T.Text] -> P.Row
toTableRow = P.Row P.nullAttr . map toCell

toCell :: T.Text -> P.Cell
toCell = blocksToCell . map removePara . parseBlocks

blocksToCell :: [P.Block] -> P.Cell
blocksToCell
  = P.Cell P.nullAttr P.AlignDefault (P.RowSpan 1) (P.ColSpan 1)

removePara :: P.Block -> P.Block
removePara (P.Para xs) = P.Plain xs
removePara x           = x

splitRows :: Foldable t => t T.Text -> [[T.Text]]
splitRows xs = reverse . map reverse $ foldl' splitter [] xs

splitter :: [[T.Text]] -> T.Text -> [[T.Text]]
splitter [] x | x == ""    = []
              | otherwise = [[x]]
splitter accum x | x == ""    = []:accum
                 | otherwise = (x:(head accum)) : tail accum




readDefaults :: P.ReaderOptions
readDefaults = P.def { P.readerStandalone = True,
                       P.readerExtensions = P.pandocExtensions }

parseBlocks :: T.Text -> [P.Block]
parseBlocks s = f . P.runPure $ P.readMarkdown readDefaults s
  where f (Right (P.Pandoc _ bs)) = bs
        f (Left e) = error $ "readMarkdown failed: " ++ show e

defaultColSpec :: P.ColSpec
defaultColSpec = (P.AlignDefault, P.ColWidthDefault)

defaultTableCaption :: P.Caption
defaultTableCaption = P.Caption Nothing []

defaultTableHeader :: P.TableHead
defaultTableHeader = P.TableHead P.nullAttr []

defaultTableFooter :: P.TableFoot
defaultTableFooter = P.TableFoot P.nullAttr []
