{
module Claire.FOL.Parser where

import Claire.FOL.Syntax
import Claire.FOL.Lexer
}

%name folparser
%name termparser Term

%tokentype { Token }

%token
  forall   { TokenForall }
  exist    { TokenExist }
  top      { TokenTop }
  bottom   { TokenBottom }
  '->'     { TokenArrow }
  and      { TokenAnd }
  or       { TokenOr }
  '.'      { TokenDot }
  ','      { TokenComma }
  ')'      { TokenRParen }
  '('      { TokenLParen }
  var      { TokenSym $$ }

%%

Formula
  : Formula '->' Formula    { $1 :->: $3 }
  | forall var '.' Formula  { Forall $2 $4 }
  | exist var '.' Formula   { Exist $2 $4 }
  | Formula or Formula      { $1 :\/: $3 }
  | Formula and Formula     { $1 :/\: $3 }
  | top                     { Top }
  | bottom                  { Bottom }
  | '(' Formula ')'         { $2 }
  | var '(' Terms ')'       { Pred $1 $3 }
  | var                     { Pred $1 [] }

Terms
  : Term  { [$1] }
  | Term ',' Terms  { $1 : $3 }

Term
  : var  { Var $1 }
  | var '(' Terms ')'  { Func $1 $3 }

{
happyError s = error $ show s
}
