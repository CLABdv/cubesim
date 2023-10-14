{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
module CubeData where
import Foreign.Ptr
import Foreign.C

data Cubepos = Cubepos
-- I don't really know what I should put as return type,
-- IO () doesnt really feel correct since the functions don't really do IO, it just mutates the Ptr Cubepos
-- I might write the wrapper such that it returns the pointer each time, that will also force the evaluation 
-- to happen in the correct order. This will probably be needed.
foreign import capi "cwrapper_cubepos.h c_cubepos_init" cubeposInit :: CInt -> CInt -> CInt -> Ptr Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_delete" cubeposDelete :: Ptr Cubepos -> IO ()
foreign import capi "cwrapper_cubepos.h c_parse_move" parseMove :: Ptr Cubepos -> Ptr CChar -> CInt
foreign import capi "cwrapper_cubepos.h c_move" move :: Ptr Cubepos -> CInt -> IO ()
foreign import capi "cwrapper_cubepos.h c_singmaster_string" singmasterToString :: Ptr Cubepos -> Ptr CChar
