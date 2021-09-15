#!/bin/bash


################################################################################
#                                                                              #
# Name: process.sh                                                             #
# Description: Moves incoming files to Azure Blob storage                      #
# Author: Sajal Sachdev <defaultuser@example.com>                              #
#                                                                              #
# Exit codes:                                                                  #
# 0: All is well on some front somewhere                                       #
# 1: Parameter(s) missing                                                      #
# 2: Required something something missing (e.g. permissions or executable)     #
# 3: Something went wrong with the copy to Azure                               #
#                                                                              #
################################################################################


# Names are cool
FILE="$1"

# Minimize using relative paths, for example:
# if we don't check whether "processed" is a directory, all your files could be overwritten by the next one and called "processed"
# (luckily it's already save in the cloud :D)
PROCESSED_DIR="$PWD/processed"

# It can be wise to use full paths in scripts
# (e.g. sometimes cron lacks a $PATH)
AZCOPY="/path/to/azcopy"

# You could make URI + Token parameters?
CONTAINER_URL="<add container URL here + SAS Token>"



# (I prefer this style but yours is faster and arguably more readable)
# Note the use of double brackets for testing (man test)
#
# BTW, did you know '[' is the same as the 'test' command? ==> ls -l /bin[

# FILE passed? (Rubin insists that [[ ! -n "$FILE" ]] is better (I'm just stubborn))
[[ -z "$FILE" ]] && echo "Usage $0: file" && exit 1

# FILE writeable?
[[ ! -w "$FILE" ]] && echo "Incoming file ($FILE) is not writable, exiting..." && exit 2

# AZCOPY executable?
[[ ! -x "$AZCOPY" ]] && echo "Unable to execute azcopy ($AZCOPY), exiting..." && exit 2

# PROCESSED_DIR directory and writable?
[[ ! -d "$PROCESSED_DIR" ]] || [[ ! -w "$PROCESSED_DIR" ]] && echo "Something is wrong with the processed directory ($PROCESSED_DIR), exiting..." && exit 2



# Unsure whether azcopy does but most apps return their exit code in '$?'
# If you don't need the output, you don't need a sub-shell, if you do, use $() instead of backticks, they are so nineties ;)
$AZCOPY copy "$FILE" "$CONTAINER_URL"
[[ $? -ne 0 ]] && echo "DANGER Will Robinson, azcopy of file ($FILE) failed, exiting..." && exit 3


# Apparently we didn't exit prior to this point so it should be safe to move the file
# Don't forget to QUOTE your variables, it will mess you up (e.g. spaces in filenames, empty variables)
# Take care when mv-ing files, in some cases it's better to cp and then remove (here it's fine)
mv "$FILE" "$PROCESSED_DIR"


# Ah well let's return something
exit 0
