#!/bin/bash
# Script assumes we have accidentally trashed the maas user by running the add_user.sh script.
# add_user.sh assumes maas has not yet been run, so allocates the first 3 iDRAC user slots to our users.
# MAAS would then add the maas user in slot 5, on first PXE boot


USAGE="Usage: $0 host1 ... hostN"

if [ $# -lt "1" ] ; then
	echo "$USAGE"
	exit 1
fi

cake=$(pass show idrac/root)

# We need to set this index to the index of the maas user
# It should be 5, if we have added root as 2, ntradm as 3 and itsadm as 4
maas_user_index=5
# MAAS password is usually set by MAAS on first PXE boot
# and is unique for each server. This is a hack to add back
# an accidentally deleted maas user, so we set a known password
# Then edit the machine 'Configuration' password for the iDRAC.
maas_pwd=$(pass show idrac/maas)

for i in "$@" ; do
    hname=$i ip=$(host ${hname}.nectar.auckland.ac.nz | awk '/has address/ { print $NF; exit }')
    echo $ip $hname

    # config maas
    #racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.UserName maas
    #racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.Password "$maas_pwd"
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.Privilege 0x0
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.IpmiLanPrivilege 4
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.IpmiSerialPrivilege 0
    # Serial over LAN
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.SolEnable Enabled
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.Enable Enabled
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.${maas_user_index}.SNMPv3Enable Disabled

done
