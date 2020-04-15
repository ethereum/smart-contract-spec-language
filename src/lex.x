{
module Lex (LEX (..), Lexeme (..), lexer, showposn, AlexPosn, pos) where
import Prelude hiding (EQ, GT, LT)
}

%wrapper "posn"

$digit = 0-9                    -- digits
$alpha = [a-z A-Z]              -- alphabetic characters
$ident = [$alpha _]
$space = [\ \t\f\v\r]

tokens :-

  -- ($space* \n)+       { mk BREAK }
  -- $space+             ;
  $white+                               ;

  -- reserved words
  behaviour                             { mk BEHAVIOUR }
  of                                    { mk OF }
  interface                             { mk INTERFACE }
  constructor                           { mk CONSTRUCTOR }
  creates                               { mk CREATES }
  case                                  { mk CASE }
  returns                               { mk RETURNS }
  storage                               { mk STORAGE }
  noop                                  { mk NOOP } 
  
  iff $white+ in $white+ range          { mk IFFINRANGE }
  iff                                   { mk IFF }
  and                                   { mk AND }
  or                                    { mk OR }
  true                                  { mk TRUE }
  false                                 { mk FALSE }
  mapping                               { mk MAPPING }
  ensures                               { mk ENSURES }
  invariants                            { mk INVARIANTS }
  if                                    { mk IF }
  then                                  { mk THEN }
  else                                  { mk ELSE }
  at                                    { mk AT }

  -- builtin types
  uint $digit+                   { \ p s -> L (UINT (read (drop 4 s))) p }
  int  $digit+                   { \ p s -> L (INT  (read (drop 3 s))) p }
  uint                           { mk (UINT 256) }
  int                            { mk (INT 256) }
  bytes $digit+                  { \ p s -> L (BYTES (read (drop 5 s))) p }
  bytes                          { error "TODO" }
  address                        { mk ADDRESS }
  bool                           { mk BOOL }
  string                         { mk STRING }

  -- builtin functions
  newAddr                        { mk NEWADDR }

  -- symbols
  ":="                                  { mk ASSIGN }
  "=>"                                  { mk ARROW }
  -- "->"                                  { mk ARROW' }
  "=="                                  { mk EQEQ }
  "=/="                                 { mk NEQ }
  ">="                                  { mk GE }
  "<="                                  { mk LE }
  "++"                                  { mk CAT }
  ".."                                  { mk SLICE }
  "("                                   { mk LPAREN }
  ")"                                   { mk RPAREN }
  "["                                   { mk LBRACK }
  "]"                                   { mk RBRACK }
  "="                                   { mk EQ }
  ">"                                   { mk GT }
  "<"                                   { mk LT }
  ":"                                   { mk COLON }
  "+"                                   { mk PLUS }
  "-"                                   { mk MINUS }
  "*"                                   { mk STAR }
  "/"                                   { mk SLASH }
  "%"                                   { mk MOD }
  "^"                                   { mk CARROT }
  "_"                                   { mk SCORE }
  "."                                   { mk DOT }
  ","                                   { mk COMMA }
  "//"                                  [.]* ; -- Toss single line comments
  -- identifiers
  $ident ($ident | $digit)*   { \ p s -> L (ID s) p }

  -- literals
  $digit+                     { \ p s -> L (ILIT (read s)) p }
{

data LEX =

    BREAK
  | EOF

  -- reserved words
  | BEHAVIOUR
  | OF       
  | INTERFACE
  | CONSTRUCTOR
  | CREATES
  | CASE
  | RETURNS
  | STORAGE
  | NOOP
  | IFFINRANGE
  | IFF
  | AND
  | OR
  | TRUE
  | FALSE
  | MAPPING
  | ENSURES
  | INVARIANTS
  | IF
  | THEN
  | ELSE
  | AT

  -- builtin types
  | UINT  Int
  | INT   Int
  | BYTES Int
  | ADDRESS
  | BOOL
  | STRING

  -- builtin functions
  | NEWADDR

  -- symbols
  | ASSIGN
  | ARROW
  | EQEQ
  | NEQ
  | GE
  | LE
  | CAT
  | SLICE
  | LPAREN
  | RPAREN
  | LBRACK
  | RBRACK
  | EQ
  | GT
  | LT
  | COLON
  | PLUS
  | MINUS
  | STAR
  | SLASH
  | MOD
  | CARROT
  | SCORE
  | DOT
  | COMMA

  -- identifiers
  | ID String

  -- literals
  | ILIT Integer

  deriving (Eq, Show)

data Lexeme = L LEX AlexPosn
  deriving (Eq, Show)

-- annoying that we can't override the show instance for this here
showposn (AlexPn _ line column) =
  concat [show line, ":", show column]

pos :: Lexeme -> AlexPosn
pos (L _ p) = p

-- helper function to reduce boilerplate
mk :: LEX -> (AlexPosn -> String -> Lexeme)
mk lexeme p _ = L lexeme p

lexer :: String -> [Lexeme]
lexer = alexScanTokens
}