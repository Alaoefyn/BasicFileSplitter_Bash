#!/bin/bash

# Affan Selim KAYA
# 200709006
# Computer Engineering (English)
# Shell Programming CES301
# 2022-2023 1st Somestr (2022-Fall)
# Project: 1
# Asst.Prof.Dr Deniz DAL


# Algorithm Work Principal

# We need to  have a file that is specified as argument1 and the number of lines of the file is known as X.
# We need to divide the lines of this file equally into the number of the entered number of argument2 (X/argumant2), and we also have 4 argument conditions (I checked the tests with if statement).
# Since the comments are descriptive in the description of the tests, I do not write them here to avoid long writing.
# In order to facilitate the calculations on the file to be processed, I used the `wc` and cut command together and checked the number of lines and assigned the variable `numberOfLines`. (The reason I put the `wc` command at the top is to prevent it from running unnecessarily since I don't use a function.)
# With the help of extension, I created the filename variable to separate the extension and work on the file without the extension.
# Then, since the number of lines is known, I used a for loop to keep track of the number of each file.
# I counted backwards from all known rows with `tail` so that the rows do not repeat. With Head, I took it from the fixed number of rows (I thought it was correct to subtract it from the number of rows because the number of rows is known, so that it does not repeat what it has taken from the number of rows). In other words, if we want to divide the 100-line file into 5 files, the lines in the files to be created should first go as 100-80, 80-60 (decreasing by 20 since it is divided by 5).
# While the number of lines is distributed to new files, there are two possibilities, either the number of lines is divided by the file to be split or not. Since we have to find the remainder in the indivisible, we need to do modulo. Since the head alone is not enough, I provided an equal distribution by making a remainder (modulo) to support the head. Because if we do not look at the remainder, if the head gets all of them equal, the lines will repeat. For example, if we want to divide the 100-line file into 3 new files, the head will want to make them 34 34 34. So 100 it will distribute the row as if it were 102 rows. 
# But code uses the remainder like this ---If remainder greater than  0,add 1 to linesToSplit then assign to currentPart variable.
# With that,for example, we can make 34 33 33 equally, that is, first it makes 33 33 33, and and stops when the remainder becomes 0 .
# I made the For Loop increment one by one. The reason I did it this way is that it is easier to increment it one by one in order to ensure equality. For example, let's divide the 100-line file into 6 files.There would not have been a very equal distribution, as it can be seen. When we increased it one by one and divided it into 17-17-17-17-16 -16, we had a more equal distribution for the initial files and provided the remaining files as just as possible.





numberOfLines=$(wc -l "$1" | cut -d " " -f 1)

#Test1: Checks if given  argumants are only 2,if not,then warn user and print Usage info. 
if [ $# -ne 2 ]; then
    echo "Warning! Usage of Code is: $0 <The desired file to split:> <How many new splitted files wanted?:>"
    exit 1
#Test2: Checking  if arg1 is a file or not
elif [ ! -f "$1" ]; then
    echo "Error: $1 is not a file!"
    exit 1
#Test3: Checking if arg2 is positive integer or not with less or equal than 0
elif [ "$2" -le 0 ]; then
    echo "Error: $2 is not a positive integer.Please check again!"
    exit 1
#Test4: Checking if arg2 is smaller than arg1 number of lines or not with greater than 0
elif [ "$2" -gt "$numberOfLines" ]; then
    echo "Error: $2 is larger than $1 number of lines."
    exit 1
# if all test checks are passed, run the code 
else
    
    fileName=$(basename -- "$1")
    extension=$(echo "$fileName" | cut -f 2 -d '.')
# In start,i used variable subsitution ${fileName##%.*},but we didnt learn in class varsub so i changed it to cut
    fileName=$(echo "$fileName" | cut -f 1 -d '.')

    numberOfFiles="$2"

    # Gets how many lines to split
    remainder=$((numberOfLines % numberOfFiles))
    linesToSplit=$((numberOfLines / numberOfFiles))

    # Loop for each file
    for (( i=1; i<=numberOfFiles; i++ )); do
        # If remainder is greater than 0, add 1 to linesToSplit and decrement remainder
        if [ $remainder -gt 0 ]; then
            currentPart=$((linesToSplit + 1))
            ((remainder--))
        # else, linesToSplit is equal to currentPart
        else
            currentPart=${linesToSplit}
        fi
        
        # Subtract currentPart from numberOfLines and get the tail of the file
        tail -n $(( numberOfLines - ((i-1) * currentPart) )) "$1" | head -n $currentPart > "$fileName-$i.$extension"
    done
fi


