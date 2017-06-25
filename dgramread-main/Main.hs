{-

A small standalone application to read from a Unix Datagram socket.

 -}

{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

import Protolude
import Network.Socket (socket, Family(AF_UNIX), SocketType(Datagram), defaultProtocol, bind, SockAddr(SockAddrUnix), SocketOption(ReuseAddr), setSocketOption)
import Network.Socket.ByteString (recvFrom)
import System.Directory (removeFile)
import System.IO.Error (isAlreadyExistsError)
import Options.Applicative (argument, str, metavar, execParser, info, helper, fullDesc, progDesc)

opts = argument str (metavar "PATH")

main = do
  sockPath <- execParser $
    info (opts <**> helper) (fullDesc <> progDesc "Listens to messages from a unix datagram socket.")
  let sockPath = "/home/yiding/.yxmonad/status.sock"
  -- Delete the socket if it exists.
  catchError (removeFile sockPath) (\e -> unless (isAlreadyExistsError e) (throwError e))
  sock <- socket AF_UNIX Datagram defaultProtocol
  bind sock (SockAddrUnix sockPath)
  forever $ do
    (msg, _) <- recvFrom sock 1024
    putStr msg

