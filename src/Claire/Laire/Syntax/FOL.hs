module Claire.Laire.Syntax.FOL where

import Data.Set as S

type Ident = String
type PSymbol = String

data Term = Var Ident | Func Ident [Term] deriving (Eq, Show)

data Formula
  = Pred PSymbol [Term]
  | Top
  | Bottom
  | Formula :/\: Formula
  | Formula :\/: Formula
  | Formula :->: Formula
  | Forall Ident Formula
  | Exist Ident Formula
  deriving (Eq, Show)

pattern Const c = Pred c []
pattern Neg a = a :->: Bottom

fv :: Formula -> S.Set Ident
fv = go where
  fvt (Var v) = S.singleton v
  fvt (Func _ ts) = S.unions $ fmap fvt ts
  
  go (Pred p ts) = S.unions $ fmap fvt ts
  go Top = S.empty
  go Bottom = S.empty
  go (f1 :/\: f2) = S.union (fv f1) (fv f2)
  go (f1 :\/: f2) = S.union (fv f1) (fv f2)
  go (f1 :->: f2) = S.union (fv f1) (fv f2)
  go (Forall v f) = S.delete v $ fv f
  go (Exist v f) = S.delete v $ fv f

substTerm :: Ident -> Term -> Formula -> Formula
substTerm idt t' = go where
  got (Var i)
    | i == idt = t'
    | otherwise = Var i
  got (Func f ts) = Func f $ fmap got ts
  
  go (Pred p ts) = Pred p $ fmap got ts
  go Top = Top
  go Bottom = Bottom
  go (f1 :/\: f2) = go f1 :/\: go f2
  go (f1 :\/: f2) = go f1 :\/: go f2
  go (f1 :->: f2) = go f1 :->: go f2
  go (Forall x fml) = Forall x (go fml)
  go (Exist x fml) = Exist x (go fml)


