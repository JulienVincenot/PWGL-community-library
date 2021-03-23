module Enp (score2sexp
           ,Score
           ,Part
           ,Voice
           ,Measure(..)
           ,Elt(..)
           ,makeMeasure
           ,scaleElt
           ,dur)
where

import Lisp
import qualified AbstractScore as A

type Dur = Integer
type Timesig = (Integer,Integer)
type Tempo = (Integer,Rational)

type Score = A.Score Measure
type Part = A.Part Measure
type Voice = A.Voice Measure

data Measure = Measure Timesig Tempo [Elt]
           deriving (Show, Eq)

type Tied = Bool
type Notes = LispVal
type Expressions = LispVal

-- |Tied here has ENP semantics, which is a tie "going to the left".
data Elt = Chord Dur Tied Notes Expressions
           | Rest Dur
           | Div Dur [Elt]
           deriving (Show, Eq)

dur (Chord d _ _ _) = d
dur (Rest d) = d
dur (Div d _) = d

scaleElt :: Integer -> Elt -> Elt
scaleElt n (Chord d t notes expressions) = Chord (n * d) t notes expressions
scaleElt n (Rest d) = Rest (n * d)
scaleElt n (Div d es) = Div (n * d) es

makeMeasure :: Timesig -> Tempo -> [Elt] -> Measure
makeMeasure (n,d) t es =
    if not check then
        error $ "Enp.makeMeasure " ++ show (n,d) ++ " " ++ show es
    else Measure (n,d) t es
    where check = n == sum (map dur es)

score2sexp :: Score -> LispVal
score2sexp e = LispList $ map part2sexp (A.scoreParts e)

part2sexp :: Part -> LispVal
part2sexp e = LispList $ map voice2sexp (A.partVoices e)

voice2sexp :: Voice -> LispVal
voice2sexp e = 
    LispList $ map measure2sexp (A.voiceItems e) ++
             fromLispList (parseLisp' ":instrument NIL :staff :treble-staff")

measure2sexp :: Measure -> LispVal
measure2sexp (Measure (n,d) (tu,t) xs) =
    LispList $ map elt2sexp xs ++
                 [LispKeyword "TIME-SIGNATURE",
                  LispList [LispInteger n,LispInteger d],
                  LispKeyword "METRONOME",
                  LispList [LispInteger tu,LispInteger $ round t]]

elt2sexp :: Elt -> LispVal
elt2sexp (Chord d False notes expressions) =
    LispInteger d `cons` LispList ([LispKeyword "NOTES", notes] ++ expressionsOrEmpty expressions)
elt2sexp (Chord d True  notes expressions) =
    LispFloat (fromInteger d) `cons` LispList ([LispKeyword "NOTES", notes] ++ expressionsOrEmpty expressions)
elt2sexp (Rest d) = LispInteger (-d) `cons` parseLisp' ":notes (60)"
elt2sexp (Div d xs) = LispInteger d `cons` LispList [LispList (map elt2sexp xs)]

expressionsOrEmpty expressions = if clNull expressions then []
                                 else [LispKeyword "EXPRESSIONS", expressions]
