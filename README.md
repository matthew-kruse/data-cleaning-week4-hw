# data-cleaning-week4-hw

Homework Assignment for Week 4

Execution:
Assuming 'run_analysis.R is in rstudio's or r's current working directory simply run:
```
source('run_analysis.R')
```
This will produce a file in the current working directory called results.txt

run_analysis.R performs the following tasks

1. Downloads the source data
2. Extracts the source data
3. Loads the source data into R
4. Merges the test and training data sets for the activities, subjects and data
5. Appropriately names the activities and subject columns
6. Filters out all the columns that are not a standard deviation or a mean
7. Appropriately names the remaining columns in the data variable
8. For each remaining column the mean is calculated based off a unique activity and subject
9. Finally a file is written to the current working directory called results.txt
