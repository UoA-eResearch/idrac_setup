# Misc iDRAC scripts

## New Servers
1 `add_users.sh <root_pwd>`
  adds the ntradm and itsadm users
  We use have 3 admin accounts, so we can change a password without needing to do that everywhere
  root in the OME server (ends up in the OME database, after a host discovery)
  ntradm for our logins and scripts
  itsadm for Connect logins to the iDRACS
2 `idrac_update.sh <ntradm_pwd> <host> ...`
   Set up SNMP, SMTP, ... on a new server

## Initial boot
* `pxeboot_now <ntradm_pwd> <host> ...`
  Set a server's next boot to PXE and power cycle
* `set_bios_boot.sh <ntradm_pwd> <host> ...`
  Change from the default UEFI to BIOS booting
  For some hosts, this works better

## Working on servers
* `disable_alerts <ntradm_pwd> <host> ...`
  Temporary disabling of iDRAC alerts
* `enable_alerts <ntradm_pwd> <host> ...`
   Restores iDRAC alerts

## Information dumps
* `get_interfaces <ntradm_pwd> <host> ...`
   Returns the server's interface names and MAC addresses
* `idrac_json_dump <ntradm_pwd> <host> ...`
  Creates a JSON file for each server, with iDRAC settings
