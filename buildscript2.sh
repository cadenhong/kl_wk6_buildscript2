#!/bin/bash

####################################################################################################################################
#
# Name: Caden Hong
#
# Date: August 9, 2022
#
# Description: This script will automatically check the server's processes and ask user to terminate a process if memory > 350 MB
#	- Check for processes using ps aux, then sort it by rss column (i.e. memory in KB), and save result to processes.txt
#	- In awk, use a conditional to find all processes that exceeds 350 MB in memory usage, then save the PIDs and converted
#	  memory (from KB to MB) to organized.csv
#	- If there are any processes saved in organized.csv, display the number of processes with a warning message
#		- Case statement (inside a while loop) to ask for user's input on whether they want to terminate those processes
#			- If input is "n" or "N", exit the program with a warning message
#			- If input is "y" or "Y", break case and move to the next section
#			- If input is anything else, while loop will repeat
#		- For loop to read through organized.csv and display PID, name (found with "ps -p $pid -o comm="), and memory
#		- Generate a separate kill.txt file that only contains the PID
#		- While loop to prompt user to input the PID of process they want to terminate
#			- If valid PID (checked against kill.txt with grep), use "kill -15 $input2" to terminate the process
#			- If input is "q" or "Q", break out of loop
#			- If invalid input, the loop will repeat
#		- Exit the program with message "System check completed"
#	- Else, exit the program with message "... no system processes exceeding 350 MB of memory usage"
#
# Potential Error:
#	1. If 350 (or any limit for MB) is assigned to a variable and it is used in line 2, the if statement will not run correctly
# 	2. Even after all the processes are terminated, the last while loop will continue to ask for a PID to terminate -
#	   only way to exit the script at this point is to enter "q" or "Q" to quit
#
####################################################################################################################################

ps aux --sort -rss > processes.txt
awk '{ if (($6/1024) > 350) {print $2, ($6/1024)} }' processes.txt | tr ' ' ',' > organized.csv

echo "---------------------------------------------------------"
echo $'Checking system processes and performance...\n'
sleep 2

if [ $(wc -l organized.csv | awk '{print $1}') -ge 1 ]; then
  echo "WARNING! Total of $(wc -l organized.csv | awk '{print $1}') process(es) exceeding 350 MB of memory."

  while true;
  do
    read -p $'\nWould you like to terminate these processes? (y/n): ' input

    case $input in
      y | Y) break ;;
      n | N) echo $'Exiting without terminating processes...\n\nWARNING! Performance may be affected.\n---------------------------------------------------------' ;;
      *) echo "Invalid input!!" ;;
    esac

  if [[ "$input" = "n" ]] || [[ "$input" = "Y" ]]; then
    exit
  fi
  done

  echo $'\nProcesses that exceed 350 MB of memory:'

  for line in $(cat organized.csv)
  do
    pid=$(awk -F, '{print $1}' <<< $line)
    mb=$(awk -F, '{print $2}' <<< $line)
    name=$(ps -p $pid -o comm=)
    echo "  PID $pid ($name), $mb MB"
  done

  awk -F, '{print $1}' organized.csv > kill.txt

  while true;
  do
    read -p $'\nEnter PID to terminate (q to quit): ' input2
    if grep -xq $input2 kill.txt; then
      kill -15 $input2
      sleep 1
      echo "PID $input2 terminated"
    elif [[ "$input2" = "q" ]] || [[ "$input2" = "Q" ]]; then
      break
    else
      echo "Invalid PID!!"
    fi
  done

  sleep 1
  echo $'\nSystem check completed.'
  echo "---------------------------------------------------------"
  exit

else
  echo "There are no system processes exceeding 350MB of memory usage."
  echo $'---------------------------------------------------------\n'
fi
exit
