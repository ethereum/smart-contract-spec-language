{-# LANGUAGE DeriveGeneric  #-}
{-# Language DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances  #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# Language TypeOperators #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE ApplicativeDo #-}

module CLI (main, compile, proceed) where

import Data.Aeson hiding (Bool, Number)
import GHC.Generics
import System.Exit ( exitFailure )
import System.IO (hPutStrLn, stderr, stdout)
import Data.Text (pack, unpack)
import Data.List
import Data.Maybe
import Data.Traversable
import qualified EVM.Solidity as Solidity
import qualified Data.Text as Text
import qualified Data.Text.IO as TIO
import qualified Data.Map.Strict as Map
import Text.PrettyPrint.ANSI.Leijen hiding ((<$>))

import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy.Char8 as B

import Control.Monad
import Control.Lens.Getter

import Error
import Lex (lexer, AlexPosn(..))
import Options.Generic
import Parse
import Syntax
import Syntax.Annotated
import Enrich
import K hiding (normalize, indent)
import SMT
import Type
import Coq hiding (indent)
import Expr

import Debug.Trace

import EVM.SymExec
import qualified EVM.Solvers as Solvers
import EVM.Solidity
import qualified EVM.Types as Types
import qualified EVM.Expr as Expr
import qualified EVM.Fetch as Fetch

--command line options
data Command w
  = Lex             { file       :: w ::: String               <?> "Path to file"}

  | Parse           { file       :: w ::: String               <?> "Path to file"}

  | Type            { file       :: w ::: String               <?> "Path to file"}

  | Prove           { file       :: w ::: String               <?> "Path to file"
                    , solver     :: w ::: Maybe Text           <?> "SMT solver: z3 (default) or cvc4"
                    , smttimeout :: w ::: Maybe Integer        <?> "Timeout given to SMT solver in milliseconds (default: 20000)"
                    , debug      :: w ::: Bool                 <?> "Print verbose SMT output (default: False)"
                    }

  | Coq             { file       :: w ::: String               <?> "Path to file"}

  | K               { spec       :: w ::: String               <?> "Path to spec"
                    , soljson    :: w ::: String               <?> "Path to .sol.json"
                    , gas        :: w ::: Maybe [(Id, String)] <?> "Gas usage per spec"
                    , storage    :: w ::: Maybe String         <?> "Path to storage definitions"
                    , extractbin :: w ::: Bool                 <?> "Put EVM bytecode in separate file"
                    , out        :: w ::: Maybe String         <?> "output directory"
                    }

  | HEVM            { spec       :: w ::: String               <?> "Path to spec"
                    , soljson    :: w ::: String               <?> "Path to .sol.json"
                    , solver     :: w ::: Maybe Text           <?> "SMT solver: z3 (default) or cvc4"
                    , smttimeout :: w ::: Maybe Integer        <?> "Timeout given to SMT solver in milliseconds (default: 20000)"
                    , debug      :: w ::: Bool                 <?> "Print verbose SMT output (default: False)"
                    }
 deriving (Generic)

deriving instance ParseField [(Id, String)]
instance ParseRecord (Command Wrapped)
deriving instance Show (Command Unwrapped)


-----------------------
-- *** Dispatch *** ---
-----------------------


main :: IO ()
main = do
    cmd <- unwrapRecord "Act -- Smart contract specifier"
    case cmd of
      Lex f -> lex' f
      Parse f -> parse' f
      Type f -> type' f
      Prove file' solver' smttimeout' debug' -> prove file' solver' smttimeout' debug'
      Coq f -> coq' f
      K spec' soljson' gas' storage' extractbin' out' -> k spec' soljson' gas' storage' extractbin' out'
      HEVM _ _ _ _ _ -> error "Unimplemented"
      -- HEVM spec' soljson' solver' smttimeout' debug' -> hevm spec' soljson' solver' smttimeout' debug'


---------------------------------
-- *** CLI implementation *** ---
---------------------------------


lex' :: FilePath -> IO ()
lex' f = do
  contents <- readFile f
  print $ lexer contents

parse' :: FilePath -> IO ()
parse' f = do
  contents <- readFile f
  validation (prettyErrs contents) print (parse $ lexer contents)

type' :: FilePath -> IO ()
type' f = do
  contents <- readFile f
  validation (prettyErrs contents) (B.putStrLn . encode) (enrich <$> compile contents)

type'' :: FilePath -> IO Act
type'' f = do
  contents <- readFile f
  validation (\_ -> pure $ Act Map.empty []) pure (enrich <$> compile contents)

prove :: FilePath -> Maybe Text -> Maybe Integer -> Bool -> IO ()
prove file' solver' smttimeout' debug' = do
  let
    parseSolver s = case s of
      Just "z3" -> SMT.Z3
      Just "cvc4" -> SMT.CVC4
      Nothing -> SMT.Z3
      Just _ -> error "unrecognized solver"
    config = SMT.SMTConfig (parseSolver solver') (fromMaybe 20000 smttimeout') debug'
  contents <- readFile file'
  proceed contents (enrich <$> compile contents) $ \claims -> do
    let
      catModels results = [m | Sat m <- results]
      catErrors results = [e | e@SMT.Error {} <- results]
      catUnknowns results = [u | u@SMT.Unknown {} <- results]

      (<->) :: Doc -> [Doc] -> Doc
      x <-> y = x <$$> line <> (indent 2 . vsep $ y)

      failMsg :: [SMT.SMTResult] -> Doc
      failMsg results
        | not . null . catUnknowns $ results
            = text "could not be proven due to a" <+> (yellow . text $ "solver timeout")
        | not . null . catErrors $ results
            = (red . text $ "failed") <+> "due to solver errors:" <-> ((fmap (text . show)) . catErrors $ results)
        | otherwise
            = (red . text $ "violated") <> colon <-> (fmap pretty . catModels $ results)

      passMsg :: Doc
      passMsg = (green . text $ "holds") <+> (bold . text $ "∎")

      accumulateResults :: (Bool, Doc) -> (Query, [SMT.SMTResult]) -> (Bool, Doc)
      accumulateResults (status, report) (query, results) = (status && holds, report <$$> msg <$$> smt)
        where
          holds = all isPass results
          msg = identifier query <+> if holds then passMsg else failMsg results
          smt = if debug' then line <> getSMT query else empty

    solverInstance <- spawnSolver config
    pcResults <- mapM (runQuery solverInstance) (mkPostconditionQueries claims)
    invResults <- mapM (runQuery solverInstance) (mkInvariantQueries claims)
    stopSolver solverInstance

    let
      invTitle = line <> (underline . bold . text $ "Invariants:") <> line
      invOutput = foldl' accumulateResults (True, empty) invResults

      pcTitle = line <> (underline . bold . text $ "Postconditions:") <> line
      pcOutput = foldl' accumulateResults (True, empty) pcResults

    render $ vsep
      [ ifExists invResults invTitle
      , indent 2 $ snd invOutput
      , ifExists pcResults pcTitle
      , indent 2 $ snd pcOutput
      ]

    unless (fst invOutput && fst pcOutput) exitFailure


coq' :: FilePath -> IO ()
coq' f = do
  contents <- readFile f
  proceed contents (enrich <$> compile contents) $ \claims ->
    TIO.putStr $ coq claims

k :: FilePath -> FilePath -> Maybe [(Id, String)] -> Maybe String -> Bool -> Maybe String -> IO ()
k spec' soljson' gas' storage' extractbin' out' = do
  specContents <- readFile spec'
  solContents  <- readFile soljson'
  let kOpts = KOptions (maybe mempty Map.fromList gas') storage' extractbin'
      errKSpecs = do
        behvs <- toEither $ behvsFromAct . enrich <$> compile specContents
        (Solidity.Contracts sources, _, _) <- validate [(nowhere, "Could not read sol.json")]
                              (Solidity.readStdJSON  . pack) solContents
        for behvs (makekSpec sources kOpts) ^. revalidate
  proceed specContents errKSpecs $ \kSpecs -> do
    let printFile (filename, content) = case out' of
          Nothing -> putStrLn (filename <> ".k") >> putStrLn content
          Just dir -> writeFile (dir <> "/" <> filename <> ".k") content
    forM_ kSpecs printFile


hevm :: FilePath -> Text -> FilePath -> IO [EquivResult]
hevm actspec cid sol = do
  specContents <- readFile actspec
  solContents  <- TIO.readFile sol
  let act = validation (\_ -> error "Too bad") id (enrich <$> compile specContents)
  bytecode <- fmap fromJust $ solcRuntime cid solContents
  let actbehvs = translateAct act
  Solvers.withSolvers Solvers.Z3 1 Nothing $ \solvers -> do
    solbehvs <- removeFails <$> getBranches solvers bytecode
    traceShowM solbehvs
    traceShowM actbehvs
    equivalenceCheck' solvers solbehvs actbehvs defaultVeriOpts
  where
    -- decompiles the given bytecode into a list of branches
    getBranches solvers bs = do
      let
        bytecode = if BS.null bs then BS.pack [0] else bs
        prestate = abstractVM calldata bytecode Nothing Types.AbstractStore
      expr <- interpret (Fetch.oracle solvers Nothing) Nothing 1 StackBased prestate runExpr
      let simpl = if True then (Expr.simplify expr) else expr
      pure $ flattenExpr simpl

    removeFails branches = filter isSuccess branches

    isSuccess (Types.Success _ _ _) = True
    isSuccess _ = False
                                    
    calldata = (Types.WriteByte (Types.Lit 0x0) (Types.LitByte 119) (Types.WriteByte (Types.Lit 0x1) (Types.LitByte 22) (Types.WriteByte (Types.Lit 0x2) (Types.LitByte 2) (Types.WriteByte (Types.Lit 0x3) (Types.LitByte 247) (Types.WriteWord (Types.Lit 0x4) (Types.Var "x") (Types.WriteWord (Types.Lit 0x24) (Types.Var "y") (Types.AbstractBuf "txdata")))))),[Types.PAnd (Types.PGEq (Types.Max (Types.Lit 0x44) (Types.BufLength (Types.AbstractBuf "txdata"))) (Types.Lit 0x44)) (Types.PLT (Types.Max (Types.Lit 0x44) (Types.BufLength (Types.AbstractBuf "txdata"))) (Types.Lit 0x10000000000000000)),Types.PAnd (Types.PGEq (Types.Var "y") (Types.Lit 0x0)) (Types.PLEq (Types.Var "y") (Types.Lit 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)),Types.PAnd (Types.PGEq (Types.Var "x") (Types.Lit 0x0)) (Types.PLEq (Types.Var "x") (Types.Lit 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff))])





-- hevm :: FilePath -> FilePath -> Maybe Text -> Maybe Integer -> Bool -> IO ()
-- hevm spec' soljson' solver' smttimeout' smtdebug' = do
--   specContents <- readFile spec'
--   solContents  <- readFile soljson'
--   let preprocess = do behvs <- behvsFromAct . enrich <$> compile specContents
--                       (sources, _, _) <- validate [(nowhere, "Could not read sol.json")]
--                         (Solidity.readJSON . pack) solContents
--                       pure (behvs, sources)
--   proceed specContents preprocess $ \(specs, sources) -> do
--     -- TODO: prove constructor too
--     passes <- forM specs $ \behv -> do
--       res <- runSMTWithTimeOut solver' smttimeout' smtdebug' $ proveBehaviour sources behv
--       case res of
--         Qed posts -> let msg = "Successfully proved " <> showBehv behv <> ", "
--                             <> show (length $ last $ levels posts) <> " cases."
--                       in putStrLn msg >> return (Right msg)
--         Cex _     -> let msg = "Failed to prove " <> showBehv behv
--                       in putStrLn msg >> return (Left msg)
--         Timeout _ -> let msg = "Solver timeout when attempting to prove " <> showBehv behv
--                       in putStrLn msg >> return (Left msg)
--     let failures = lefts passes

--     putStrLn . unlines $
--       if null failures
--         then [ "==== SUCCESS ===="
--              , "All behaviours implemented as specified ∎."
--              ]
--         else [ "==== FAILURE ===="
--              , show (length failures) <> " out of " <> show (length passes) <> " claims unproven:"
--              , ""
--              ]
--           <> zipWith (\i msg -> show (i::Int) <> "\t" <> msg) [1..] failures
--     unless (null failures) exitFailure
--   where
--     showBehv behv = _name behv

-------------------
-- *** Util *** ---
-------------------


-- cvc4 sets timeout via a commandline option instead of smtlib `(set-option)`
-- runSMTWithTimeOut :: Maybe Text -> Maybe Integer -> Bool -> Symbolic a -> IO a
-- runSMTWithTimeOut solver' maybeTimeout debug' sym
--   | solver' == Just "cvc4" = do
--       setEnv "SBV_CVC4_OPTIONS" ("--lang=smt --incremental --interactive --no-interactive-prompt --model-witness-value --tlimit-per=" <> show timeout)
--       res <- runSMTWith cvc4{verbose=debug'} sym
--       setEnv "SBV_CVC4_OPTIONS" ""
--       return res
--   | solver' == Just "z3" = runwithz3
--   | isNothing solver' = runwithz3
--   | otherwise = error "Unknown solver. Currently supported solvers; z3, cvc4"
--  where timeout = fromMaybe 20000 maybeTimeout
--        runwithz3 = runSMTWith z3{verbose=debug'} $ (setTimeOut timeout) >> sym

-- | Fail on error, or proceed with continuation
proceed :: Validate err => String -> err (NonEmpty (Pn, String)) a -> (a -> IO ()) -> IO ()
proceed contents comp continue = validation (prettyErrs contents) continue (comp ^. revalidate)

compile :: String -> Error String Act
compile = pure . annotate <==< typecheck <==< parse . lexer

prettyErrs :: Traversable t => String -> t (Pn, String) -> IO ()
prettyErrs contents errs = mapM_ prettyErr errs >> exitFailure
  where
  prettyErr (pn, msg) | pn == nowhere = do
    hPutStrLn stderr "Internal error:"
    hPutStrLn stderr msg
  prettyErr (pn, msg) | pn == lastPos = do
    let culprit = last $ lines contents
        line' = length (lines contents) - 1
        col  = length culprit
    hPutStrLn stderr $ show line' <> " | " <> culprit
    hPutStrLn stderr $ unpack (Text.replicate (col + length (show line' <> " | ") - 1) " " <> "^")
    hPutStrLn stderr msg
  prettyErr (AlexPn _ line' col, msg) = do
    let cxt = safeDrop (line' - 1) (lines contents)
    hPutStrLn stderr $ msg <> ":"
    hPutStrLn stderr $ show line' <> " | " <> head cxt
    hPutStrLn stderr $ unpack (Text.replicate (col + length (show line' <> " | ") - 1) " " <> "^")
    where
      safeDrop :: Int -> [a] -> [a]
      safeDrop 0 a = a
      safeDrop _ [] = []
      safeDrop _ [a] = [a]
      safeDrop n (_:xs) = safeDrop (n-1) xs

-- | prints a Doc, with wider output than the built in `putDoc`
render :: Doc -> IO ()
render doc = displayIO stdout (renderPretty 0.9 120 doc)
