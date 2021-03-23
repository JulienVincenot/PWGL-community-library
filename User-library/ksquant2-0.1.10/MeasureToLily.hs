module MeasureToLily
       (mToLily,vToLily) where
import qualified Measure as M
import qualified Lily as L
import qualified AbstractScore as A
import Data.Ratio
import Lisp

log2 1 = 0
log2 n | even n = 1 + log2 (div n 2)
log2 _ = error "log2"

midiToLily 59 = L.Pitch L.B L.Natural 3
midiToLily 60 = L.Pitch L.C L.Natural 4
midiToLily 61 = L.Pitch L.C L.Sharp 4
midiToLily 62 = L.Pitch L.D L.Natural 4
midiToLily 65 = L.Pitch L.F L.Natural 4
midiToLily x = error $ "midiToLily not implemented: " ++ show x

durToLily :: Rational -> L.Dur
durToLily d = L.Dur (base d) (dots d)
    where dots d = case (numerator d) of
                     1 -> 0
                     3 -> 1
                     7 -> 2
                     15 -> 3
                     _ -> error "durToLily"
          base d = L.powerToSimpleDur (log2 (denominator d) - dots d)
          
ensureListOfIntegers :: LispVal -> [Int]
ensureListOfIntegers (LispList xs) =
    map ensureInt xs
    where ensureInt (LispInteger x) = fromInteger x
          ensureInt _ = error "ensureInt"
ensureListOfIntegers _ = error "ensureListOfIntegers"

eToLily :: M.E -> [L.Elt]
eToLily (M.L d tie _ notes _) = [L.Chord (durToLily d) midis tie]
  where midis = map midiToLily (ensureListOfIntegers notes)
eToLily (M.R d _) = [L.Rest (durToLily d)]
eToLily (M.D _ r es) | r == 1 = concatMap eToLily es
                       | otherwise = let n' = fromInteger (numerator r)
                                         d' = fromInteger (denominator r)
                                     in [L.Times n' d' (concatMap eToLily es)]

mToLily :: M.M -> L.Measure
mToLily (M.M (n,d) _ e) = L.Measure (fromInteger n) (fromInteger d) (eToLily e)

vToLily :: M.Voice -> L.Voice
vToLily v = A.Voice $ map mToLily (A.voiceItems v)
