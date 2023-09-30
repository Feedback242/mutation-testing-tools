#!/usr/bin/env bash

HERE=$(cd `dirname $0` && pwd)
export PATH=$PATH:$HERE/framework/bin
# Import helper subroutines and variables, and init Defects4J
source "$HERE/test.include" || exit 1

_run_project(){


  # Define the directory you want to search
  search_dir=/tmp/$1

  # Create an empty array to store the directories
  directories=()

  # Use the find command to search for directories and store them in the array
  while IFS= read -r -d '' dir; do
      directories+=("$dir")
  done < <(find "$search_dir" -mindepth 1 -maxdepth 1 -type d -print0)

  # get directory
  for directory in "${directories[@]}"; do
        if [[ $directory == *f ]]; then
                continue
            fi
            mut_ops_file="$directory/mut_ops.txt"
            echo "AOR ROR COR" > "$mut_ops_file"
        echo $directory
        defects4j export -p  dir.bin.tests -w $directory
        defects4j mutation -w "$directory"  -m $mut_ops_file  || die "Mutation analysis (including all mutants) failed!"
        read -p "$directory Ended. Press Enter to continue..."

  done







}


_run_project Chart
#_run_project Time
#_run_project Lang
#_run_project Math


