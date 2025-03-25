#!/bin/bash
USAGE="Usage: $0 host1 .. hostN"

if [ $# -lt "1" ] ; then
	echo "$USAGE"
	exit 1
fi

admin='root'
cake=$(pass show idrac/root)

for i in "$@" ; do
    hname=$i
    ip=$(host ${hname}.nectar.auckland.ac.nz | awk '/has address/ { print $NF; exit }')
    echo $ip $hname


    #email server setup
    racadm -r ${hname} -u ${admin} -p $cake set iDRAC.RemoteHosts.SMTPPort 25
    racadm -r ${hname} -u ${admin} -p $cake set iDRAC.RemoteHosts.SMTPServerIPAddress '172.31.80.251'

    #set dns suffix otherwise UoA rejects email
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.NIC.DNSRegister 'Enabled'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.NIC.DNSDomainName 'nectar.auckland.ac.nz'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.EmailAlert.1.Address 'nectaralerts@uoa.auckland.ac.nz'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.EmailAlert.1.Enable 'Enabled'

    #SNMP alerts
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.SNMPAlert.1.Destination '172.31.80.98'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.SNMPAlert.1.State 'enabled'
    #enable alerts
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPMILan.AlertEnable 'Enabled'
    racadm -r ${hname} -u ${admin} -p ${cake} eventfilters set -c idrac.alert.system.critical -a none -n 'OSLog,snmp,ws-events,remotesyslog,email,ipmi'
    racadm -r ${hname} -u ${admin} -p ${cake} eventfilters set -c idrac.alert.storage.critical -a none -n 'email,snmp,ws-events,remotesyslog,OSlog'

    ## logsysr
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.SysLog.Port '514'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.SysLog.Server1 '172.31.80.250'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.SysLog.SysLogEnable 'Enabled'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.EmailAlert.2.Enable 'Disabled'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.EmailAlert.3.Enable 'Disabled'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPMILan.AlertEnable 'Enabled'

    # Set the hostname
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.NIC.DNSRacName ${hname}
    racadm -r ${hname} -u ${admin} -p ${cake} set System.ServerOS.HostName ${hname}

    # Setup DNS Servers
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4.DNS1 130.216.1.1
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4.DNS2 130.216.1.2
    # Not sure which to set
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4Static.DNS1 130.216.1.1
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4Static.DNS2 130.216.1.2

    # IPMI LAN
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPMILan.Enable 'Enabled'

    # Time
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.Time.DayLightOffset 0
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.Time.Timezone 'Pacific/Auckland'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.Time.TimeZoneOffset 0
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.NTPConfigGroup.NTP1 'ntp.auckland.ac.nz'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.NTPConfigGroup.NTPEnable 'Enabled'

    # Ensure the IP Mask and Router are correct.
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4Static.Gateway '172.31.80.1'
    racadm -r ${hname} -u ${admin} -p ${cake} set iDRAC.IPv4Static.Netmask '255.255.252.0'

    racadm -r ${hname} -u ${admin} -p ${cake} set idrac.webserver.HostHeaderCheck 'Disabled'
done
