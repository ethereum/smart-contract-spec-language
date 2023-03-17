{-# LANGUAGE GADTs #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- These extensions should be removed once we remove the defs at the end of this file.
{-# LANGUAGE RankNTypes, TypeApplications, StandaloneKindSignatures, PolyKinds #-}

{-|
Module      : Syntax.Types
Description : Types that represent Act types, and functions and patterns to go between them and Haskell's own types.
-}

module Syntax.Types (module Syntax.Types) where

import Data.Singletons
import Data.ByteString    as Syntax.Types (ByteString)
import Data.Type.Equality (TestEquality(..), (:~:)(..))
import EVM.ABI            as Syntax.Types (AbiType(..))

-- | Types of Act expressions
data ActType
  = AInteger
  | ABoolean
  | AByteStr

-- | Singleton runtime witness for Act types
-- Sometimes we need to examine type tags at runime. Tagging structures
-- with this type will let us do that. 
data SType (a :: ActType) where
  SInteger :: SType AInteger
  SBoolean :: SType ABoolean
  SByteStr :: SType AByteStr
deriving instance Show (SType a)
deriving instance Eq (SType a)

type instance Sing = SType

instance TestEquality SType where
  testEquality SInteger SInteger = Just Refl
  testEquality SBoolean SBoolean = Just Refl
  testEquality SByteStr SByteStr = Just Refl
  testEquality _ _ = Nothing

-- | Compare equality of two things parametrized by types which have singletons.
eqS :: forall a b f t. Eq (f a t) => SType a -> f a t -> SType b -> f b t -> Bool
eqS sa ea sb eb = case testEquality sa sb of
                       Just Refl -> ea == eb
                       _ -> False

-- | Reflection of an Act type into a haskell type. Usefull to define
-- the result type of the evaluation function.
type family TypeOf a where
  TypeOf 'AInteger = Integer
  TypeOf 'ABoolean = Bool
  TypeOf 'AByteStr = ByteString

actType :: AbiType -> ActType
actType (AbiUIntType _)     = AInteger
actType (AbiIntType  _)     = AInteger
actType AbiAddressType      = AInteger
actType AbiBoolType         = ABoolean
actType (AbiBytesType n)    = if n <= 32 then AInteger else AByteStr
actType AbiBytesDynamicType = AByteStr
actType AbiStringType       = AByteStr
actType _ = error "Syntax.Types.actType: TODO"


someType :: ActType -> SomeType
someType AInteger = SomeType SInteger
someType ABoolean = SomeType SBoolean
someType AByteStr = SomeType SByteStr


data SomeType where
  SomeType :: SType a -> SomeType
  
-- | Pattern match on an 'SomeType' is if it were an 'SType'.
pattern FromSome :: SType a -> SomeType
pattern FromSome t <- SomeType t

-- | Pattern match on an 'AbiType' is if it were an 'SType'.
pattern FromAbi :: SType a -> AbiType
pattern FromAbi t <- (someType . actType -> FromSome t)

-- | Pattern match on an 'ActType' is if it were an 'SType'.
pattern FromAct :: SType a -> ActType
pattern FromAct t <- (someType -> FromSome t)
