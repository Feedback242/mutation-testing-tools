#!/usr/bin/env bash
unset $PATH
unset $CLASSPATH
export PATH=$PATH:~/IdeaProjects/defects4j/framework/bin
HERE=$(cd `dirname $0` && pwd)

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
    if [ -d "$directory/build" ]; then

                # Check if the "build" directory exists
                if [ -d "$directory/build-tests" ]; then
                   build_classes="build"
                  build_tests="build-tests"
                else
                   build_classes="build/classes"
                  build_tests="build/tests"
                fi
            elif [ -d "$directory/target" ]; then
                build_classes="target/classes"
                if [ -d "$directory/target/tests" ]; then
                  build_tests="target/tests"
                else
                  build_tests="target/test-classes"
                fi
            else
              echo "#################################################################"
                build_var="unknown"  # Set a default value if neither directory exists
            fi
    target_classes=$(extract_first_line_with_prefix "$directory/defects4j.build.properties" "d4j.classes.modified=")
    source_dir=$(extract_first_line_with_prefix "$directory/defects4j.build.properties" "d4j.dir.src.classes=")
    tests=$(extract_first_line_with_prefix "$directory/defects4j.build.properties" "d4j.dir.src.tests=")
    line=$(sed -n '1p' $directory/relevant_tests)
    first_line="${line//./\/}"
    classes="${target_classes//./\/}"
    echo $directory/$source_dir
    echo $first_line
    lib=~/IdeaProjects/defects4j/pitest
    CLASSPATH=$(find $directory/lib -type f -name "*.jar" -printf "%p:" | sed 's/:$//')
    export CLASSPATH=$(find $lib -type f -name "*.jar" -printf "%p:" | sed 's/:$//'):$CLASSPATH
    echo $CLASSPATH
    java -cp $directory/$build_classes:$directory/$build_tests:$CLASSPATH \
           org.pitest.mutationtest.commandline.MutationCoverageReport \
           --projectBase $directory \
          --reportDir $directory/mutationReports \
          --targetClasses $target_classes \
          --sourceDirs $directory/$source_dir,$directory/$tests \
          --targetTests $line \
          --verbose true \
          --mutators "STRONGER"\
          --skipFailingTests true
          #--threads 2
          #--excludedMethods hashCode,equals
    echo $first_line

    read -p "$directory Ended. Press Enter to continue..."
  done






}

_run_project Chart
#_run_project Time
#_run_project Lang

#_run_project Math


