#!/bin/bash

# Author: George Tasios
# FileName: recontool2.sh
# The very first script that handles the flags (arguments)

source ./func.sh
#function to display title
printTitle
# Function to display script usage
act=FALSE
dom=""
verbose_mode=FALSE
wlpath="nopath"
br=FALSE

while getopts ":hvad:bw:" option; do
        case $option in
		d)
                  dom="$OPTARG" #insert domain for investigation e.g. -d example.com
                  ;;
		a)
		  act=TRUE ;;
		v)
		  verbose_mode=TRUE ;;
		h)
                  usage
                  exit 1
                  ;;
		b)
		  br=TRUE ;;
		w)
		  wlpath="$OPTARG" 
		  if [ ! -f $OPTARG ]; then
		    echo "File or path given for wordlist does not exist.."
		    exit 1
		  fi 
		  ;;
		\?)
		  echo "invalid option: -$OPTARG" >&2
		  exit 1
		  ;;
		:)
		  echo "Option -$OPTARG requires an argument." >&2
		  exit 1
		  ;;
		*)
                  echo -e "\n!!!!!!!!!! Invalid Usage !!!!!!!!!!\n"
                  usage
                  exit 1
                  ;;
	esac
done


./runrecon.sh $dom $act $verbose_mode $br $wlpath

