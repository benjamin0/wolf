module Network.AWS.Flow.S3
  ( putObjectAction
  ) where

import Network.AWS.Flow.Prelude hiding ( hash )
import Network.AWS.Flow.Types

import Network.AWS.Data.Body
import Data.Conduit.Binary
import Network.AWS.S3

-- Actions

putObjectAction :: MonadFlow m => Artifact -> m ()
putObjectAction (key, hash, size, blob) = do
  timeout' <- asks feTimeout
  bucket' <- asks feBucket
  prefix <- asks fePrefix
  void $ timeout timeout' $
    send $ putObject (BucketName bucket') (ObjectKey $ prefix <> "/" <> key) (Hashed $ hashedBody hash size $ sourceLbs blob)
