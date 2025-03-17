#!/bin/bash


USAGE="Usage: $0 host1 ... hostN"

if [ $# -lt "1" ] ; then
	echo "$USAGE"
	exit 1
fi

cake=$(pass show idrac/root)
ntradm_pwd=$(pass show idrac/ntradm)
itsadm_pwd=$(pass show idrac/connect)

for i in "$@" ; do
    hname=$i ip=$(host ${hname}.nectar.auckland.ac.nz | awk '/has address/ { print $NF; exit }')
    echo $ip $hname

    #racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.5.Privilege 0x1ff
    #racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.5.IpmiLanPrivilege 4

    # config ntradm
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.UserName ntradm
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.Password "$ntradm_pwd"
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.SNMPv3Enable Enabled
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.Privilege 0x1ff
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.IpmiLanPrivilege 4
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.3.Enable Enabled
    racadm -r ${hname} -u root -p ${cake} set iDRAC.VirtualConsole.PluginType 2

    # config itsadm
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.UserName "itsadm"
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.Password "$itsadm_pwd"
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.SNMPv3Enable Enabled
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.Privilege 0x1ff
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.IpmiLanPrivilege 4
    racadm -r ${hname} -u root -p ${cake} set iDRAC.Users.4.Enable Enabled
done

