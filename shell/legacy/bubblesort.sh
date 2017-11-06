#!/usr/bin/env bash

bubble_sort() {
    local array=($@)
    local l=${#array[@]}
   
    for x in ${array[@]}; do
        for ((i = 0; i < l - 1; ++i)); do
            if (( ${array[i]} > ${array[i + 1]} )); then
                array[i]=$(( ${array[i]} + ${array[i + 1]} ))
                array[i + 1]=$(( ${array[i]} - ${array[i + 1]} ))
                array[i]=$(( ${array[i]} - ${array[i + 1]} ))
            fi
        done

        (( --l ))
    done

    echo ${array[@]}
}
