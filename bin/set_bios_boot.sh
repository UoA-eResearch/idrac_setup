#!/bin/bash
# Set booting via BIOS, not uefi

USAGE="Usage: $0 ntradm_pwd host1 ... hostN"

if [ $# -lt "2" ] ; then
	echo "$USAGE"
	exit 1
fi

admin='ntradm'
cake=$1 ; shift

for hname in "$@" ; do
  echo "Set BIOS Boot and powercycle " ${hname}
  racadm -r ${hname} -u ${admin} -p ${cake} set bios.biosbootsettings.BootMode Bios
  racadm -r ${hname} -u ${admin} -p ${cake} serveraction powercycle
done
