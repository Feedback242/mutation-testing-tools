Setting up Defects4J
================

Requirements
----------------
 - Java 1.8
 - Git >= 1.9
 - SVN >= 1.8
 - Perl >= 5.0.12

Defects4J version 1.x and 0.x required Java 1.7.


#### Java version
All bugs have been reproduced and triggering tests verified, using the latest
version of Java 1.8.
Using a different version of Java might result in unexpected failing tests on a fixed
program version. 

#### Timezone
Defects4J generates and executes tests in the timezone `America/Los_Angeles`.
If you are using the bugs outside of the Defects4J framework, set the `TZ`
environment variable to `America/Los_Angeles` and export it.

#### Perl dependencies
All required Perl modules are listed in [cpanfile](https://github.com/rjust/defects4j/blob/master/cpanfile).
On many Unix platforms, these required Perl modules are installed by default.
If this is not the case, see instructions below for how to install them.

Steps to set up Defects4J
----------------

1. Clone Defects4J:
    - `git clone https://github.com/rjust/defects4j`

2. Initialize Defects4J (download the project repositories and external libraries, which are not included in the git repository for size purposes and to avoid redundancies):
   If you do not have `cpanm` installed, use cpan or a cpan wrapper to install the perl modules listed in `cpanfile`.
    - `cd defects4j`
    - `cpanm --installdeps .`
    - `./init.sh`

3. Add Defects4J's executables to your PATH:
    - `export PATH=$PATH:"path2defects4j"/framework/bin`

4. Check installation:
    - `defects4j info -p Lang`

On some platforms such as Windows, you might need to use `perl "fullpath"\defects4j`
where these instructions say to use `defects4j`.


Running Mutation Testing Tools
----------------

1. run the script projectSetup.sh
     - ./projectsSetup.sh
2. to run the tools Major, Mujava, PItest run the scripts  major, mujava, and pitest (For each script is recommended not to be run on the same code, because there can be errors). For MMT you need to clane and run [MMT](https://pages.uni-marburg.de/fb12/plt/modbeam-mt/mmt)  and then enter the the projects created form step one
