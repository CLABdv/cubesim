{-# LANGUAGE OverloadedStrings #-}
module Main where
import Linear
import Linear.Matrix
import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game
import Control.Lens
import Data.List (sortBy)
import Data.Bifunctor (bimap)
-- TODO: Simulate actual rubiks cube.
-- This is probably going to be done by creating 27 cubes (3^3) and placing them relative to each other,
-- such that when a layer is rotated the middle of the layer is stationary.
-- Afterwards some of the faces of the cubes which form the layer will need to be hidden.

main :: IO ()
main = play (InWindow "Hello, World!" (400, 400) (10, 10)) white fps (V3
    (V3 ll 0 0)
    (V3 0 ll 0)
    (V3 0 0 ll)) drawWorld eventHandler nextWorld

fps = 144
ll = 100

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


-- each second the cube rotates 180 degrees around the z-axis
nextWorld :: Floating a => Float -> V3 (V3 a) -> V3 (V3 a)
nextWorld t w = rotAllMatrix (t' * pi / 2) (t' * pi / 5) (t' * pi / 7) !*! w
    where t' = realToFrac t

-- retrieves points for polygon
getCorners :: Floating a => V2 a -> V2 a -> [V2 a]
getCorners (V2 x0 y0) (V2 x1 y1) = [V2 0 0, V2 x0 y0, V2 (x0 + x1) (y0 + y1), V2 x1 y1]

drawWorld :: (Real a, Floating a) => M33 a -> Picture
drawWorld m = Pictures
    [
        Pictures threeVisible
    ]
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
          blackPoly = colouredPolygon black $ map (+c1) c0c2Corner
          cyanPoly = colouredPolygon cyan $ map (+c2) c0c1Corner
          polys = [greenPoly, bluePoly, redPoly, yellowPoly, blackPoly, cyanPoly]


          colouredPolygon col = color col . polygon . map (bimap realToFrac realToFrac . f )
          f v = let V2 a b = offset m v in (a, b)
          --f (V2 a b) = (a, b)
          -- the z's are gotten by getting the midpoints of the sides and then doing some subtractions
          -- the three biggest are then equivalent to the three being greater than zero, provided that none are 0.
          -- this case is automatically solved tho, because when they are zero our view line is in line with the plane, therefore it is not visible
          threeVisible = map snd $ filter ((>0) . fst) $ zip [-z0, -z1, -z2, z0, z1, z2] polys

data Cube = Cube --TODO: Data structure which is easily interlinked such that a rotation in one side changes the other sides

offset m v  = v - (d ^/ 2)
    where
        -- there gotta be a much better way to do this, but i can think of one since _x, _y.. arent enum
        V3 x0 y0 _ = m ^.column _x
        V3 x1 y1 _ = m ^.column _y
        V3 x2 y2 _  = m ^.column _z
        d = V2 (x0 + x1 + x2) (y0 + y1 + y2)

-- not doing stuff yet
eventHandler :: Event -> V3  a -> V3  a
eventHandler _ a = a
