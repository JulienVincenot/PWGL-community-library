module Interval (Point
                ,point
                ,Interval
                ,start
                ,end                
                ,intersect
                ,isPointInInterval
                ,isStrictlyAfter
                ,ascendingIntervals
                ,getAscendingIntervals
                ,AscendingIntervals --only type not constructor
                ,ascendingPoints
                ,getAscendingPoints
                ,AscendingPoints --only type not constructor
                ,groupPointsByIntervalls
                ,ascendingIntervals2points
                ,divideInterval
                ,bestDiv
                ,locatePoint
                ,quantizeIv
                ) where
import Utils
import Data.List (sortBy)
import Data.Ord (comparing)

-- http://www.haskell.org/haskellwiki/Functional_dependencies
-- This tells Haskell that b is uniquely determined from a. 
class (Num b) => Interval a b | a -> b where
    start :: a -> b
    end :: a -> b
    dur :: a -> b
    -- defaults
    dur x = end x - start x
    end x = start x + dur x

class Point a b | a -> b where
    point :: a -> b

instance (Num t) => Interval (t,t) t where
    start (x,_) = x
    end (_,x) = x

instance (Num t) => Point t t where
    point x = x

-- |Do the intervals a and b have common points?
intersect a b =
    let s1 = start a
        e1 = end a
        s2 = start b
        -- e2 = end b
    in
      if s1 > s2 then
          b `intersect` a
      else
          s2 < e1

-- |Is x in iv?
isPointInInterval iv x = start iv <= point x && point x < end iv

isStrictlyAfter a b = start b >= end a

data AscendingIntervals a = AscendingIntervals [a]
                            deriving Show

{-# ANN isAscendingIntervals "HLint: ignore Eta reduce" #-}
isAscendingIntervals xs = isForAllNeighbours isStrictlyAfter xs

ascendingIntervals ivs =
    if not (isAscendingIntervals ivs) then
        error "not (isForAllNeighbours isStrictlyAfter ivs)"
    else
        AscendingIntervals ivs

getAscendingIntervals (AscendingIntervals xs) = xs

data AscendingPoints a = AscendingPoints [a]
                       deriving (Show, Eq)
ascendingPoints xs =
    if not (isForAllNeighbours (<) xs) then
        error "not (isForAllNeighbours (<) xs)"
    else
        AscendingPoints xs

getAscendingPoints (AscendingPoints xs) = xs

-- | For each interval return ascendingPoints that are all the points
--   from xs contained in the interval
groupPointsByIntervalls ivs xs = f (getAscendingIntervals ivs) (getAscendingPoints xs)
    where f [] _ = []
          f (_:ivs) [] = ascendingPoints [] : f ivs []
          f (iv:ivs) (x:xs)
              | point x < start iv = f (iv:ivs) xs
              | otherwise = ascendingPoints (takeWhile (< end iv) (x:xs)) :
                            f ivs (dropWhile (< end iv) (x:xs))

-- TODO call internal Constructor instead of safe ascendingPoints
ascendingIntervals2points ivs = ascendingPoints (f (getAscendingIntervals ivs))
    where f (iv:ivs) = [start iv,end iv] ++ g ivs (end iv)
          f [] = []
          g [] _ = []
          g (iv:ivs) last = if start iv == last
                            then
                                end iv : g ivs (end iv)
                            else
                                [start iv,end iv] ++ g ivs (end iv)

divideInterval iv n =
    let new_dur = dur iv / n
        points = map ((+ start iv) . (*new_dur)) [0..n]
    in ascendingIntervals (neighbours points)

-- min cost to move x to start or end of iv
boundaryMoveCost iv x = let x' = point x
                            dist = min (abs (start iv - x')) (abs (end iv) - x')
                        in dist * dist

-- what is the cost of dividing iv by div (e.g. 3) and moving points
-- in xs accordingly
divCost iv xs div = let small_ivs = divideInterval iv div
                        point_groups = groupPointsByIntervalls small_ivs xs
                        group_cost (small_iv,points) =
                          sum (map (boundaryMoveCost small_iv) (getAscendingPoints points))
                    in sum (map group_cost (zip (getAscendingIntervals small_ivs) point_groups))

-- return a list of pairs (div,cost). Best pair comes first. In case of
-- two identical costs the div that comes first in divs will be
-- prefered (sortBy is a stable sorting algorithm).
rankedDivs iv xs divs = sortBy test (zip divs (map (divCost iv xs) divs))
  where test (_,a) (_,b) = compare a b 

-- choose the best div from divs
bestDiv divs iv xs = round (fst (head (rankedDivs iv xs (map intToFloat divs)))) :: Int

-- TODO implement this as a binary search
locatePoint ivs x = r (getAscendingIntervals ivs) (point x) 0
    where r (iv:ivs) x index
              | isPointInInterval iv x ||
                ((ivs == []) && (x >= end iv)) = (iv,(index,index+1))
              | otherwise = r ivs x (index+1)
          r a b c = error $ "locatePoint " ++ show a ++ " " ++ show b ++ " " ++ show c

quantizeIv f rational_ivs ivs iv =
    let rivs = getAscendingIntervals rational_ivs
        s = start iv
        e = end iv
        ((s0,s1),(si0,si1)) = locatePoint ivs s
        ((e0,e1),(ei0,ei1)) = locatePoint ivs e
        result = [(cost ds de,(end3 a,end3 b)) |
                     a <- [(s0,si0,start $ rivs !! si0),
                           (s1,si1,end $ rivs !! si0)],
                     b <- [(e0,ei0,start $ rivs !! ei0),
                           (e1,ei1,end $ rivs !! ei0)],
                     mid3 a /= mid3 b,
                     let ds = abs (s - fst3 a),
                     let de = abs (e - fst3 b)]
    in f (snd $ best result) iv
    where cost ds de = abs (de - ds) + abs ds + abs de
          test = comparing fst
          best xs = head (sortBy test xs)
          fst3 (x,_,_) = x
          mid3 (_,x,_) = x
          end3 (_,_,x) = x
