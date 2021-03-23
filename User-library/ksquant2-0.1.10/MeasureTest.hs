module MeasureTest where
import Measure
import Test.HUnit
import Data.Ratio
import Lisp

n60 = readLisp "(60)"
nil = readLisp "()"

measure1 = TestList
           [[M (4,4) (4,60 % 1)
             (D (1 % 1) (1 % 1)
              [l (1 % 4) False n60 nil,
               l (1 % 4) False n60 nil,
               l (1 % 4) False n60 nil,
               l (1 % 4) False n60 nil])]
            ~=?  measuresWithBeats [(4,4)] [(4,60)]
           ,[M (3,4) (4,60 % 1)
             (D (3 % 4) (1 % 1)
              [l (1 % 4) False n60 nil,
               l (1 % 4) False n60 nil,
               l (1 % 4) False n60 nil])]
            ~=?  measuresWithBeats [(3,4)] [(4,60)]
           ,[M (5,8) (4,60 % 1)
             (D (5 % 8) (1 % 1)
              (replicate 5 (l (1 % 8) False n60 nil)))]
            ~=?  measuresWithBeats [(5,8)] [(4,60)]
           ]
