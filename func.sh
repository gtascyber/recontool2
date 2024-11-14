#!/bin/bash

# Author: George Tasios
# FileName: func.sh
RED='\e[31m'
REDI='\e[3;31m'
GREEN='\e[92m'
BLUE='\e[94m'
YELLOW='\e[33m'
LIGHTYELLOWBACK='\e[103m'
LIGHTRED='\e[91m'
ENDCOLOR='\e[0m'




# Function to display script title and information
printTitle() {
 echo -e "\n${GREEN}===============================================================${ENDCOLOR}"
 echo -e "${RED}====== ${LIGHTYELLOWBACK}${BLUE}~Exposed Surface Reconnaissance~ Tool Version 1.0${ENDCOLOR}${RED} ======${ENDCOLOR}"
 echo -e "${GREEN}===============================================================${ENDCOLOR}"
 echo
 echo -e "${GREEN}-${RED}Author: ${BLUE}G.Tasios${ENDCOLOR}${GREEN}${ENDCOLOR}"
 echo
 echo
 echo -e "${GREEN}(${RED}WARNING! ${GREEN}Don't forget to use a VPN connection...)${ENDCOLOR}"

}

# Function to display script footer when it is stopped or finishes its actions
printFooter() {
 echo -e "\n\n${RED}Deleting temporary files...  (e.g. url file, etc...)${ENDCOLOR}"
 echo
 echo
 echo -e "${BLUE}======================================================${ENDCOLOR}"
 echo -e "${BLUE}==================${ENDCOLOR}${RED} D O N E . . . ! ${BLUE}===================${ENDCOLOR}"
 echo -e "${BLUE}======================================================${ENDCOLOR}"

}


# Function to display script usage options
usage() {
 echo
 echo "Usage: $0 [OPTIONS]"
 echo "Options:"
 echo " -h,      Display this help message"
 echo " -d,      insert the domain for investigation (required)"
 echo " -a,      Active mode enabled. Performs deep DNS enumeration techniques like zone transfers, port scanning of SSL/TLS, certificates grabbing etc. (*CAUTION: More than usually time needed)"
 echo " -v,      Enable verbose mode"
 echo " -b,      Brute force SubDomain Enumeration with default dictionary. Use along with -w flag to use your own wordlist"
 echo " -w,      Path to use wordlist for sub-domains brute forcing."
 echo
 echo
 echo
 echo

 echo -e "${BLUE}======================================================${ENDCOLOR}"
 echo -e "${BLUE}==================${ENDCOLOR}${RED} D O N E . . . ! ${BLUE}===================${ENDCOLOR}"
 echo -e "${BLUE}======================================================${ENDCOLOR}"

}







#Checks internet connection. If it is down, stops the program 
checkInternetConnection() {
  echo -e "\n\n${BLUE}Checking internet connection...${ENDCOLOR}\n"
  sleep 3
  wget -q --spider http://google.com
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Internet connection seems OK...${ENDCOLOR}"
  else
    echo -e "${RED}Internet connection seems down...\nCheck your connection and try again later...${ENDCOLOR}\n"
    exit 1
  fi
}



# Function that creates a timestamp and inputs it in a global variable
# will be used in next steps for time counting reasons
timer_start() {
  declare -g start_time=$(date +%s)
  start_time_formated=$(date +"%H:%M.%S\"(%d-%m-%Y)")
  echo -e "\n---->${BLUE}Running started at: ${GREEN}$start_time_formated${ENDCOLOR}\n"
}


#catches the exit status of the previously executed commands. actually gets the 
#exit status code of 'check_url_redirect.py' file
checkPythonExit() {
if [ $? -eq 1 ]; then
    echo "Exiting Reconnaissance Tool....."
    printFooter
    exit 1
fi
}


# Check if the FINALURL variable starts "http" in order to stop the program if URLTEMP file hasn't been read succesfully
urltempcheck() {
if [[ ! $FINALURL == http* ]]; then
    echo -e "\nFINAL URL seems that does not appear in URLTEMP.txt file.\nPlease check again. (Variable does not start with http)\nExiting script....."
    exit 1
fi
}



#Used as time checkpoint. We can insert an argument $1 in order to appear when this function prints the elapsed time
time_elapsed() {
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  days=$((elapsed_time / 86400))
  hours=$(( (elapsed_time % 86400) / 3600 ))
  minutes=$(( (elapsed_time % 3600) / 60 ))
  remaining_seconds=$((elapsed_time % 60))
  DAYS=""
  HOURS=""
  MINUTES=""
  if [ "$days" -gt 0 ]; then
    DAYS="${GREEN}$days ${YELLOW}Days,"
  fi
  if [ "$hours" -gt 0 ]; then
    HOURS="${GREEN}$hours ${YELLOW}Hours,"
  fi
  if [ "$minutes" -gt 0 ]; then
    MINUTES="${GREEN}$minutes ${YELLOW}Minutes,"
  fi

  echo -e "\n---->${BLUE}$1: $DAYS $HOURS $MINUTES ${GREEN}$remaining_seconds ${YELLOW}Seconds\"....${ENDCOLOR}\n"

}



# Spinner. Animation that indicates to the user the programm is still running. 
# Because of the extend times that it takes to run, this spinner is necessary to exist, in order to inform the user that the system is not "halted"
spinner() {
    i=1
    sp="▖▘▝▗"
    echo -n ' '
    echo "Running......"
    while [ -d /proc/$1 ]
    do
        printf "\b${sp:i++%${#sp}:1}\b"
    done &
}



#checks if nmap is installed and if file with IPs exists. Called from 'checkservices.sh' 
nmapCheck() {
  #firstly we will check if the nmap tool is installed
  command -v nmap >/dev/null 2>&1 || { echo >&2 "Nmap is required and it seems not to be installed. Please install it."; exit 1; }

  #check if the IPs file exists
  if [ ! -f "$input_file" ]; then
    echo "Nmap Error: Input file not found: $input_file"
    exit 1
  fi

}



amassProcessCheck() {
  PIDCHECK2=$(pgrep "amass")
  if [[ ! $PIDCHECK2 == "" ]]; then
    echo -e "\nKilling enumeration process..."
    sudo kill $PID2
  fi
}



# This Function checks if a process is still running
isProcessRunning() {
    process_id=$1
    if [ ps -p $process_id ] > /dev/null; then
        return 0  # Process is running
    else
        return 1  # Process is not running
    fi
}


# Checks if neo4j is running. If it is, prints as output the '1'
check_neo4j_running() {
    if neo4j status | grep "is running at" --quiet; then
        val=1
    else
        val=0
    fi
echo $val
}




