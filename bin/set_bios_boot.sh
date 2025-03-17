#!/bin/bash
USAGE="Usage: $0 host1 ... hostN"

if [ $# -lt "1" ] ; then
	echo "$USAGE"
	exit 1
fi

admin='root'
cake=$(pass show idrac/root)

for hname in "$@" ; do
  echo "Set BIOS Boot and powercycle " ${hname}
  racadm -r ${hname} -u ${admin} -p ${cake} set bios.biosbootsettings.BootMode Bios
  racadm -r ${hname} -u ${admin} -p ${cake} serveraction powercycle
done
