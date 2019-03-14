#
# (C) Copyright IBM Corporation 2011, 2016
#

# Example AMESTER script for connecting to OpenPOWER with OpenBMC.

#
# Important globals. Change for your environment.
#

# Put the BMC IP address on the next line
set ::bmc_address <ADDRESS>
# IPMI account name for BMC
set ::ipmi_user ADMIN
# IPMI password
set ::ipmi_passwd ADMIN

# Allow above to be placed on command line
if {[llength $::script_argv] == 3} {
    set ::bmc_address [lindex $::script_argv 0]
    set ::ipmi_user [lindex $::script_argv 1]
    set ::ipmi_passwd [lindex $::script_argv 2]
} elseif {[llength $::script_argv] > 0} {
    puts "usage:  amester openpower.tcl <bmc_ip_addr> <userid> <password>"
    exit 0
}

# Sensors to display in GUI
set ::gui_sensor_list {
    PWRSYS
    TEMPNEST
    TEMPC00
    TEMPC01
    TEMPC02
    TEMPC03
    TEMPC04
    TEMPC05
    TEMPC06
    TEMPC07
    TEMPC08
    TEMPC09
    TEMPC10
    TEMPC11
    TEMPC12
    TEMPC13
    TEMPC14
    TEMPC15
    TEMPC16
    TEMPC17
    TEMPC18
    TEMPC19
    TEMPC20
    TEMPC21
    TEMPC22
    TEMPC23
    TEMPDIMM01
    TEMPDIMM02
    TEMPDIMM03
    TEMPDIMM04
    TEMPDIMM05
    TEMPDIMM06
    TEMPDIMM07
    TEMPDIMM08
    TEMPDIMM09
    TEMPDIMM10
    TEMPDIMM11
    TEMPDIMM12
    TEMPDIMM13
    TEMPDIMM14
    TEMPDIMM15
}

# Parameters to display in GUI
set ::gui_parm_list {
    sys_fmax
    sys_fmin
    freq_reason
}


# To display the debug window, uncomment the next line
#::amesterdebug::window

# To see debugging output from various AMEster subsytems, uncomment some of
# the following lines
#::amesterdebug::set openpower 1
#::amesterdebug::set options 1
#::amesterdebug::set network 1
#::amesterdebug::set ipmi 1
#::amesterdebug::set ame 1
#::amesterdebug::set sensor 1
#::amesterdebug::set tb 1
#::amesterdebug::set parm 1
#::amesterdebug::set gui 1
#::amesterdebug::set health 1
#::amesterdebug::set login 1
#::amesterdebug::set histogram 1
#::amesterdebug::set object 1
#::amesterdebug::set destructor 1
#::amesterdebug::set init 1
#::amesterdebug::set exit 1
#::amesterdebug::set threads 1
#::amesterdebug::set bgerror 1
#::amesterdebug::set host 1
#::amesterdebug::set hostnet 1

#To send debug output to a file, uncomment the following lines.
# set ::thedebugfile [open "mydebugfile" w]
# ::amesterdebug::output $::thedebugfile

# Connect to OpenPOWER system with OpenBMC.
openbmc $::bmc_address -addr $::bmc_address -ipmi_user $::ipmi_user -ipmi_passwd $::ipmi_passwd

# Setup GUI
foreach ame [find objects -isa ame] {
    puts "Set up ${ame}"

    # Set up continuous polling of sensors on each POWER8 chip
    # and raise sensor window.
    ${ame} set_sensor_list $::gui_sensor_list
    ${ame} sensor_window_raise

    # Set up continuous polling of sensors on each POWER8 chip
    # and raise sensor window.
    ${ame}_parm gui_set_parm_by_name $::gui_parm_list
    ${ame}_parm gui_raise
}
