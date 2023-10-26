{-# LANGUAGE OverloadedStrings #-}
module Main where
import Linear
import ForeignCube
import Linear.Matrix
import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import Control.Lens
import Data.List (sortBy)
import Data.Bifunctor (bimap, Bifunctor (second))
import Foreign.C.String
import Data.Array
-- TODO: Simulate actual rubiks cube.

main :: IO ()
main = identityCube >>= toSingmasterString >>= peekCString >>= putStrLn >> play (InWindow "Hello, World!" (400, 400) (10, 10)) white fps (rotAllMatrix (pi/4) (pi/4) (pi/4) !*! V3
    (V3 sl 0 0)
    (V3 0 sl 0)
    (V3 0 0 sl)) drawWorld eventHandler nextWorld

fps = 144
sl = 100

rotxMatrix :: Floating a => a -> V3 (V3  a)
rotxMatrix theta = V3 (V3 1 0 0)
                      (V3 0 (cos theta) (-sin theta))
                      (V3 0 (sin theta) (cos theta))

rotyMatrix ::Floating a => a -> V3 (V3  a)
rotyMatrix theta = V3 (V3 (cos theta) 0 (sin theta))
                      (V3 0 1 0)
                      (V3 (-sin theta) 0 (cos theta))

rotzMatrix :: Floating a => a -> V3 (V3 a)
rotzMatrix theta = V3 (V3 (cos theta) (-sin theta) 0)
                      (V3 (sin theta) (cos theta) 0)
                      (V3 0 0 1)

rotAllMatrix :: Floating a => a -> a -> a -> V3 (V3 a)
rotAllMatrix thetax thetay thetaz = rotxMatrix thetax !*! rotyMatrix thetay !*! rotzMatrix thetaz


nextWorld :: Floating a => Float -> V3 (V3 a) -> V3 (V3 a)
nextWorld t w = rotAllMatrix 0 0 0 !*! w
    where t' = realToFrac t

-- retrieves points for polygon
getCorners :: Floating a => V2 a -> V2 a -> [V2 a]
getCorners (V2 x0 y0) (V2 x1 y1) = [V2 0 0, V2 x0 y0, V2 (x0 + x1) (y0 + y1), V2 x1 y1]

drawWorld :: (Real a, Floating a) => M33 a -> Picture
drawWorld m = Pictures
    [
        Pictures threeVisible
    ]
    --TODO: Maybe refactor to use getPolys instead.
    where c0 = let V3 x y z = m ^.column _x in V2 x y
          c1 = let V3 x y z = m ^.column _y in V2 x y
          c2 = let V3 x y z = m ^.column _z in V2 x y
          z0 = m ^. (column _x . _z)
          z1 = m ^. (column _y . _z)
          z2 = m ^. (column _z . _z)
          c0c1Corner = getCorners c0 c1
          c0c2Corner = getCorners c0 c2
          c1c2Corner = getCorners c1 c2

          greenPoly = colouredPolygon green c1c2Corner
          bluePoly = colouredPolygon blue c0c2Corner
          redPoly = colouredPolygon red c0c1Corner

          yellowPoly = colouredPolygon yellow $ map (+c0) c1c2Corner
          magentaPoly = colouredPolygon magenta $ map (+c1) c0c2Corner
          cyanPoly = colouredPolygon cyan $ map (+c2) c0c1Corner
          polys = [greenPoly, bluePoly, redPoly, yellowPoly, magentaPoly, cyanPoly]


          colouredPolygon col = color col . polygon . map (bimap realToFrac realToFrac . f )
          f v = let V2 a b = offset m v in (a, b)
          --f (V2 a b) = (a, b)
          -- the z's are gotten by getting the midpoints of the sides and then doing some subtractions
          -- the three biggest are then equivalent to the three being greater than zero, provided that none are 0.
          -- this case is automatically solved tho, because when they are zero our view line is in line with the plane, therefore it is not visible
          threeVisible = map snd $ filter ((>0) . fst) $ zip [-z0, -z1, -z2, z0, z1, z2] polys


offset m v  = v - (d ^/ 2)
    where
        -- there gotta be a better way to do this
        V3 x0 y0 _ = m ^.column _x
        V3 x1 y1 _ = m ^.column _y
        V3 x2 y2 _  = m ^.column _z
        d = V2 (x0 + x1 + x2) (y0 + y1 + y2)

-- Returns a list of lists with points for polygons.
-- You must rotate the cuboids into the correct rotation before reading stuff into them, 
-- otherwise everything will be nonsensical
getPolys :: (Real a, Floating a) => M33 a -> [[V2 a]]
getPolys m = [c0c1Corner, c0c2Corner, c1c2Corner]
    where c0 = let V3 x y z = m ^.column _x in V2 x y
          c1 = let V3 x y z = m ^.column _y in V2 x y
          c2 = let V3 x y z = m ^.column _z in V2 x y
          c0c1Corner = getCorners c0 c1
          c0c2Corner = getCorners c0 c2
          c1c2Corner = getCorners c1 c2

-- not doing stuff yet
eventHandler :: Event -> V3  a -> V3  a
eventHandler _ a = a

identityCube = cubeposInit 0 0 0

data Side = U | F | D | B | L | R
    deriving (Show, Eq, Enum)

data Cubie = EdgeCubie   {firstFace :: Side, secondFace :: Side} 
           | CornerCubie {firstFace :: Side, secondFace :: Side, thirdFace :: Side}
    deriving (Show, Eq)

-- idk if its even possible to not hardcode this because of how singmaster notation works
-- NVM frigg this boring sheit
{-
getPolys :: [Cubie] -> Cube
getPolys cubies = Cube buf
    where buf = listArray (0,5) 
            [ 
                -- Up
                array ((0,0),(2,2)) $ map (second firstFace)
                    [((1,2), cubies !! 0)
                    ,((2,1), cubies !! 1)
                    ,((1,0), cubies !! 2)
                    ,((0,1), cubies !! 3)
                    ,((2,2), cubies !! 12)
                    ,((2,0), cubies !! 13)
                    ,((0,0), cubies !! 14)
                    ,((0,2), cubies !! 15)
                    ],
                -- Front
                array ((0,0),(2,2)) 
                [((1,0), secondFace $ cubies !! 0),
                 ((1,2), secondFace $ cubies !! 4),
                 ((2,1), firstFace $ cubies !! 8),
                 ((0,1), firstFace $ cubies !! 9)
                ]
            ]
          
-}
