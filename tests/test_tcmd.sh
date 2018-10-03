#!/bin/bash
# ---
# test_tcmd.sh - shell program which runs tests to verify ../bin/tcmd functions correctly
# ---
PRG="tcmd"
TPRG=$(basename $0)
trap "TRAP=TRUE; teardown; exit 1" 1 2 3 15
OUT_FILE=/tmp/${TPRG}_$$
teardown(){
  if [ -f "$OUT_FILE" ]; then rm -rf "$OUT_FILE"; echo "Note: rm -rf $OUT_FILE"; fi
  exit 
}

     CWD=$(pwd)
TCMD_DIR=${CWD}/../bin
    TCMD=${TCMD_DIR}/tcmd
source ${CWD}/../inc/test_utils.sh

# ----
# print out a header with the name of the program
print_header "$TPRG"
EXP_DATE=$(date +%Y) # Get current year like 2018 for positive test cases to pass

# ----
# Execute functional tests
(
  # Simple case test
  $TCMD date $EXP_DATE

  # stderr and return code on error case where there is no stdout
  $TCMD -v -r 127 -e "command not found" dat ""

  # Negation test
  $TCMD -v -n -c "--negate test" date 2016

  # Negation test
  $TCMD --negate date 2015

  # export OUT=$($TCMD -d date $EXP_DATE 2>&1)
  # $TCMD "echo $OUT" "DBG" | wrapline

  # Another simple case
  $TCMD "ping -c 3 localhost" "3 packets received"

  # Test using stdin
  date | $TCMD -s : $EXP_DATE

  # Test using stdin
  date | $TCMD -c "cmd=date via --stdin" --stdin : $EXP_DATE

  # Test a semi-colon stringing two command together in cmd string 
  $TCMD  -v "touch myfile; test -f myfile && rm -f myfile"  ""

  # Test multiline and comment
  $TCMD  -c "multiline test" "cat /etc/hosts" "localhost"

  # Test stdin handles multiline and comment
  cat /etc/hosts | $TCMD  -sc "multiline test" ":" "localhost"

  # Test backslashing a '+' regex metachar
  $TCMD  -c "manual backslash test" 'echo "a + b"' "a \+ b"

  # Test backslashing a '+' regex metachar with -b
  $TCMD  -c "-b backslash test" -b 'echo "a + b"' "a + b"

  # Test tcmd not outputing to stdout
  OUT=$($TCMD  date "this should fail to match date in stdout"); RET=$?
  # Now run tcmd again just on the return code of the previous tcmd 
  echo "$RET" | $TCMD -c "tcmd date fail" -s -v : 1

  # How to feed tcmd a VARIABLE for the CMD and print the CMD as a comment
  CMD="date $EXP_DATE"
  tcmd -c "tcmd $CMD" $CMD

) | tee $OUT_FILE 2>&1

# ----
# Count the passes and failures
print_test_counts "$OUT_FILE"

# ----
# Do some cleanup like removing $OUT_FILE
teardown
