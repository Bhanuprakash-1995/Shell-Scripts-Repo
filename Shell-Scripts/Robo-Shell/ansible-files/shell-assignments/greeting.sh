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
    h | *)
        USAGE
        exit
        ;;
    esac
done
