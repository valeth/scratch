#!/usr/bin/env bash

shaker_sort() {
    local array=($@)
    local f=0
    local l=$((${#array[@]} - 1))
   
    for x in ${array[@]}; do
        for ((i = f; i < l; ++i)); do
            if (( ${array[i]} > ${array[i + 1]} )); then
                array[i]=$(( ${array[i]} + ${array[i + 1]} ))
                array[i + 1]=$(( ${array[i]} - ${array[i + 1]} ))
                array[i]=$(( ${array[i]} - ${array[i + 1]} ))
            fi
        done
        (( --l ))

        for ((i = l; i > f; --i)); do
            if (( ${array[i]} < ${array[i - 1]} )); then
                array[i]=$(( ${array[i]} + ${array[i - 1]} ))
                array[i - 1]=$(( ${array[i]} - ${array[i - 1]} ))
                array[i]=$(( ${array[i]} - ${array[i - 1]} ))
            fi
        done
        (( ++f ))

    done

    echo ${array[@]}
}
