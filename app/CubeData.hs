{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
module CubeData where
import Foreign.Ptr
import Foreign.C

data Cubepos = Cubepos
-- I don't really know what I should put as return type for destructor,
-- IO () doesnt really feel correct since the functions don't really do IO, it just mutates the Ptr Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_init" cubeposInit :: CInt -> CInt -> CInt -> Ptr Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_delete" cubeposDelete :: Ptr Cubepos -> IO ()
foreign import capi "cwrapper_cubepos.h c_parse_move" parseMove :: Ptr Cubepos -> Ptr CChar -> CInt
foreign import capi "cwrapper_cubepos.h c_move" move :: Ptr Cubepos -> CInt -> Ptr Cubepos
foreign import capi "cwrapper_cubepos.h c_singmaster_string" singmasterToString :: Ptr Cubepos -> Ptr CChar
