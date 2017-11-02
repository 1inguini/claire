module Main where

import Control.Monad
import qualified Data.Map as M
import Text.Trifecta hiding (Source)
import Text.PrettyPrint.ANSI.Leijen (putDoc)
import System.IO
import Claire

main :: IO ()
main = forever $ do
  putStr "thm>" >> hFlush stdout
  fml <- pFormula <$> getLine

  run [Judgement M.empty fml]
  where
    run js = do
      putStrLn $ "goal>" ++ show (head js)
      when (length js >= 2) $ putStrLn $ "...and " ++ show (length js - 1) ++ " more goals"

      putStr "command>" >> hFlush stdout
      mcom <- pCommand <$> getLine
      case mcom of
        Success com -> 
          case com of
            Apply rs -> 
              case checker rs js of
                Left (r,j) -> putStrLn ("Cannot apply " ++ show r ++ " to " ++ show j) >> run js
                Right [] -> putStrLn "QED."
                Right js' -> run js'
            Pick -> return ()
        Failure err -> do
          putDoc $ _errDoc err
          run js


