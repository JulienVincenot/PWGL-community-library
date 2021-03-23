module IntervalTest where
import Interval
import Test.QuickCheck
import Data.List (delete,sort,nub)

ivmax = 30::Int
domain = [0..ivmax]

data TestInterval = TestInterval (Int,Int)
                    deriving Show

instance Interval TestInterval Int where
    start (TestInterval x) = start x
    end (TestInterval x) = end x

instance Point Int Int where
    point x = x

instance Arbitrary TestInterval where
    arbitrary     = do
      a <- choose (0, ivmax-1)
      b <- choose (a+1, ivmax)
      return (TestInterval (a,b))

prop_good_iv :: TestInterval -> Bool
prop_good_iv iv = start iv < end iv

prop_isPointInInterval :: TestInterval -> Bool
prop_isPointInInterval iv = any (isPointInInterval iv) domain

prop_intersect :: TestInterval -> TestInterval -> Bool
prop_intersect a b = intersect a b == safe_intersect a b
    where safe_intersect _ _ = any inBoth domain
          inBoth x = isPointInInterval a x && isPointInInterval b x

prop_isStrictlyAfter :: TestInterval -> TestInterval -> Bool
prop_isStrictlyAfter a b = isStrictlyAfter a b == safeisStrictlyAfter a b
    where safeisStrictlyAfter a b = not (a `intersect` b) && start b >= end a

filteredDomain2Intervalls [] = []
filteredDomain2Intervalls (x:xs) = map TestInterval (r xs x x)
    where r [] start last = [(start,last+1)]
          r (x:xs) start last | x == last + 1 = r xs start x
                              | otherwise = (start,last+1) : r xs x x

deleteRandom list = do
  pos <- choose (0, length list - 1)
  return (delete (list !! pos) list)

monadRepeat :: (Monad m) => Int -> m a -> (a -> m a) -> m a
monadRepeat 0 x _ = x
monadRepeat n x fn = monadRepeat (n-1) (x >>= fn) fn

instance Arbitrary (AscendingIntervals TestInterval) where
    arbitrary     = do
      n <- choose(0,ivmax)
      list <- monadRepeat n (return domain) deleteRandom
      return (ascendingIntervals (filteredDomain2Intervalls list))

instance Arbitrary (AscendingPoints Int) where
    arbitrary     = do
      n <- choose(0,ivmax)
      list <- monadRepeat n (return domain) deleteRandom
      return (ascendingPoints list)

prop_groupPointsByIntervalls :: AscendingIntervals TestInterval -> AscendingPoints Int -> Bool
prop_groupPointsByIntervalls ivs xs = groupPointsByIntervalls ivs xs == safe_groupPointsByIntervalls ivs xs
    where safe_groupPointsByIntervalls ivs _ = map grap (getAscendingIntervals ivs)
          grap iv = ascendingPoints (filter (isPointInInterval iv) (getAscendingPoints xs))

mt ivs xs = safe_groupPointsByIntervalls ivs xs
    where safe_groupPointsByIntervalls ivs _ = map grap (getAscendingIntervals ivs)
          grap iv = ascendingPoints (filter (isPointInInterval iv) (getAscendingPoints xs))

prop_ascendingIntervals2points :: AscendingIntervals TestInterval -> Bool
prop_ascendingIntervals2points ivs = ascendingIntervals2points ivs == safe_ascendingIntervals2points ivs
    where safe_ascendingIntervals2points ivs = let ivs' = getAscendingIntervals ivs
                                                in (ascendingPoints . sort . nub) (map start ivs' ++ map end ivs')
