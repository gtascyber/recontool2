#!/bin/bash

# Author: George Tasios
# FileName: pass_url.sh

# Creation of an environmental variable which contains the passed domain (whether http or https), from python file 'check_url_redirect.py'
echo -e "\nCreating necessary ENVIRONMENT Variables...."
export ENV_MY_URL=$1
echo
echo
echo -e  "\nCreating TEMP files..." 
echo
echo
echo -e "('URLTEMP.txt' file.... )"

# Writes the 'url' which is stored in an environmental variable, into a txt file 
printenv ENV_MY_URL > URLTEMP.txt

# The above txt file after it is used it will be deleted automatically 



