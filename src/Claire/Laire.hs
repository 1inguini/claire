module Claire.Laire
  ( Rule(..)
  , Judgement(..)

  , module Claire.Laire.Syntax
  , pLaire
  , pDecl
  , pCommand
  , pFormula
  , pTerm

  , Env(..)
  , insertThm
  , defEnv
  ) where

import Claire.Laire.Syntax
import Claire.Laire.Lexer
import Claire.Laire.Parser
import qualified Data.Map as M

pLaire :: String -> Laire
pLaire = laireparser . alexScanTokens

pDecl :: String -> Decl
pDecl = declparser . alexScanTokens

pCommand :: String -> Command
pCommand = comparser . alexScanTokens

pFormula :: String -> Formula
pFormula = folparser . alexScanTokens

pTerm :: String -> Term
pTerm = termparser . alexScanTokens


data Env
  = Env
  { thms :: M.Map ThmIndex Formula
  , terms :: M.Map Ident Term
  }
  deriving Show

insertThm :: ThmIndex -> Formula -> Env -> Env
insertThm idx fml env = env { thms = M.insert idx fml (thms env) }

defEnv :: Env
defEnv = Env M.empty M.empty


