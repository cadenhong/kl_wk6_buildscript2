#!/bin/bash

##############################################################################################
# Name: Caden Hong
# Date: August 9, 2022
#
# wc -l organized.csv | awk '{print $1} _> first part gives out number and file name, so I awked only the number
# if in awk -> numeric comparison
#
# potential error: if I assign 350 to a value and replace it in the if statement it won't run correctly
#############################################################################################

ps aux --sort -rss > processes.txt
#echo "PID,RSS,MEM_Converted" > organized.csv
awk '{ if (($6/1024) > 350) {print $2, $6, ($6/1024)} }' processes.txt | tr ' ' ',' > organized.csv

echo $'\nChecking system processes and performance...\n'
# sleep 2

if [ $(wc -l organized.csv | awk '{print $1}') -ge 1 ]; then
  echo "WARNING! Total of $(($(wc -l organized.csv | awk '{print $1}')-1)) process(es) exceeding 350 MB of memory."

  while true;
  do
    read -p $'\nWould you like to terminate these processes? (y/n): ' input

    case $input in
      n | N) echo $'Exiting without terminating any processes...\nWARNING! Your performance may be affected.\n' ;;
      y | Y) break ;;
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
    mb=$(awk -F, '{print $3}' <<< $line)
    name=$(ps -p $pid -o comm=)
    echo "  PID $pid ($name), $mb MB"
  done


#  awk -F, '{print $1}' organized.csv > kill.txt
#  for line in $(cat kill.txt)
#  do
#    name=$(ps -p $line -o comm=)
#    echo "$name (PID: $line)"
#  done

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
  echo $'\nSystem check completed.\n'
  exit

else
  echo $'There are no system processes exceeding 350MB of memory.\n'
fi
exit
