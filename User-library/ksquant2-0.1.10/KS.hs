module KS where

import Enp
import qualified Measure as M
import Lily
import MeasureToLily
import MeasureToEnp
import Lisp
import System.IO
import System.Cmd
import Data.Ratio
import qualified AbstractScore as A

ms = M.measuresWithBeats [(5,8),(13,4)] (repeat 60)
score = A.completeToScore (A.Voice ms)
-- m = M.measuresDivideLeafs (M.measuresWithBeats [(4,4)] [60]) (repeat 1)
-- m = [(M.m (4,4) 60 (M.l (4%4) False))]
enp = fmap mToEnp score
l = fmap mToLily score

main = do
  exportLily "foo" l
  writeFile "/tmp/toll.enp" (printLisp (score2sexp enp))
  rawSystem "scp" ["/tmp/toll.enp", "plmb.local:/tmp/sc.lisp"]
