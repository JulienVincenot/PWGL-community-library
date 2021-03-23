module MeasureToEnp where
import qualified Measure as M
import qualified Enp as E
import Data.Ratio

durs2factor xs = foldl1 lcm (map denominator xs) % 1
ratio2integer r | denominator r == 1 = numerator r
                | otherwise = error "ratio2integer: not an integer"

tiedOverFromLast _ 0 = False
tiedOverFromLast assoc id =
    case lookup (id-1) assoc of
      Nothing -> error "tiedOverFromLast not found"
      Just x -> has_forward_tie x
    where has_forward_tie (M.R _ _) = False
          has_forward_tie (M.L _ tie _ _ _) = tie
          has_forward_tie (M.D _ _ _) = error "tiedOverFromLast (M.D _ _ _)"

eToEnp :: [(M.Label, M.E)] -> Rational -> M.E -> E.Elt
eToEnp assoc f (M.L d _ id notes expressions) =
    E.Chord (ratio2integer (d * f)) (tiedOverFromLast assoc id) notes expressions
eToEnp _ f (M.R d _) = E.Rest (ratio2integer (d * f))
eToEnp assoc f (M.D d _ es) =
    let f' = durs2factor (map M.dur es)
    in E.Div (ratio2integer (d * f))
           (map (eToEnp assoc f') es)

unwrap (E.Div _ e) = e
unwrap _ = error "unwrap: not a Div"

wrapIfNeeded e@(E.Div _ _) = e
wrapIfNeeded x = E.Div 1 [x]

adaptForTimesig (n,_) es = let f = n `div` sum (map E.dur es)
                           in map (E.scaleElt f) es

mToEnp :: [(M.Label, M.E)] -> M.M -> E.Measure
mToEnp assoc (M.M ts t e) =
    let f = denominator (M.dur e) % 1
        list = (unwrap (wrapIfNeeded (eToEnp assoc f e)))
        list' = map wrapIfNeeded list
        list'' = adaptForTimesig ts list'
    in (E.makeMeasure ts t list'')

vToEnp :: M.Voice -> E.Voice
vToEnp v = let v' = M.labelVoice v
               ls = M.vleaves v'
               assoc = zip (map M.eid ls) ls
           in fmap (mToEnp assoc) v'
