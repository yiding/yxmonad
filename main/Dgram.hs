{-|
Utilities to write to datagram servers, for status messages and such.
 -}
module Dgram
(
newSocket,
sendMsg,
) where
import Protolude

import Network.Socket hiding (sendTo)
import Network.Socket.ByteString (sendTo)

data DgramSock = DgramSock Socket SockAddr

-- | Create and configure a socket.
newSocket :: FilePath -> IO DgramSock
newSocket path = do
  sock <- socket AF_UNIX Datagram defaultProtocol
  return (DgramSock sock) (SockAddrUnix path)

-- | Attempt to send a message. Does not wait. Fails silently.
sendMsg :: DgramSock -> Text -> IO ()
sendMsg (DgramSock sock sockAddr) msg = 
  catchError
    (sendTo sock (encodeUtf8 msg) sockAddr)
    (\e -> return ())
