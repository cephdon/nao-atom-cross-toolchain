#!/bin/sh
cd `dirname $0` && time make -f makefile.mak "THE_TARGET=linux32" "SANDBOX=yes" &&
echo "------------- DONE ---------------" ||
echo "------------- FAILURE ---------------"
