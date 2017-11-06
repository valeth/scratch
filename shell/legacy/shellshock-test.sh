#!/bin/bash

env z="() { :; }; echo vulnerable" bash -c "echo done"
