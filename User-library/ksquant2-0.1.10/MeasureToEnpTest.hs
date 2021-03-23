module MeasureToEnpTest where
import Measure
import MeasureToEnp
import Enp
import Test.HUnit
import Data.Ratio
import Lisp (readLisp)

n60 = readLisp "(60)"
nil = readLisp "()"

mtoenp1 = TestList
           [
            Enp.Measure (4,4) (4,60) [Enp.Div 4 [Enp.Chord 1 False n60 nil]]
            ~=? let leaf = (L 1 False 0 n60 nil)
                in mToEnp
                       [(0,leaf)]
                       (M (4,4) (4,60 % 1) leaf)
           ,Enp.Measure (1,4) (4,60) [Enp.Div 1 [Enp.Chord 1 False n60 nil]]
            ~=? let leaf = (L (1%4) False 0 n60 nil)
                in mToEnp
                       [(0,leaf)]
                       (M (1,4) (4,60 % 1) leaf)           
           -- ,Enp.Measure (2,4) [Enp.Div 1 [Enp.Chord 1 False],
           --                    Enp.Div 1 [Enp.Chord 1 False,Enp.Chord 1 False]]
           --  ~=? mToEnp (m (2,4) (60 % 1)
           --                      (d (2%4) 1
           --                             [(l (1%4) False),
           --                              (d (1%4) 1 [(l (1%8) False),
           --                                          (l (1%8) False)])]))      
           -- ,Enp.Measure (2,4) [Enp.Div 1 [Enp.Chord 1 False],
           --                    Enp.Div 1 [Enp.Chord 1 False,Enp.Chord 1 False]]
           --  ~=? mToEnp (m (2,4) (60 % 1)
           --                      (d (2%4) 1 [(d (1%4) 1 [(l (1%4) False)]),
           --                                  (d (1%4) 1 [(l (1%8) False),
           --                                              (l (1%8) False)])]))           
           ]
