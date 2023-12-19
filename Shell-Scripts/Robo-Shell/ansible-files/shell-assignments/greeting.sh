#!/bin/bash

NAME=""
WISHES=""

USAGE() {
    echo "Usage:: $(basename "$0") -n <name> -w <wishes>"
    echo "Options::"
    echo "-n, specify the name (mandatory)"
    echo "-w, specify the wishes, ex, Good morning"
    echo "-h, Dsiplay help and exit"
}

while getopts "n:w:h" opt; do
    case $opt in
    n) Name="$OPTARG" ;;
    w) WISHES="$OPTARG" ;;
    \?)
        echo "Invaild options:-"$OPTARG"" >&2
        USAGE
        exit
        ;;
    h)
        USAGE
        exit
        ;;
    :)
        USAGE
        exit
        ;;
    esac
done

if [ -z $NAME ] || [ -z $WISHES ]; then
    echo "Error: Bothe -n and -w are mandatory options."
    USAGE
    exist 1
fi

echo "Hello $NAME. $WISHES. I have been learnig Devops "
