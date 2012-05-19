#!/bin/sh
cd `dirname $0` && time make -f makefile.mak "THE_TARGET=linux64" "SANDBOX=no" &&
echo "------------- DONE ---------------" ||
echo "------------- FAILURE ---------------"
