#!/bin/bash

number1=$1
number2=$2

if [ number1 -gt number2 ]; then
    echo "Number1 is greater then Number2"
else
    echo "Number1 is less then Number2"
fi
