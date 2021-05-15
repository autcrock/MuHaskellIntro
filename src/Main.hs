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

main :: IO ()
main = runGRpcApp msgProtoBuf 8080 server

server :: MonadServer m => SingleServerT i Service m _
server = singleService (method @"SayHello" sayHello)

sayHello :: (MonadServer m) => HelloRequestMessage -> m HelloReplyMessage
sayHello (HelloRequestMessage nm)
  = pure $ HelloReplyMessage ("hi, " <> nm)

-- Optics
-- sayHello :: (MonadServer m) => HelloRequestMessage' -> m HelloReplyMessage'
-- sayHello (HelloRequestMessage nm)
--   = pure $ record ("hi, " <> nm ^. #name)