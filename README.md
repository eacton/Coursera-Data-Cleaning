Course Project README 
============================
Human Activity Recognition Using Smartphones Tidy Data Set  
=====================================================================================
By Erica Acton
---------------------------------------------------------------------------------------

*The dataset used was taken from the following study:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

The dataset was downloaded, and a working directory was set.

To create a 'Tidy Dataset' the following steps were taken:

Step 1 - The data sets were read in.  This included all files in the training and test folders that were not in the Inertial Signals subfolder.  Also included were the activity labels and features text files in the UCI HAR Dataset.

Step 2 - Next, I looked at the dimensions and structure of these dataframes.  For both the training and test sets labelled 'y_test.txt' and 'y_train.txt', I could see that despite 2947 or 7352 observations, respectively, only 6 unique options existed.  Since there were 6 activity labels associated with the dataset, I assumed these dataframes described the type of activity.  Similarly, 'x_test.txt' and 'x_train.txt' had columns of 561 variables - the same number of variables described in features.txt, and I assumed these features to match the column variables.  'Subject_train.txt' had 30 unique identifiers, which we know is the number of volunteers in the study.  I took this dataframe and 'subject_test.txt' to be the subject_ids.  In this step, I also made activity labels, and feature labels, but I did not yet apply them to the data.

Step 3 - I combined all of the test data into one test dataset, and all of the training data into one training dataset, columnwise.  I then merged these two datasets by row to create a merged dataset, mergedDat.

Step 4 - I created factor levels by activity, and labelled them with previously created activity labels.  I labelled the columns at this point, using 'subject_id', 'activity', and the vector of names previously created from features.txt.  I then checked to see if the renaming occurred, and if all cases in mergedDat were complete (which they were).

Step 5 - I created subsets of the data that contained mean and standard deviation variables, and merged them, together with the subject_id and activity.  I checked the structure of my dataset.  I then omitted subsets with meanFreq and angle features, which I considered separate features from the mean and standard deviation.  I checked to make sure these columns were omitted.

Step 6 - I then made a series of adjustments to column names to make them more descriptive.  This included expanding upon single letters or short forms to create words, remove symbols such as brackets and dashes, and make the text lowercase.  While I know it is preferred to have all lowercase without spaces or dots, or to use camelcase (as stated in a video lecture), because the variable names were so lengthy, I found it made the variable names more readable to include underscores between the words.  It was also a convention mentioned in "http://csgillespie.wordpress.com/2010/11/23/r-style-guide/".  I then verified the name changes.

Step 7- I then reshaped the data with the melt function, and calculated the average for each variable by subject_id and activity.

Step 8 - Save the tidy dataset to file!  Mission accomplished!!

