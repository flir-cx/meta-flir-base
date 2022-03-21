#!/bin/sh
# Set u-boot environment to default (for evco...)

# Save persistent vars over default fw data
tmpval=$(fw_printenv ethaddr)
ethexist=$?
ethaddr="${tmpval##*addr=}"
tmpval=$(fw_printenv system_active)
system_active=${tmpval##*active=}
#echo ethaddr $ethaddr

# Clear memory areas in /dev/mmcblk0 where u-boot environment is stored
# Compare fw_env.config
dd if=/dev/zero of=/dev/mmcblk0 seek=1835008 bs=1 count=16384 >/dev/null 2>&1
dd if=/dev/zero of=/dev/mmcblk0 seek=1966080 bs=1 count=16384 >/dev/null 2>&1

#restore ethaddr (mac) if present
if [ $ethexist -eq 0 ]
then
    echo "restores ethaddr"
    fw_setenv ethaddr $ethaddr >/dev/null 2>&1
else
    echo "no ethaddr to restore"
fi
#restore system_active
fw_setenv system_active $system_active >/dev/null 2>&1

echo u-boot environment set to default


