module Utils where
import Data.Ratio
import Debug.Trace

neighbours list = zip list (tail list)

isForAllNeighbours p list = all (uncurry p) (neighbours list)

intToFloat :: Int -> Float
intToFloat n = fromInteger (toInteger n)

-- TODO remove me
-- expand :: Rational -> Rational -> (Integer,Integer)
expand a b = let f = lcm (denominator a) (denominator b)
             in (a*(f%1),b*(f%1))

expand' xs = let f = foldl1 lcm (map denominator xs) % 1
             in sum (map (numerator . (*f)) xs)

mtr x = trace (show x) x
