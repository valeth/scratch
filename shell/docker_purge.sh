#!/usr/bin/env bash 

command docker rmi -f $(docker images -qf dangling=true)
