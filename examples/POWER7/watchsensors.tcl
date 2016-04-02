#
# (C) Copyright IBM Corporation 2011, 2016
#

# watchsensors.tcl: An example script
#   Shows how to read a few sensors from a single (POWER) system.
#   Results are dumped either to stdout or to a file.  
#   The format of the results is Comma-Separated Values, which is suitable for
#   opening by any spreadsheet application. 
#
# Notes: 
#   All variables intended for user configuration are tagged with 
#   an "OPTION" comment.
#

#
# OPTION: Modify these constants for your system
#
# Set fspaddr to the IP address of the FSP of the POWER server.
set ::fspaddr arlz181.austin.ibm.com
# Set my_sensor_list to list of sensors to watch for the system
set ::my_sensor_list {PWR1MS PWR1S}
# tracefile is the output file, in Comma-Separated Values format, 
# suitable for opening in any spreadsheet.
#   Set to "stdout" to emit to standard out
#   Set to a filename to append to that file 
set ::tracefile stdout
#set ::tracefile "stats.csv"

# Connect to the POWER server
puts "Connecting to $::fspaddr ..."
netc myfsp -addr $::fspaddr -passwd FipSdev
puts "myfsp is created."
puts "About to begin tracing..."

# If a file was given, open it, else point the handle at stdout 
if {$::tracefile ne "stdout"} {
    set ::tracefp [open $::tracefile "a"]
} else {
    set ::tracefp stdout
}

# Tell AME object to monitor the desired sensors.
set ::amec [myfsp get amec]
if {$::amec eq ""} {
    puts "ERROR: $::fspaddr does not have TPMD firmware supporting Amester"
    exit_application
}
$::amec set_sensor_list $::my_sensor_list

# Make allsensors, a list of all sensor objects
set ::allsensors [$::amec get sensorname $::my_sensor_list]

# Emit header
puts -nonewline $::tracefp "Time (ms),"
# Emit sensor names (with those two colons trimmed off)
foreach s $::allsensors {
	set shortName [regsub "^::" $s ""]
	puts -nonewline $::tracefp "$shortName,"
}
puts $::tracefp ""
flush $::tracefp

set ::starttime [clock clicks -milliseconds]
proc timestamp {} { return [expr [clock clicks -milliseconds] - $::starttime]}

# Set the callback for all sensor data updates
set ::new_data_callback my_data_callback

set ::firstread 1

proc my_data_callback {sensorobj} {

    # Only print results after all sensors have updated.  Since
    # sensors are all queued waiting to be updated, we can just wait
    # for a particular one to update and know that all of the others
    # have also been updated.
    #
    # Therefore, if this isn't the very first sensor, skip this update
    if {$sensorobj != [lindex $::allsensors 0]} {return}
    # Ignore first round of sensor updates (want all values to be updated before dump)
    if {$::firstread} {
	set ::firstread 0
	return
    }
    
    puts -nonewline $::tracefp "[timestamp],"
    
    # emit readings 
    foreach s $::allsensors {
	puts -nonewline  $::tracefp "[$s cget -value],"
    }
    puts $::tracefp ""
    
    flush $::tracefp
}

