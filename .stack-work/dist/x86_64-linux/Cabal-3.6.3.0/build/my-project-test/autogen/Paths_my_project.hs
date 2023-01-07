{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_my_project (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/bin"
libdir     = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/lib/x86_64-linux-ghc-9.2.5/my-project-0.1.0.0-JAO56i2azwaBTAS7UFVTAh-my-project-test"
dynlibdir  = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/lib/x86_64-linux-ghc-9.2.5"
datadir    = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/share/x86_64-linux-ghc-9.2.5/my-project-0.1.0.0"
libexecdir = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/libexec/x86_64-linux-ghc-9.2.5/my-project-0.1.0.0"
sysconfdir = "/workspace/DeBealeCipher/.stack-work/install/x86_64-linux/f69f3361d15ec4de94bc08ed4d563d2053003177e5a2cc2077e28e6513113394/9.2.5/etc"

getBinDir     = catchIO (getEnv "my_project_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "my_project_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "my_project_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "my_project_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "my_project_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "my_project_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
