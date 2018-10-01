# tcmd - Functional Test Program and Framework

Simple Shell unit and functional test framework and examples.

## Overview

This project is a simple test framework for building shell scripts and also for functional testing any program on a Linux platform.
The python 2.7 program *tcmd* runs a command and checks the stdout of the command against a regular expression.
This allows one to quickly build a functional test suite testing all the options and features of any command line program.

For example, build a test suite like this:

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
The output of the above program is:

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

### Prerequisites

You will need to install the python click and pydoc libraries:

```
pip install -r inc/requirements.txt
```

### Installing

Install the framework by running git clone or downloading the zip file.

```
git clone https://github.com/joebmt/tcmd.git
```

## Running the tests

Run the functional tests for tcmd and the prg.sh template:

```
cd tests
test_tcmd.sh
test_prg.sh
```

To run the unit tests in prg.sh template:

```
cd inc
prg_functions.sh
```
### Break down into end to end tests

There are two example tests to use as templates for tcmd:

```
./tests/test_tcmd.sh
./tests/test_prg.sh
```

### And coding style tests

Explain what these tests test and why

```
Give an example
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

## Built With


## Contributing


## Versioning


## Authors

* **Joe Orzehoski** - *Initial work* - [Linkedin Profile](www.linkedin.com/in/joeorzehoski)

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* stackoverflow

