# tcmd - Functional Test Command Program and Framework

Simple Bash/Shell Unit and Functional Test Command Framework and Examples.

## Overview

I wrote this framework because I could not find a good test unit test framework for testing bash scripts. I also needed a way to quickly write functional tests for these bash programs I developed.  I looked at different bash framewoks and found them flawed or overly complex like Bats, roundup, shunit2, and others.  I created a simple example of how to follow good test driven design by wrapping your shell code into functions (**prg_functions.sh**) with the unit tests embedded inside at the bottom to test each function.  Simply source your functions (**prg_functions.sh**) into your bash program (**prg.sh**) and you have a good mechanism for unit tests.  

I also could not find a good test tool for writing functional tests (testing that all the command line options work for example) for the bash scripts.  I created **tcmd** to simply run a command and check the stdout, stderr, and return code against regular expresssions.  This works well for me and I can create a functional tests quickly by just putting some **tcmd**s into a test.sh script and I am done.

## Description

This project is a simple test framework for building shell scripts and also for functional testing any program on a Linux platform.  The python 2.7 program **tcmd** runs a command and checks the stdout of the command against a regular expression.  This allows one to quickly build a functional test suite testing all the options and features of any command line program.

The framework also demonstrates how to design and write a unit test for a bash/shell script.  
See:

* **prg.sh**  
* **inc/prg_functions.sh**. 

The general procedure is to create functions in an bash include file like **prg_functions.sh** that can be tested and have return statuses and then inside your bash **prg.sh: source prg_functions.sh**.  Once your program is designed this way you can use a subshell at the bottom of **prg.sh** to execute your unit tests (on the **prg_functions.sh**).  

To write and desgin tests for bash scripts, you should include **unit AND functional** tests.  This sample framework gives you my best practice for this and includes the program **tcmd** to write functional tests quickly and easily.

See the files in the framework for detailed examples.  The **tests/test_tcmd.sh** program demonstrates a lot of the different ways to write functional tests quickly.  The program can run any command, not just bash/shell commands.

The simple case to write a functional test is like this:

```
joe@joemac:[bin] tcmd date 2018
Pass: cmd [date]; regex [2018]

joe@joemac:[tcmd] tcmd -v date 2018
Pass: cmd [date]; regex [2018]
      actual_return: [0] expected_return: [0]
      actual_stderr: []  expected_stderr: [^$]

      expected_stdout: [2018]
        actual_stdout: [Wed Oct  3 08:57:32 PDT 2018]
      
joe@joemac:[tcmd] tcmd "ping -c 3 localhost" "0.0% packet loss"
Pass: cmd [ping -c 3 localhost]; regex [0.0% packet loss]

joe@joemac:[tcmd] tcmd "ping -c 3 localhost1" "0.0% packet loss"
Fail: cmd [ping -c 3 localhost1] stdout does *NOT* match regEx [0.0% packet loss]
      actual_return: [68] expected_return: [0]
      actual_stderr: [ping: cannot resolve localhost1: Unknown host]  expected_stderr: [^$]

      expected_stdout: [0.0% packet loss]
        actual_stdout: []
```

View and run the **tests/test_prg.sh** program to see another example:

```
joe@joemac:[tests] test_prg.sh
---
Test: test_prg.sh
---
Pass: cmd [prg.sh -h]; regex [Usage: prg.sh \[-h\] -add <int1> <int2>]
Pass: cmd [prg.sh -h]; regex [Usage: prg.sh .-h. -add <int1> <int2>]
Pass: cmd [prg.sh -add 2 3]; regex [add 2 \+ 3 = 5]
      cmd_return: [5]
      cmd_stderr: []
           regex: [add 2 \+ 3 = 5]
      cmd_stdout: [add 2 + 3 = 5]
Pass: cmd [prg.sh -add 2 3]; regex [add\ 2\ \+\ 3\ \=\ 5]
      cmd_return: [5]
      cmd_stderr: []
           regex: [add\ 2\ \+\ 3\ \=\ 5]
      cmd_stdout: [add 2 + 3 = 5]
Pass: cmd [prg.sh -multiply 2 3]; regex [multiply 2 \* 3 = 6]
      cmd_return: [6]
      cmd_stderr: []
           regex: [multiply 2 \* 3 = 6]
      cmd_stdout: [multiply 2 * 3 = 6]
---
Test Summary: test_prg.sh_98976
---
Passes: 5
 Fails: 0
 Total: 5
---
Note: rm -rf /tmp/test_prg.sh_98976
```

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development of shell scripts and testing purposes.

### Installing

Install the framework by running git clone or downloading the zip file.

```
git clone https://github.com/joebmt/tcmd.git
```

### Python Dependencies Prerequisites

You will need to install the python click and pydoc libraries:

```
pip install -r inc/requirements.txt
```

## Running the tests

Run the functional tests for **tcmd** and the **prg.sh** template:

```
cd tests
test_tcmd.sh
test_prg.sh
```

To run the unit tests in **prg.sh** template:

```
cd inc
prg_functions.sh
```

### Functional Test Examples

There are two example tests to use as templates for **tcmd** functional tests:

```
./tests/test_tcmd.sh
./tests/test_prg.sh
```

For example, build a functional test suite like this:

```
joe@joemac:[tests] cat test_prg.sh
# ---
# test_prg.sh - shell program which runs tests to verify ../prg.sh functions correctly
# ---
PRG="prg.sh"
TPRG=$(basename $0)
OUT_FILE=/tmp/${TPRG}_$$
teardown(){
  if [ -f "$OUT_FILE" ]; then rm -rf "$OUT_FILE"; echo "Note: rm -rf $OUT_FILE"; fi
  exit
}
trap "TRAP=TRUE; teardown; exit 1" 1 2 3 15

     CWD=$(pwd)
TCMD_DIR=${CWD}/../bin
    TCMD=${TCMD_DIR}/tcmd
source ../inc/test_utils.sh
print_header "$TPRG"

# ----
# Execute functional tests
(
  cd ..
  # ---
  # Test the usage message -h option (Note: Have to backslash the square brackets since regex metachar
  $TCMD "$PRG -h" "Usage: prg.sh \[-h\] -add <int1> <int2>"

  # ---
  # Test the usage message -h option (Note: Have to use . for any char because '[]' are metachars
  $TCMD "$PRG -h" "Usage: prg.sh .-h. -add <int1> <int2>"

  # ---
  # Test the -add option with return code of 5 and stdout message
  # Note: '+' is a regex metachar so either have to backslash or use -b option
  $TCMD -v -r 5 "prg.sh -add 2 3" "add 2 \+ 3 = 5"

  # ---
  # Same test as above but using -b to backslash the regex
  # Note: '+' is a regex metachar so either have to backslash or use -b option
  $TCMD -v -b -r 5 "prg.sh -add 2 3" "add 2 + 3 = 5"

  # ---
  # Test the -multiply option with return code of 6 and stdout message
  # Note: '*' is a regex metachar so either have to backslash or use -b option
  $TCMD -v -r 6 "prg.sh -multiply 2 3" 'multiply 2 \* 3 = 6'

  # $TCMD -v $PRG "something_without_a_return"
  cd $CWD
) | tee $OUT_FILE 2>&1

# ----
# Count the passes and failures
print_test_counts "$OUT_FILE"

# ----
# Do some cleanup like removing $OUT_FILE
teardown
```

### Unit Test Example

The program **prg_functions.sh** shows how to embed unit tests inside your 

```
vi inc/prg_functions.sh

function ...
function ...
...
# ---
# Unit Tests: Will only run if called via prg_functions.sh standalone
(
    [[ "${BASH_SOURCE[0]}" == "${0}" ]] || exit 0
    echo ---
    echo "Note: Executing ${BASH_SOURCE[0]} unit tests"
    echo ---
    PASS_CNT=0
    FAIL_CNT=0

    # ---
    # Utility Test Functions for unit tests
    function assertEquals()
    {
        MSG=$1; shift
        EXPECTED=$1; shift
        ACTUAL=$1; shift
        # /bin/echo -n "$MSG: "
        if [ "$EXPECTED" != "$ACTUAL" ]; then
            echo "Fail: EXPECTED=[$EXPECTED] ACTUAL=[$ACTUAL]"
            return 1
        else
            echo "Pass: $MSG"
            return 0
        fi
    }

    function addcnt()
    {
        # if [ "$DBG" = true ]; then echo "Note: Inside addcnt()"; set -xv; fi
        # set -xv
        RETURN_CODE=$1
        # echo "Note: addcnt(): RETURN_CODE: $RETURN_CODE"
        if [ $RETURN_CODE -eq 0 ]; then
            PASS_CNT=$((PASS_CNT+1))
        else
            FAIL_CNT=$((FAIL_CNT+1))
        fi
        # set +xv
    }

    function print_results()
    {
        echo "Total Pass: $PASS_CNT"
        echo "Total Fail: $FAIL_CNT"
        echo "Total Cnt : $(($PASS_CNT+$FAIL_CNT))"
    }

    function verify_something_without_a_return()
    {
        if [ "$DBG" = true ]; then echo "Note: Inside verify_something_without_a_return()"; : ; fi
        something_without_a_return
        if [ -f "/tmp/b" ]; then
          echo "Pass: something_without_a_return()"
          return 0
        else
          echo "Fail: something_without_a_return(): /tmp/b does not exist"
          return 1
        fi
    }

    # ---
    # Start of unit tests

    add 2 3
    assertEquals "add 2 3: adding two numbers" 5 $?; RET=$?
    addcnt $RET

    multiply 2 3
    assertEquals "multiply 2 3: multiply two numbers" 6 $?; RET=$?
    addcnt $RET

    verify_something_without_a_return; RET=$?
    addcnt $RET

    print_results
)
```

## Framework Files

The framework and description looks like this:

```
.
├── bin
│   ├── b     (utility to backup files recursively)
│   └── tcmd  (functional python test tool to test any command line program)
├── inc
│   ├── prg_functions.sh (include file for prg.sh to run)
│   ├── requirements.txt ("pip install -r requirements.txt" for tcmd python dependencies to install)
│   └── test_utils.sh    (include file for tests/test_prg.sh to run some test utility functions)
├── prg.sh    (template for a bash script; source inc/prg_functions.sh)
├── pydoc
│   └── tcmd.html (pydoc html file for tcmd python program)
├── License.md (Apache 2 License)
├── Readme.md  (this Readme.md file)
└── tests
    ├── test_prg.sh      (functional tests for prg.sh using tcmd functional test tool)
    └── test_tcmd.sh     (functional tests for tcmd functional test tool)
```

## tcmd Usage Message

The functional test tool **tcmd** is pretty powerful and simple to use.  You can specify regular expressions to match against **stdout, stderr, and the command return status**.  It defaults to the empty string for **stderr** and **'0'** for the return status of the command.  

Usage:

```
joe@joemac:[bin] tcmd -h
Usage: tcmd [options] CMD REGEX

  tcmd - test a commands output against a regular expression

   Desc: tcmd [Options] cmd regEx
           ====================================================================
           cmd      ........... cmd to execute and test stdout, stderr, exit status
           regEx    ........... regular expression to test the expected stdout of
                                the command
           ====================================================================

  Examples:
    tcmd date 2018          ... date | grep -i 2018
    tcmd -c "date test" date 2018
                            ... date | grep -i 2018 with a comment added to Pass/Fail lines
    date | tcmd -s -c "cmd=date via --stdin" : 2018
                            ... same as line above only using stdin and not testing return_code and stderr
    tcmd -n date 2016       ... date | grep -v 2016 (negate regEx test=Pass)
    tcmd -d 'cat /etc/hosts' '#|localhost'
                            ... cat /etc/hosts | egrep -i "#|localhost"
    tcmd -h                 ... this help message
    tcmd -d -v date 2018    ... turn on debug and verbose output and check date cmd against regex 2018
    tcmd -v "touch myfile; test -f myfile && rm -f myfile"  ""
                            ... sting multiple commands together with ';' or && or ||
    OUT=$(cat /etc/hosts)
    echo "$OUT" | tcmd -s -v -c "bash variable test" : localhost
                            ... echo "$OUT" | grep -i localhost (uses a bash variable w/--stdin)

  Notes:
    1. You can specify regEx as "" or "^$" for the empty string
    2. regex matches re.MULTILINE by default and not begin and end of string
    3. This program only tested on python 2.7
    4. This program requires textwrap and click python modules to be installed
       Run: 'pip install -r inc/requirements.txt' to install these two modules
    5. See tests/test_tcmd.sh for more examples of syntax

  Warning:
    1. You have to backslash regular expression meta chars on command line if you want them
       to be interpreted as literal characters in the regex
       (tcmd does not escape the metachars for you unless you use the --backslash option)
       For example, use:
         tcmd -v 'echo "add x+y"' "add x\+y"
                                       (^ backslashed the '+' regex metachar)
           instead of
         tcmd -v 'echo "add x+y"' "add x+y"
       Python regex metachars:
         \       Escape special char or start a sequence.
         .       Match any char except newline, see re.DOTALL
         ^       Match start of the string, see re.MULTILINE
         $       Match end of the string, see re.MULTILINE
         []      Enclose a set of matchable chars
         R|S     Match either regex R or regex S.
         ()      Create capture group, & indicate precedence
         *       0 or more. Same as {,}
         +       1 or more. Same as {1,}
         ?       0 or 1. Same as {,1}

Options:
  -d, --dbg                 Turn debug output on
  -e, --error <text>        Stderr compared to regex
  -n, --negate              Opposite (negate) regex operator like grep -v
  -c, --comment <text>      Add a comment to Pass/Fail lines
  -s, --stdin               Pipe stdin as cmd subsitute with :
  -r, --return_code <text>  The return status compared to regex
  -v, --verbose             Turn verbose output on
  -p, --pydoc               Generate pydoc
  -t, --time                Report Execution time in seconds
  -b, --backslash           Backslash all regex meta chars
  -h, --help                This usage message
```

## b (backup program) Usage Message

I included a simple backup program I use when I am developing bash/shell scripts.  I simply run **b** in the root directory when I am developing if I am not using my Intellij IDE so that I can back out changes or have a copy in case I accidently remove a file or files.  I know the name **b** is not a best practice but since I type it so frequently I called it **b** instead of **backup.sh** so I could save typing keystrokes.

Usage:

```
b - backup files to ../.backup directory w/timestamp name
Usage: b [-h] [file1 file2 ...]
   Ex: b ............... backups all files recursively in current directory to ../.backup/<all_sub_dirs>
   Ex: b a b ........... backup files a and b in ../.backup/a ../.backup/b
   Ex: b * ............. backup all files only in current directory; no sub directories
```

## Authors

* **Joe Orzehoski** - *Initial work* - [Linkedin Profile](http://www.linkedin.com/in/joeorzehoski)

## License

This project is licensed under the Apache License - see the [License.md](License.md) file for details

## Acknowledgments

* Stackoverflow

