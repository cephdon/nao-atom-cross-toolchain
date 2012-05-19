#!/bin/sh
cd `dirname $0` && time make -f makefile.mak &&
echo "------------- DONE ---------------" ||
echo "------------- FAILURE ---------------"
