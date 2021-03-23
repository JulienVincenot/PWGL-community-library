module Unused where

binsearch xs value low high
   | high < low       = Nothing
   | xs!!mid > value  = binsearch xs value low (mid-1)
   | xs!!mid < value  = binsearch xs value (mid+1) high
   | otherwise        = Just mid
   where
   mid = low + ((high - low) `div` 2)

