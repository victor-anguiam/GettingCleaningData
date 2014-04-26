README.md
========================================================

The script 'run_analysis.R' creates a tidy dataset ('X_tidy.txt) from:
'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

which contains averaged values of selected magnitudes (all measurementes refered to mean and std in the original dataset) stratifyied by subject and activity.

To run the script simply load it into a R-session using 'source("run_analysis.R")' and let it go. You also can load and run directly from R-Studio as a simple script. It does not have dependencies on external scripts, though it need 'table.data' library to run.

Two global variables control the behaviour of the script:
* 'verbosity': logical variable. It sets up script to prompt its activity (TRUE) or not at all (FALSE);
* 'hodtmpfiles': logical variable. It controls the preservation of intermediate files and directories (TRUE) or not (FALSE). When 'holdtmpfiles' is FALSE the script saves 'X_tidy.txt' file to the working directory and erases all other intermediate files and directories.

Both variables are defined into the script, declared and initialized at the beginnig.

While running the script it creates a temporary directory 'tmp' into working directory. 'tmp' holds all temporary files and directories and also the resulting dataset 'X_tidy.txt'. If the script is set to erase 'tmp', the resulting dataset 'X_tidy.txt' is saved before to the original working directory.