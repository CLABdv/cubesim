{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
module CubeData where
import Foreign.Ptr
import Foreign.C
--https://wiki.haskell.org/CPlusPlus_from_Haskell 

data Cubepos = Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_init" cubeposInit :: CInt -> CInt -> CInt -> Ptr Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_delete" cubeposDelete :: Ptr Cubepos -> IO ()
foreign import capi "cwrapper_cubepos.h c_parse_move" parseMove :: Ptr Cubepos -> Ptr CChar -> CInt
foreign import capi "cwrapper_cubepos.h c_move" move :: Ptr Cubepos -> CInt -> IO ()
foreign import capi "cwrapper_cubepos.h c_singmaster_string" singmasterToString :: Ptr Cubepos -> Ptr CChar
