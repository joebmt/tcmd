# ---
# prg.sh - shell program template
# ---
CWD=$(pwd)
# ---
# Load the functions used in this program here
source ${CWD}/inc/prg_functions.sh

add 2 3; RET=$?
echo "     add 2 3: $RET"
multiply 2 3; RET=$?
echo "multiply 2 3: $RET"
something_without_a_return
