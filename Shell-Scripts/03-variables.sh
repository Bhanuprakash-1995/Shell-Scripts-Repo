#!/bin/bash
USER1=$1
USER2=$2

echo "$1 :: Hi $2, Good Morning"
echo "$2 :: Hello $1 Good Morning"

echo "To Know the exit status:: $?"
echo "To know the script name:: $0"
echo "To Know the 1st argument:: $1"
echo "To Know the 2nd argument:: $2"
echo "To Know the how many arguments passed to the scripts:: $#"
echo "To know the all the argument:: $@"
