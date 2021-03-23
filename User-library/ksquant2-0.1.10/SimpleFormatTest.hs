module SimpleFormatTest where
import SimpleFormat
import Lisp (readLisp)
import Test.HUnit

sexp2event1 = TestList
              [
               Rest 1.0 ~=? sexp2event (readLisp "(1.0 :REST T)")
              ,Rest 1.0 ~=? sexp2event (readLisp "-1.0")
              ,Chord 1.0 (readLisp "(60)") (readLisp "()")
               ~=? sexp2event (readLisp "1.0")
              ,Chord 0.0 (readLisp "(60)") (readLisp "()")
               ~=? sexp2event (readLisp "0.0")
              ,Chord 0.0 (readLisp "(60)") (readLisp "()")
               ~=? sexp2event (readLisp "-0.0")
              ,Chord 0.0 (readLisp "(60)") (readLisp "()")
               ~=? sexp2event (readLisp "0")
              ,Chord 0.0 (readLisp "(67)") (readLisp "()")
               ~=? sexp2event (readLisp "(0 :NOTES (67))")
              ,Chord 3.0 (readLisp "(67)") (readLisp "(:ACCENT)")
               ~=? sexp2event (readLisp "(3 :NOTES (67) :EXPRESSIONS (:ACCENT))")
              ,Chord 3.0 (readLisp "(60)") (readLisp "(:ACCENT)")
               ~=? sexp2event (readLisp "(3 :EXPRESSIONS (:ACCENT))")
              ,Rest 0.0 ~=? sexp2event (readLisp "(0.0 :REST T)")
              ,Rest 0.0 ~=? sexp2event (readLisp "(0 :REST T)")
              ]
