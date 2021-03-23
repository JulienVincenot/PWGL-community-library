module SimpleFormat (sexp2simpleFormat
                    ,Score
                    ,Part
                    ,Voice
                    ,Event(..)
                    ,eventStart
                    ,sexp2event)
where

import Lisp

import qualified AbstractScore as A

type Time = Float
type Notes = LispVal
type Expressions = LispVal

type Score = A.Score Event
type Part = A.Part Event
type Voice = A.Voice Event

data Event = Chord Time Notes Expressions
           | Rest Time
           deriving (Eq,Show)

-- TODO can we use point from Interval?
eventStart (Chord x _ _) = x
eventStart (Rest x) = x

sexp2simpleFormat :: LispVal -> Score
sexp2simpleFormat = sexp2score

sexp2score s = A.Score (mapcar' sexp2part s)
sexp2part s = A.Part (mapcar' sexp2voice s)
sexp2voice s = A.Voice (mapcar' sexp2event s)

n60 = readLisp "(60)"

sexp2event s = sexp2event' s False

sexp2event' (LispInteger x) r = sexp2event' (LispFloat (fromInteger x)) r
sexp2event' (LispFloat x) r | x < 0 || r = Rest (abs x)
                            | otherwise = Chord x n60 (readLisp "()")

sexp2event' xs@(LispList _) _
    = if foundAndT $ getf (cdr xs) (readLisp ":rest")
      then sexp2event' (car xs) True
      else case sexp2event' (car xs) False of
             Rest d ->
                 Rest d
             Chord d notes expressions ->
                 Chord d notes' expressions'
                     where notes' = getf' (cdr xs) (readLisp ":notes") notes
                           expressions' = getf' (cdr xs) (readLisp ":expressions") expressions
    where foundAndT Nothing = False
          foundAndT (Just (LispSymbol "NIL")) = False
          foundAndT (Just _) = True
sexp2event' x r = error $ "sexp2event' with " ++ show x ++ " " ++ show r
