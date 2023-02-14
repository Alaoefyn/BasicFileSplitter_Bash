#!/bin/bash


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


