{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language TypeApplications     #-}
{-# language DataKinds     #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
-- {-# language OverloadedLabels #-} -- Optics

module Main where

import Mu.GRpc.Server
import Mu.Server

import Schema

import Data.Conduit as C
import Data.Conduit.List as C
--import Data.Conduit.Util as C

main :: IO ()
main = runGRpcApp msgProtoBuf 8080 server

server :: MonadServer m => SingleServerT i Service m _
server = singleService ( method @"SayHello" sayHello
                        , method @"SayManyHellos" sayManyHellos )

-- type Service
--   = 'Service "Greeter"
--       '[ 'Method "SayHello" sayHello
--        , 'Method "SayManyHellos" '[]
--         '[ 'ArgStream 'Nothing '[] ('FromSchema QuickstartSchema "HelloRequest")]
--         ('RetStream ('FromSchema QuickstartSchema "HelloResponse")) ]

sayHello :: (MonadServer m) => HelloRequestMessage -> m HelloReplyMessage
sayHello (HelloRequestMessage nm)
  = pure $ HelloReplyMessage ("hi, " <> nm)

sayManyHellos
  :: (MonadServer m)
  => ConduitT () HelloRequestMessage m ()
  -> ConduitT HelloReplyMessage Void m ()
  -> m ()

sayManyHellos source sink
  = runConduit $ source .| C.mapM sayHello .| sink

-- Optics
-- sayHello :: (MonadServer m) => HelloRequestMessage' -> m HelloReplyMessage'
-- sayHello (HelloRequestMessage nm)
--   = pure $ record ("hi, " <> nm ^. #name)