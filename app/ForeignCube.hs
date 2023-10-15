{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
module ForeignCube where
import Foreign.Ptr
import Foreign.C
import Foreign.C.String

data Cubepos = Cubepos
foreign import capi "cwrapper_cubepos.h c_cubepos_init" cubeposInit :: CInt -> CInt -> CInt -> IO (Ptr Cubepos)
-- I don't really know what I should put as return types
-- IO () doesnt really feel correct since the functions don't really do IO, it just mutates
foreign import capi "cwrapper_cubepos.h c_cubepos_delete" cubeposDelete :: Ptr Cubepos -> IO ()
foreign import capi "cwrapper_cubepos.h c_parse_move" parseMove :: Ptr Cubepos -> CString -> IO CInt
foreign import capi "cwrapper_cubepos.h c_move" move :: Ptr Cubepos -> CInt -> IO (Ptr Cubepos)
foreign import capi "cwrapper_cubepos.h c_singmaster_string" toSingmasterString :: Ptr Cubepos -> IO CString
