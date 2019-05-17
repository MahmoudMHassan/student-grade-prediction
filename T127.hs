import Data.List
import Data.Ord -- library used to use the "comparing length" used by maximumBy in the function mode  

data Ex = Ex Float Float String String deriving Show
data NewSt = NewSt Float Float String deriving Show
data Dist = Dist Float NewSt Ex deriving Show


--Takes as input a NewSt type and an Ex type, and returns an object of type Dist, which holds the euclidean distance between the two inputs
-- the euclidean distance is calculated using the following equation:-
--  SquareRoot( (midtermGradeOfNewStudent-midtermGradeOfExStudent)^2 + (QuizGradeOfNewStudent - QuizGradeOFExStudent)^2 )

euclidean :: NewSt -> Ex -> Dist 

euclidean (NewSt e f g) (Ex a b c d) = Dist ( sqrt((e-a)^2 + (f-b)^2)) (NewSt e f g) (Ex a b c d)   

---Takes as input a NewSt type and an Ex type, and returns an object of type Dist, which holds the manhattan distance between the two inputs.
-- the manhattan distance is calculated using the following equation:-
-- absolute(midtermGradeOfNewStudent-midtermGradeOfExStudent) + absolute(QuizGradeOfNewStudent - QuizGradeOfExStudent)

manhattan :: NewSt -> Ex -> Dist

manhattan (NewSt e f g) (Ex a b c d) = Dist ( abs((e-a) + (f-b)) ) (NewSt e f g) (Ex a b c d) 
---

---Takes as an input a generic distance function (euclidean/manhattan) and two points, and returns a Dist
---object holding the distance function applied on the two points.

dist :: (a -> b -> c) -> a -> b -> c

dist f a b = f a b  

---

---Takes as an input a distance function, a data-point x (for example a NewSt), and a list of data-points lst (for example a list of Ex).
-- Returns a list of Dists, which is all the distances from x to elements in lst.

all_dists :: (a -> b -> c) -> a -> [b] -> [c]

all_dists f x [] = []

all_dists f x (y:ys) = f x y:all_dists f x ys

---
--- Given a number n and a list l, the function should return the first n elements from the list

takeN :: Num a => a -> [b] -> [b]

takeN 0 l = [] 

takeN n (x:xs) =   x:takeN (n-1) xs
---

--- implementing the insertion sort algorithm in the coming two functions insert1 and sort1
--insert1 that inserts a given element into a sorted list so that the new list is also in sorted order

insert1 :: Dist -> [Dist] -> [Dist]

insert1 (Dist a b c) [] = [(Dist a b c)]
insert1 (Dist a b c) ((Dist e f g):ys) | a < e = (Dist a b c):(Dist e f g):ys
                | otherwise = (Dist e f g):insert1 (Dist a b c) ys

--Using the function insert1,  sort1 is used to sort the list using the insertion sort algorithm.

sort1 [] = []
sort1 (x:xs) = insert1 x (sort1 xs)

---
insert2 :: Dist -> [Dist] -> [Dist]

insert2 (Dist a b c) [] = [(Dist a b c)]
insert2 (Dist a b c) ((Dist e f g):ys) | a > e = (Dist a b c):(Dist e f g):ys
                | otherwise = (Dist e f g):insert2 (Dist a b c) ys
---
--Given a generic distance function, a number n, a list of Ext and a St object to be classified, returns a
--list of Dist objects. The list should be the closest n objects to the St object. As mentioned above we use the insertion sort algorithm to sort the list 
--and got the closed n objects to the St object using the takeN function

closest :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [Dist]

closest f n (x:xs) y =takeN n (sort1(all_dists f y (x:xs)))

---

sort2 [] = []
sort2 (x:xs) = insert2 x (sort2 xs)

--
frest ::Num a => a -> [Dist] -> [Dist] -- Num a => (b -> c -> Dist) -> a -> [c] -> b -> [Dist]

frest n (x:xs) =  takeN n (sort2(x:xs)) 

--Given a generic distance function, a number n, a list of Ext and a St object to be classified, returns a list of lists of Dist objects. 
--2 lists are returned in the the returned list, the first for “pass” and second for “fail”, filled with the correct elements from the function closest. 
--We used the groupBy from Data.List to group to pass and fail lists and the cmp1 is the comperator function given to groupBy

grouped_dists :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [[Dist]]

grouped_dists f n (x:xs) y =  groupBy cmp1 (closest f n (x:xs) y)

cmp1 (Dist val newst1 (Ex a b c d)) (Dist val1 newst11 (Ex a1 b1 c1 d1)) = d1 == d

---
--Given a generic distance function, a number n, a list of Ext and a St object to be classified, returns a list of Dist objects.
-- The list should contain the Dist objects of only the most frequent label; for example if there are two Dist objects with their
-- Ex objects having the label “pass”, and only one object with the label “fail”, only the first two objects should be kept. 
--We used the function maximumBy from Data.List and comparing length from Data.Ord to get the max length list of lists  

mode :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> [Dist]

mode f n (x:xs) y =   maximumBy (comparing length) (grouped_dists f n (x:xs) y)


---
--Given a list of Dist objects, extracts a tuple from the first element of the list containing the name of the
--NewSt object and the label of the Ex object

label_of :: [Dist] -> ([Char],[Char])

label_of ((Dist x (NewSt e f g) (Ex a b c d)):xs) = (g,d) 

---
--Given a generic distance function, a number k, a list of Ex and a NewSt object to be classified, returns a tuple containing the name of the NewSt
-- object and the predicted label (most repeated class in the k-neighborhood)

classify :: Num a => (b -> c -> Dist) -> a -> [c] -> b -> ([Char],[Char])


classify f k (x:xs) y = label_of (mode f k (x:xs) y)

---
--Given a generic distance function, a number k, a list old of Ex objects, and a list new of NewSt objects,returns the predictions for every element
-- in new using the k-neighborhood from the list old. The result should be a list of tuples, containing the name and label of each element.

classify_all :: (a -> b -> Dist) -> Int -> [b] -> [a] -> [([Char],[Char])]

classify_all f k e [] = []

classify_all f k e (x:xs) = classify f k e x : classify_all f k e xs