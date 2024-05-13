#!/bin/bash

function help() {
    echo "Usage: $0 [OPTIONS]" #standardowa pierwsza linia skryptu z opcją help
    echo ""
    echo "OPTIONS: "
    echo " -d, --date      to show today's date"
    echo " -l, --logs [NUM]  to create 100 or n log files and to write file name, script name and date to created files"
    echo " -h, --help      for help"
    echo " -e, --error [NUM] to create error files, default is 100"
    echo " --init to    to clone repository and set PATH"
    echo ""
}

function logs() {
    num_files=${1:-100}

    for i in $(seq 1 $n); do
           echo "File: log$i.txt" > log$i.txt
           echo "Script: $0" >> log$i.txt
           echo "Date: $(date)" >> log$i.txt
    done

    echo "$num_files log files created."
}

function error() {
    num_files=${1:-}

    for i in $(seq 1 $num_files)
    do
        echo "File name: error$i.txt" > error$i.txt
        echo "Created by: $0" >> error$i.txt
        echo "Date: $(date)" >> error$i.txt
    done

    echo "$num_files error files created"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    help
elif [[ "$1" == "--date" || "$1" == "-d" ]]; then
    echo "Today's date: $(date)"
elif [[ "$1" == "--logs" || "$1" == "-1" ]]; then
  if [[ -z "$2" ]]; then
    logs
  else
    logs "$2"
  fi
elif [[ "$1" == "error" || "$1" == "-e" ]]; then
  if [[ -z "$2" ]]; then
    error
  else
    error "$2"
  fi
elif [[ "$1" == "-innit" ]]; then
    git clone git@github.com:W-Pawlik/Lab4.git
    export PATH=$PATH:$(pwd)/Lab4/bash-scripts
else
    echo "Invalid option. Use --help or -h to display help menu."
fi
while [[ $# -gt 0 ]]; do
    case "$1" in
           --date)
               echo "Today's date: $(date +%Y-%m-%d)"
               exit 0
               ;;
           --logs)
               logs $2
               exit 0
               ;;
           --help)
               help
               exit 0
               ;;
           *)
               echo "Error: wrong option: $1"
               help
               exit 1
               ;;
       esac
done

branch_name="taskBranch-$(date +%Y%m%d-%H%M%S)"
echo "Creating new branch $branch_name..."
git checkout -b $branch_name

echo "Changing files..."
# changes are made here

echo "Making changes..."
git add .
git commit -m "Commit message"
git push

echo "Merging branch with main branch..."
git checkout main
git merge $branch_name

echo "Creating tag v1.0..."
git tag v1.0
git push --tags
