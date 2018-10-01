# tcmd - Functional Test Command Program and Framework

Simple Shell unit and functional test command framework and examples.

## Description

This project is a simple test framework for building shell scripts and also for functional testing any program on a Linux platform.  The python 2.7 program **tcmd** runs a command and checks the stdout of the command against a regular expression.  This allows one to quickly build a functional test suite testing all the options and features of any command line program.

The framework also demonstrates how to design and write a unit test a bash/shell script.  See **prg.sh** and **inc/prg_functions.sh**. The general procedure is to create functions in an bash include file like **prg_functions.sh** that can be tested and have return statuses and then inside your bash **prg.sh: source prg_functions.sh**.  Once your program is designed this way you can use a subshell at the bottom of **prg.sh** to execute your unit tests (on the **prg_functions.sh**).  

To write and desgin tests for bash scripts, you should include unit AND functional tests.  This sample framework gives you my best practice for this and includes the program tcmd to write functional tests quickly and easily.

See the files in the framework for detailed examples.  The **tests/test_tcmd.sh** program demonstrates a lot of the different ways to write functional tests quickly.  The program can run any command, not just bash/shell commands.

The simple case to write a functional test is like this:

```
joe@joemac:[bin] tcmd date 2018
Pass: cmd [date]; regex [2018]

joe@joemac:[bin] tcmd -v date 2018
Pass: cmd [date]; regex [2018]
      cmd_return: [0]
      cmd_stderr: []
           regex: [2018]
      cmd_stdout: [Mon Oct  1 03:11:40 PDT 2018]
```

View and run the **tests/test_prg.sh** program to see another example:

```
joe@joemac:[tests] test_prg.sh
---
Test: test_prg.sh
---
Pass: cmd [prg.sh]; regex [add 2 3: 5]
Pass: cmd [prg.sh]; regex [multiply 2 3: 6]
Pass: cmd [prg.sh]; regex [something_without_a_return]
      cmd_return: [0]
      cmd_stderr: []
           regex: [something_without_a_return]
      cmd_stdout: [add 2 3: 5
      multiply 2 3: 6
      Inside something_without_a_return()]
---
Test Summary: test_prg.sh_92423
---
Passes: 3
 Fails: 0
 Total: 3
---
Note: rm -rf /tmp/test_prg.sh_92423
```

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

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
# test_tcmd.sh - shell program which runs tests to verify ../bin/tcmd functions correctly
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
  # Ex: tcmd prg.sh "add 2 3: 5"
  $TCMD $PRG "add 2 3: 5"
  $TCMD $PRG "multiply 2 3: 6"
  $TCMD -v $PRG "something_without_a_return"
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
# Unit Tests: Will only run if called via functions.sh standalone
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

## Deployment

The framework and description looks like this:

```
.
├── bin
│   ├── b     (utility to backup files recursively)
│   └── tcmd  (functional python test tool to test any command line program)
├── inc
│   ├── prg_functions.sh (include file for prg.sh to run)
│   ├── requirements.txt ("pip install -r requirements.txt" for tcmd python dependencies to install)
│   └── test_utils.sh    (include file for tests/test_prg.sh to run some utility functions)
├── prg.sh    (template for a bash script; source inc/prg_functions.sh)
├── readme.md (this readme.md file)
└── tests
    ├── test_prg.sh      (functional tests for prg.sh using tcmd functional test tool)
    └── test_tcmd.sh     (functional tests for tcmd functional test tool)
```

## tcmd Usage Message

The functional test tool tcmd is pretty powerful and simple to use.  You can specify regular expressions to match against **stdout, stderr, and the command return status**.  It defaults to the empty string for **stderr** and **'0'** for the return status of the command.

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
  -h, --help                This usage message
```

## Authors

* **Joe Orzehoski** - *Initial work* - [Linkedin Profile](www.linkedin.com/in/joeorzehoski)

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* stackoverflow

