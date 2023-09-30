#!/usr/bin/env bash

unset CLASSPATH
HERE=$(cd `dirname $0` && pwd)

export PATH=$PATH:$HERE/framework/bin
# Import helper subroutines and variables, and init Defects4J
source "$HERE/test.include" || exit 1

_run_project(){
  echo $CLASSPATH

  # Define the directory you want to search
  search_dir=/tmp/$1
  #classes=$2
  #tests=$3
  src=$4
  # Create an empty array to store the directories
  directories=()

  # Use the find command to search for directories and store them in the array
  while IFS= read -r -d '' dir; do
      directories+=("$dir")
  done < <(find "$search_dir" -mindepth 1 -maxdepth 1 -type d -print0)

  # get directory
  for directory in "${directories[@]}"; do
        unset CLASSPATH
         if [[ $directory == *f ]]; then
                    continue
                fi

        export CLASSPATH=$HERE/mujava/mod_test.jar:$HERE/mujava/mujava.jar:$HERE/mujava/openjava.jar:/lib/jvm/java-8-openjdk-amd64/lib/tools.jar:$HERE/mujava/junit-4.12.jar:$HERE/mujava/hamcrest-core-1.3.jar:$HERE/mujava/commons-io-2.13.0.jar:$CLASSPATH
        # Check if the "build" directory exists
        if [ -d "$directory/build" ]; then
            # Check if the "build" directory exists
            if [ -d "$directory/build-tests" ]; then
              classes="build"

              tests="build-tests"
            else
              classes="build/classes"

              tests="build/tests"
            fi
        elif [ -d "$directory/target" ]; then
            classes="target/classes"
            if [ -d "$directory/target/tests" ]; then
              tests="target/tests"
            else
              tests="target/test-classes"
            fi
        else
          echo "#################################################################"
            build_var="unknown"  # Set a default value if neither directory exists
        fi

        echo -e "MuJava_HOME=$directory\nDebug_mode=true" > mujava.config
        java  mujava.makeMuJavaStructure
        mkdir $directory/source
        #
        #
        # mv  $directory/src/* $directory/source
        cp -r $directory/source/* $directory/src
        #mkdir -p "$directory/testset/test/java"
       # mkdir -p "$directory/classes/main/java"
        sed 's/\./\//g' $directory/test_relevant > testpath.txt
        sed "s/$/.class/" testpath.txt > test_absolute_path.txt
        #rsync -av --files-from=test_absolute_path.txt $directory/$tests/ $directory/testset/



        cp -r $directory/$tests/* $directory/testset
        cp -r $directory/$classes/* $directory/classes
        export CLASSPATH=$(find $directory/lib -type f -name "*.jar" -printf "%p:" | sed 's/:$//'):$CLASSPATH
        jar -xfm $directory/lib/joda-convert-1.2.jar  -C $directory/classes

        echo $CLASSPATH
        #defects4j mutation -w "$directory" -r || die "Mutation analysis (including all mutants) failed!"
        java  mujava.gui.GenMutantsMain
        java RunTestMain
        read -p "$directory Ended. Press Enter to continue..."

  done






}

_run_project Chart "build"
#_run_project Time "target/classes" "target/tests" "src/main/java"
#_run_project Lang "target/classes" "target/tests" "src/main/java"
#_run_project Math "target/classes"


