The dataset contains 68 variables. Almost all of them are numeric variables except two special ones: "Activity" and "Tester". All numeric variables are average meanings of accelerometer and gyroscope data obtained from Samsung smartphones during the experiment, grouped by tester and activity.

**Activity** is the name of the activity during the experiment. Contains one of the following values:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

**Tester** is the id of the person who performed the activity. Contains integer values from 1 to 30.

Numeric variables consist of two large groups. The first group is related to the data in time series (so all the variables of this group have prefix "Time"). The second group is related to the data processed using the Fast Fourier Transform, and names of these variables begin with the prefix "Frequency". 

The two groups are very similar. They both contain variables which hold average meanings for data obtained from accelerometer (name contains "Acceleration" or "Accel" substring) and gyroscope ("Gyroscope" or "Gyro"). Variables with "X", "Y", "Z" indices contain data related to measurements along X, Y or Z axes, "Jerk" is related to derivative from acceleration, and "Magnitude" — to the magnitude of measured signals. Finally, variables containing "Mean" and "StdDev" are related to mean values and standard deviations respectively.
