#!/bin/sh
SERIAL=$(grep Serial /proc/cpuinfo)
echo ${SERIAL##Serial*:}
