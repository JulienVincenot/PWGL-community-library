module Measure (m
               ,l
               ,d
               ,r
               ,dur
               ,E(L,D,R)
               ,M(M)
               ,transform_leafs
               ,transform_leafs'
               ,measuresDivideLeafs
               ,measuresWithBeats
               ,leafDurs
               ,leafEffectiveDurs
               ,measuresLeafIntervals
               ,measuresTransformLeafs
               ,wrapWithD
               ,Score
               ,Part
               ,Voice
               ,Label
               ,measuresTieOrRest
               ,measuresUntilTime
               ,labelVoice
               ,mleaves
               ,vleaves
               ,eid
               )
where
import Data.Ratio
import Utils
import qualified AbstractScore as A
import qualified Interval as Iv
import Data.List
import qualified Lisp as L

isPowerOfTwo 1 = True
isPowerOfTwo x | x > 1 = even x && isPowerOfTwo (x `div` 2)
isPowerOfTwo _ = error  "isPowerOfTwo"

lowerPowerOfTwo 1 = 1
lowerPowerOfTwo x | x > 1 = if isPowerOfTwo x then
                                x
                            else
                                lowerPowerOfTwo (x-1)
lowerPowerOfTwo _ = error "lowerPowerOfTwo"

-- e.g. when we divide by 9 the tuplet ratio will be 8 % 9
divToRatio :: Integer -> Rational
divToRatio d = lowerPowerOfTwo d % d

notableDur :: Rational -> Bool
notableDur x = h (numerator x) (denominator x)
    where h 1 d = isPowerOfTwo d
          h 3 d = isPowerOfTwo d && d >= 2
          h 7 d = isPowerOfTwo d && d >= 4
          -- 15 = 1 + 2 + 4 + 8
          h 15 d = isPowerOfTwo d && d >= 8
          h _ _ = False

type Timesig = (Integer,Integer)
type Tempo = (Integer,Rational)

type Score = A.Score M
type Part = A.Part M
type Voice = A.Voice M

data M = M Timesig Tempo E
       deriving (Show,Eq)

type Label = Integer
type Notes = L.LispVal
type Expressions = L.LispVal

data E =
--    dur      factor   children
    D Rational Rational [E]
--         dur      tie
       | L Rational Bool Label Notes Expressions
--         dur
       | R Rational Label
         deriving (Show,Eq)

dur (D d _ _) = d
dur (L d _ _ _ _)   = d
dur (R d _)     = d

eid (D _ _ _) = error "id not for D"
eid (R _ x) = x
eid (L _ _ x _ _) = x

timesigDur (n,d) = n%d

m timesig tempo d = if not(check timesig tempo d) then
                        error "m timesig tempo d not valid"
                    else M timesig tempo d
    where check timesig _ d = dur d == timesigDur timesig

l d tie notes expressions =
    if not check then
        error $ "cannot construct L from " ++ show d ++ " " ++ show tie
    else L d tie 0 notes expressions
    where check = notableDur d

r d = if not check then
          error "r d not valid"
      else R d 0
    where check = notableDur d

d d r es = if not(check d r es) then
          error "d d r es not valid"
      else D d r es
    where check d r es = d == r * sum (map dur es)

class Transformable a b where
    transform_leafs :: (b -> b) -> a -> a
    -- passing around user supplied data
    transform_leafs' :: (b -> t -> (b,t)) -> t -> a -> (a,t)

smap :: (t -> a -> (b,t)) -> [a] -> t -> ([b],t)
smap _ [] d   = ([],d)
smap f (x:xs) d = let (r,newd) = f d x
                  in let (rest,lastd) = (smap f xs newd)                      
                     in (r : rest,lastd)

instance Transformable M E where
    transform_leafs fn (M timesig tempo e) =
        m timesig tempo (transform_leafs fn e)
    transform_leafs' fn z (M timesig tempo e) =
        let (r,z') = (transform_leafs' fn z e)
        in (m timesig tempo r,z')

instance Transformable E E where
    transform_leafs fn (D dur r es) =
        d dur r (map (transform_leafs fn) es)
    transform_leafs fn x = fn x
    transform_leafs' fn z (D dur r es) =
        let (res,z') = (smap (transform_leafs' fn) es z)
        in (d dur r res,z')
    transform_leafs' fn z x = fn x z

n60 = L.readLisp "(60)"
nil = L.readLisp "()"

measuresDivideLeafs ms divs =
    fst (smap (transform_leafs' trans) ms divs)
        where 
              trans (L dur _ _ _ _) (n:ds) =
                  let r = if notableDur (dur / (n%1)) then 1 else divToRatio n
                  in (d dur r (replicate (fromInteger n) (l (dur / (n % 1) / r) False n60 nil)),
                        ds)
              trans r@(R _ _) ds = (r,ds)
              trans (D _ _ _) _ = error "measuresDivideLeafs: did not expect (D _ _ _)"
              trans (L _ _ _ _ _) [] = error "measuresDivideLeafs: divs have run out"

measuresWithBeats timesigs tempos =
    let divs = map fst timesigs
    in measuresDivideLeafs (map mes (zip timesigs tempos)) divs
    where mes (timesig,tempo) =
              -- use L here, so that we are allowed to have a duration of e.g. 5/4
              m timesig tempo (L (timesigDur timesig) False 0 n60 nil)

eleaves :: E -> [E]
eleaves e@(L _ _ _ _ _) = [e]
eleaves e@(R _ _) = [e]
eleaves (D _ _ es) = concatMap eleaves es

mleaves :: M -> [E]
mleaves (M _ _ e) = eleaves e

vleaves :: Voice -> [E]
vleaves v = concatMap mleaves (A.voiceItems v)

leafDurs :: E -> [Rational]
leafDurs e = map dur (eleaves e)

leafEffectiveDurs :: E -> [Rational]
leafEffectiveDurs x = leafEffectiveDurs' 1 x
    where
      leafEffectiveDurs' r (L d _ _ _ _) = [d * r]
      leafEffectiveDurs' r (R d _) = [d * r]
      leafEffectiveDurs' r (D _ r' es) =
          concatMap (leafEffectiveDurs' (r * r')) es

tempoToBeatDur :: (Integer,Rational) -> Rational
tempoToBeatDur (d,tempo) = 60 / tempo / (d%4)

measureDur (M (n,_) tempo _) = (n%1) * tempoToBeatDur tempo

-- foldl            :: (a -> b -> a) -> a -> [b] -> a
-- foldl f acc []     =  acc
-- foldl f acc (x:xs) =  foldl f (f acc x) xs

dxsToXs = scanl (+) 0

measuresStartTimes ms = dxsToXs (map measureDur ms)

measuresUntilTime :: [M] -> Float -> [M]
measuresUntilTime ms time = map fst (takeWhile p (zip ms (measuresStartTimes ms)))
    where p (_,s) = fromRational s < time

-- measure_leaf_start_times (M (_,d) tempo div) start =
--     (map (+start) (dxsToXs_butlast (map trans (leafEffectiveDurs div))))
--     where trans dur = (tempoToBeatDur tempo) * (dur_to_beat dur)
--           dur_to_beat dur = dur * (d%1)
--           butlast xs = reverse (tail (reverse xs))
--           dxsToXs_butlast dxs = butlast (dxsToXs dxs)


-- measures_leaf_start_times ms = (concatMap (uncurry measure_leaf_start_times)
--                                               (zip ms (measuresStartTimes ms)))

measureLeafIntervals (M (_,d) tempo div) start =
    neighbours (map (+start) (dxsToXs (map trans (leafEffectiveDurs div))))
    where trans dur = tempoToBeatDur tempo * dur_to_beat dur
          dur_to_beat dur = dur * (d%1)

measuresLeafIntervals ms = concatMap (uncurry measureLeafIntervals)
                              (zip ms (measuresStartTimes ms))

-- if leaf start time is not in any iv, then rest. if leaf start time
-- is in an interval keep it and make it a tie if the end time is not
-- the same as the end time of the interval
measuresTieOrRest :: (Transformable a1 E, Iv.Interval a b, Ord b) =>
                        [a1] -> [a] -> [(b, b)] -> [a1]
measuresTieOrRest ms ivs leaf_times = 
    fst (smap (transform_leafs' trans) ms leaf_times)
        where 
              trans (L dur _ _ notes expressions) ((s,e):leaf_times) =            
                  case find ivContainsStart ivs of
                    Nothing -> (r dur,leaf_times)
                    Just iv -> let tie = e < Iv.end iv
                               in (l dur tie notes expressions,leaf_times)
                  where ivContainsStart = flip Iv.isPointInInterval s
              trans (L _ _ _ _ _) [] = error "measuresTieOrRest: leaf_times have run out"
              trans (R _ _) _    = error "measuresTieOrRest: did not expect a rest here"
              trans (D _ _ _) _ = error "measuresTieOrRest: did not expect a D"

measuresTransformLeafs :: (Transformable a1 E, Iv.Interval a b, Ord b) =>
                        (E -> a -> E) -> [a1] -> [a] -> [(b, b)] -> [a1]
measuresTransformLeafs f ms ivs leaf_times =
    fst (smap (transform_leafs' trans) ms leaf_times)
        where 
              trans (D _ _ _) _ = error "measuresTieOrRest: did not expect a D"
              trans _ [] = error "measuresTransformLeafs: leaf_times have run out"
              trans elt ((s,_):leaf_times) =
                  case find ivContainsStart ivs of
                    Nothing -> (elt,leaf_times)
                    Just iv -> (f elt iv,leaf_times)
                  where ivContainsStart = flip Iv.isPointInInterval s

labelVoice voice =
    A.Voice (fst (smap (transform_leafs' trans) (A.voiceItems voice) [0..]))
        where 
              trans (L dur tie _ notes expressions) (id:ids) = (L dur tie id notes expressions,ids)
              trans (R dur _) (id:ids) = (R dur id,ids)
              trans (D _ _ _) _ = error "labelVoice: did not expect a D"
              trans _ [] = error "labelVoice: ids have run out? (should never happen)"

wrapWithD :: E -> E
wrapWithD e = d (dur e) 1 [e]

---------------------------------------------------------

-- m1 = M (4,4) (60 % 1)
--      (D (1 % 1) (1 % 1)
--       [L (1 % 4) False,L (1 % 4) False,L (1 % 4) False,L (1 % 4) False])

-- m2 = (measuresDivideLeafs [m1] (repeat 3)) !! 0
-- m3 = (measuresDivideLeafs [m2] (repeat 3)) !! 0
