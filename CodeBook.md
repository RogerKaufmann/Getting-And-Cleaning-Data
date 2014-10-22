##### Getting and Cleaning Data
# Course Project Codebook

## Raw data

The features in the raw data come from the accelerometer and gyroscope 3-axial raw signals. These are named tAcc-*** and tGyro-***
Leading 't' indicates time domain signals, a leading 'f' indicates frequency domain signals.
For more detail see 'features_info.txt' in the original data set.

## Variable names
The variable names from the raw data are cleaned up as follows

1. all variable names are converted to lower character
2. Brackets `()` are removed and hyphen `-` is replaced with underscore `_`
3. If 't' is the first letter, it is replaced with 'time_'
4. If 'f' is the first letter, it is replaced with 'freq_'

For example, `tBodyAcc-mean()-X` becomes `time_bodyacc_mean_x`.
In my opinion, underscore `_` is a useful character to improve readability of column names.

## Selected variables

### Subjects and activities
* `subject` - The unique ID for the participant. Integer that ranges from 1 to 30
* `activity` - The label of the activity performed. Factor variable that ranges from 1 to 6
	* `WALKING` = `1`
	* `WALKING_UPSTAIRS` = `2`
	* `WALKING_DOWNSTAIRS` = `3`
	* `SITTING` = `4`
	* `STANDING` = `5`
	* `LAYING` = `6`

### Features

The following 66 features have been averaged for each activity and each subject. 
There are at most 4 elements in the variable names:
1. `time` indicates time domain signals; `freq` indicates frequency domain signals
2. Signal abbreviations were not replaced. `acc` stands for acceleration signal
3. `mean` stands for "Mean value", `std` stands for "Standard deviation"
4. If present, `xyz` indicates 3-axial signal in the x, y or z direction.


* `time_bodyacc_mean_x`
* `time_bodyacc_mean_y`
* `time_bodyacc_mean_z`
* `time_bodyacc_std_x`
* `time_bodyacc_std_y`
* `time_bodyacc_std_z`
* `time_gravityacc_mean_x`
* `time_gravityacc_mean_y`
* `time_gravityacc_mean_z`
* `time_gravityacc_std_x`
* `time_gravityacc_std_y`
* `time_gravityacc_std_z`
* `time_bodyaccjerk_mean_x`
* `time_bodyaccjerk_mean_y`
* `time_bodyaccjerk_mean_z`
* `time_bodyaccjerk_std_x`
* `time_bodyaccjerk_std_y`
* `time_bodyaccjerk_std_z`
* `time_bodygyro_mean_x`
* `time_bodygyro_mean_y`
* `time_bodygyro_mean_z`
* `time_bodygyro_std_x`
* `time_bodygyro_std_y`
* `time_bodygyro_std_z`
* `time_bodygyrojerk_mean_x`
* `time_bodygyrojerk_mean_y`
* `time_bodygyrojerk_mean_z`
* `time_bodygyrojerk_std_x`
* `time_bodygyrojerk_std_y`
* `time_bodygyrojerk_std_z`
* `time_bodyaccmag_mean`
* `time_bodyaccmag_std`
* `time_gravityaccmag_mean`
* `time_gravityaccmag_std`
* `time_bodyaccjerkmag_mean`
* `time_bodyaccjerkmag_std`
* `time_bodygyromag_mean`
* `time_bodygyromag_std`
* `time_bodygyrojerkmag_mean`
* `time_bodygyrojerkmag_std`
* `freq_bodyacc_mean_x`
* `freq_bodyacc_mean_y`
* `freq_bodyacc_mean_z`
* `freq_bodyacc_std_x`
* `freq_bodyacc_std_y`
* `freq_bodyacc_std_z`
* `freq_bodyaccjerk_mean_x`
* `freq_bodyaccjerk_mean_y`
* `freq_bodyaccjerk_mean_z`
* `freq_bodyaccjerk_std_x`
* `freq_bodyaccjerk_std_y`
* `freq_bodyaccjerk_std_z`
* `freq_bodygyro_mean_x`
* `freq_bodygyro_mean_y`
* `freq_bodygyro_mean_z`
* `freq_bodygyro_std_x`
* `freq_bodygyro_std_y`
* `freq_bodygyro_std_z`
* `freq_bodyaccmag_mean`
* `freq_bodyaccmag_std`
* `freq_bodybodyaccjerkmag_mean`
* `freq_bodybodyaccjerkmag_std`
* `freq_bodybodygyromag_mean`
* `freq_bodybodygyromag_std`
* `freq_bodybodygyrojerkmag_mean`
* `freq_bodybodygyrojerkmag_std` 