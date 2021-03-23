module Input where
import qualified Interval as Iv

type Time = Float

data Event = Event Time Time
             deriving Show

instance Iv.Interval Event Time where
    start (Event start _     ) = start
    end   (Event _     end   ) = end

instance Iv.Point Time Time where
    point x = x

-----------------------------

data QEvent = QEvent Rational Rational [Event]
              deriving Show

instance Iv.Interval QEvent Rational where
    start (QEvent start _   _) = start
    end   (QEvent _     end _) = end
