 <p>A very Basic Machine Learning algorithm, namely the k-NearestNeighbors classifier. The algorithm is used to predict
whether a student will pass or fail in their final exam, given their midterm and quiz scores. The word classifier means
that we’re trying to develop an algorithm, that given previous students (from previous years) and their labels (student grades and
pass/fail as a label in this case), we want to predict the labels for new students (from this year), given
only the new students’ grades. </p>

A kNN classifier in this case will take as an input two main parameters: a list of students who we wish
to classify whether they pass, and a list of old students who we know their midterm and quiz scores, and
we also know if the passed/failed from their previous exams. So for example, we know for the year 2013
the grades of the students and whether they passed or not, and we’re trying to predict whether some
students from 2017 will pass or not.

<p>When predicting whether a new student will pass or not, the algorithm works as follows:</p>

1. Computes the distance between a new student and all the old students (using any distance metric,
such as the Euclidean distance).
2. Selects the top K closest old students based on the previously computed distances.
3. Chooses the most repeated label (pass/fail) in top K as the predicted label (pass/fail) for the new
student
