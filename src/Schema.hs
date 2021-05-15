{-# language DataKinds             #-}
{-# language DeriveAnyClass        #-}
{-# language DeriveGeneric         #-}
{-# language DuplicateRecordFields #-}
{-# language FlexibleContexts      #-}
{-# language FlexibleInstances     #-}
{-# language MultiParamTypeClasses #-}
{-# language PolyKinds             #-}
{-# language TemplateHaskell       #-}
{-# language TypeFamilies          #-}
{-# language TypeOperators         #-}

module Schema where

import Data.Text as T
import GHC.Generics

import Mu.Quasi.GRpc
import Mu.Schema

grpc "TheSchema" id "MuHaskellIntro.proto"

-- A. Map to Haskell types
data HelloRequestMessage
  = HelloRequestMessage { name :: T.Text }
  deriving (Eq, Show, Generic
           , ToSchema   TheSchema "HelloRequest"
           , FromSchema TheSchema "HelloRequest")

data HelloReplyMessage
  = HelloReplyMessage { message :: T.Text }
  deriving (Eq, Show, Generic
           , ToSchema   TheSchema "HelloReply"
           , FromSchema TheSchema "HelloReply")

-- B. Use optics
-- type HelloRequestMessage' = Term TheSchema (TheSchema :/: "HelloRequest")
-- type HelloReplyMessage'   = Term TheSchema (TheSchema :/: "HelloReply")