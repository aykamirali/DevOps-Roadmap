
#!/bin/bash
echo "================================="

echo "Quoted DOLLAR-AT"
for ARG in "$@"; do
    echo $ARG
done

echo "================================="

echo "NOT Quoted DOLLAR-AT"
for ARG in $@; do
    echo $ARG
done

echo "================================="

echo "Quoted DOLLAR-STAR"
for ARG in "$*"; do
    echo $ARG
done

echo "================================="

echo "NOT Quoted DOLLAR-STAR"
for ARG in $*; do
    echo $ARG
done

echo "================================="


Now, run the test script with various arguments:

# ./test.sh  "arg with space one" "arg2" arg3
=================================
Quoted DOLLAR-AT
arg with space one
arg2
arg3
=================================
NOT Quoted DOLLAR-AT
arg
with
space
one
arg2
arg3
=================================
Quoted DOLLAR-STAR
arg with space one arg2 arg3
=================================
NOT Quoted DOLLAR-STAR
arg
with
space
one
arg2
arg3
=================================
