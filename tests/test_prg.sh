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
