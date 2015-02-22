### How it works

There's a file named run_analysis.R containing the script that cleans initial raw data. It shound be executed in the folder containind unzipped raw data to work properly.

### Functions

There are several functions in the file.

* *GetData()* is the wrapping function. It takes working directory as input and returns merged and refined dataset containing both test and training data. Other functions do the actual work, this one just calls them and merges two initial datasets.
* *LoadData()* do the main part of job. It works on one of two datasets. It takes working directory, an auxiliary dataset containing activity ids and activity names and also a mode token (either "test" or "train" dataset to operate on), loads all the data and refines it. The functions reads feature dataset (from "X_test.txt" or "X_train.txt") line by line, calls the *BreakData()* function to parse each line, and adds parsed data to the resulting dataset. At the final stage two other columns are added: one containing tester ids and another - activity names. The function returns the resulting dataset.
* *BreakData()* function parses character string into numeric vector. It simply divides the string to equal 16-char pieces (since all numeric values have the same length), and convert each of them to numeric value. The function returns numeric vector.
* *CalcAverages()* takes the wide tidy dataset and returns aggregated dataset. It just wraps the *aggregate()* function which calculates averages for all numeric columngs where data is grouped by activity name and tester id.

At the end of the script there's several commands that run after sourcing the script into R. In fact, these lines of code call the *GetData()* function, pass the resulting data frame to the *CalcAverage()* function, and then saves the final dataset to disk (the code would be much nicer if I used the pipeline operators, but I remembered it just before the deadline).

### Some assumptions

* The number of strings in of *Y_test.txt* (it is actually activity ids), *X_test.txt* (file containing accelerometer and gyposcope data), and *subject_test.txt* (ids of the testers) must be the same. We bind the data from these files based on the assumption that each i string in the each file applies to the same observation (same applies to the training dataset as well).
* All lines in the X_test.txt must be the same length, and the numeric data must be in the same fixed length format (I should be using *read.table()* or *fread()* from *data.table* package instead, but...).
* I decided to declare indices and related column names of selected data as fixed variables, though it is really lame. It would be much nicer to parse *features.txt* instead, select columns containing "mean" and "std" substrings and then prettify column names. But it would take too much time to learn how to do that in R, and the deadline is almost there, sorry :)

Description of the variables can be found in the *codebook.md* file.
