#!/bin/bash

number1=$1

if [ $number1 > 50 ]; then
    echo "eligible for pension"
    elif [ $number1 >= 25 ]; then
        echo "eligible for job"
    else
        echo "they are kids"
fi            