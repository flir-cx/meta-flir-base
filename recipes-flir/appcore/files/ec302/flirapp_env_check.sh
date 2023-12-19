#!/bin/bash -e

declare -i count=0

echo 512 > /proc/sys/fs/mqueue/msgsize_max
echo 80 > /proc/sys/fs/mqueue/msg_max

rm -rf `ls /tmp/FLIRevent/* | grep -v Progress`
rm -rf `ls /dev/mqueue/* | grep -v Progress`

# Wait until videorender started streams
while true; do	
	if [ $count -gt 10 ]; then
		exit 0
	fi

	if journalctl -u videorender | grep -q "Have all streams"; then
		echo "Videorender ready"
		exit 0
	fi

	echo "Wait for Videorender..."
	sleep 0.5
	count=$count+1
done

