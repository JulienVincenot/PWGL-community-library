module StateTest where
import Control.Monad.State

data Tree a = Leaf a | Branch [Tree a]
            deriving Show

labelTree :: Tree a -> State Integer (Tree Integer)
labelTree (Leaf x)
    = do n <- get
         put (n+1)
         return (Leaf n)

labelTree (Branch ts)
    = do ts' <- mapM labelTree ts
         return (Branch ts')

labelit t = evalState (labelTree t) 0

test2 = let t = Branch [Leaf 'a',Leaf 'b',Leaf 'c']
               in labelit (Branch [t,t])

-----------------------------------------------------
data MTree a = Nil | Node a (MTree a) (MTree a) deriving (Show, Eq)
type Table a = [a]

numberMTree :: Eq a => MTree a -> State (Table a) (MTree Int)
numberMTree Nil = return Nil
numberMTree (Node x t1 t2)
        =  do num <- numberNode x
              nt1 <- numberMTree t1
              nt2 <- numberMTree t2
              return (Node num nt1 nt2)
     where
     numberNode :: Eq a => a -> State (Table a) Int
     numberNode x
        = do table <- get
             (newTable, newPos) <- return (nNode x table)
             put newTable
             return newPos
     nNode::  (Eq a) => a -> Table a -> (Table a, Int)
     nNode x table
        = case (findIndexInList (== x) table) of
          Nothing -> (table ++ [x], length table)
          Just i  -> (table, i)
     findIndexInList :: (a -> Bool) -> [a] -> Maybe Int
     findIndexInList = findIndexInListHelp 0
     findIndexInListHelp _ _ [] = Nothing
     findIndexInListHelp count f (h:t)
        = if f h
          then Just count
          else findIndexInListHelp (count+1) f t

numMTree :: (Eq a) => MTree a -> MTree Int
numMTree t = evalState (numberMTree t) []

testMTree = Node "Zero" (Node "One" (Node "Two" Nil Nil)
                        (Node "One" (Node "Zero" Nil Nil) Nil)) Nil
