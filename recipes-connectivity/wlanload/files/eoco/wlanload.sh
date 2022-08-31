#!/bin/sh

set -e

# There is an issue with the wifi/bt chip wl1837 that fails the loading of the bt firmware if the 
# wifi is started in parallell. By making sure the hci dev is set up before starting connman this
# can be avoided. Se issue: EOWYN-2870

for i in $(seq 1 5)
do 
    hcitool dev | grep hci0 && break || sleep 1; 
done
