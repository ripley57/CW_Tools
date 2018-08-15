#!/bin/bash

for i in {1..20}
do
    _num=$(printf "%03d" $i)
    echo "This is test document $_num" | a2ps --center-title="Test document $_num" -1 -o - | ps2pdf - testfile${_num}.pdf
done
