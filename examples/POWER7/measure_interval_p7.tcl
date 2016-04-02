#
# (C) Copyright IBM Corporation 2011, 2016
#

#
# measure_interval_p7.tcl
#
# The purpose of this script is to connect to a P7 FSP
# and report the min/max/avg of requested sensors over the run interval.
# The run interval is fixed.
#

#
# Run command: 
#    amester measure_interval_p7.tcl <fsp address> <time in seconds> <output filename>
#    defaults: time = 5 seconds, output goes to stdout
# example: 
#    amester measure_interval_p7.tcl s56a.austin.ibm.com 5 myfile.out
#
# To run with no GUI mode:
#    amester --nogui measure_interval_p7.tcl s56a.austin.ibm.com 5 myfile.out
#

#
# Configuration variables
#


# Sensors to watch. Use "all" if you want every sensor available.
# Otherwise, specify a list of sensor names enclosed in {}
set ::sensor_list all
#set ::sensor_list {PWR1S PWR8S}

# Machine to trace
set ::fsp_address ""

# Default run interval in seconds
set ::run_interval_s 5

# Filename to write output
set ::outfilename "stdout"


#
# Other global variables
#

# File descriptor for output (set by code based on ::outfilename)
set ::outfile ""

# Required AME API level for this script
set ::required_api_major 2
set ::required_api_minor 24

# Help message
set ::help_message "Error parsing command line.\nUse:  amester measure_interval_p7.tcl <fsp address> <time in seconds> <output filename>"



# Parse command line
puts "script_argv = $::script_argv"
switch [llength $::script_argv] {
    1 {
	set ::fsp_address [lindex $::script_argv 0]
    }
    2 {
	set ::fsp_address [lindex $::script_argv 0]
	set ::run_interval_s [lindex $::script_argv 1]
    }
    3 {
	set ::fsp_address [lindex $::script_argv 0]
	set ::run_interval_s [lindex $::script_argv 1]
	set ::outfilename [lindex $::script_argv 2]
    }
    default {
	puts stderr $::help_message
	exit
    }
}

set ::run_interval_ms [expr $::run_interval_s * 1000]

#Setup output
if {$::outfilename ne "" && $::outfilename ne "stdout"} {
    if {[file exists $outfilename]} {
	puts stderr "ERR: file $outfilename exists"
	exit
    }
    #mkdir if necessary
    set ::outfile [open $::outfilename w]
    puts "opening $outfilename"
} else {
    set ::outfile "stdout"
}


# Connect to platform
puts "Connecting to $::fsp_address ..."
netc myfsp -addr $::fsp_address -passwd FipSdev

# Check we have AME
set ::amec [myfsp get amec]

if {$::amec eq ""} {
    puts "ERROR: $::fsp_address does not have TPMD firmware supporting Amester"
    exit_application
}

set api_major [$amec get api_major]
set api_minor [$amec get api_minor]

if {$api_major < $::required_api_major || ($api_major == $::required_api_major && $api_minor < $::required_api_minor)} {
    puts "ERROR: TPMD firmware is AME API ${api_major}.${api_minor}. This script requires AME API 2.24. Please update the TPMD firmware."
}



#turn on all sensors, if requested
if {$::sensor_list eq "all"} {
    set allsensorobjs [myfsp_ame0 get sensors]
    foreach s $allsensorobjs {
	lappend allsensornames [$s cget -sensorname]
    }
    set ::sensor_list [lsort -ascii $allsensornames]
}

# This list holds all the sensor objects for data gathering
set ::sensor_obj_list [$amec get sensorname $::sensor_list]

# Clear min/max of all sensors
$amec clear_minmax_all_sync

puts "Reading initial accumulator for each sensor..."
# Read all sensors once
$amec sensor_update_by_object_sync $::sensor_obj_list
# Record accumulators at begeinning of interval
foreach s $::sensor_obj_list {
    set ::acc_begin($s) [$s cget -value_acc]
    set ::update_begin($s) [$s cget -updates]
}


puts "Starting data collection for $::run_interval_s seconds."

# This after command pauses execution for the desired interval
after $::run_interval_ms

puts "Interval is over"
puts "Reading final accumulator and dumping data..."

# Update all the sensors again.  (Get the final accumulator, min, max)
$amec sensor_update_by_object_sync $::sensor_obj_list

#Print column titles
puts $::outfile "sensor,units,min,max,avg,updates,accdiff,accdiff_fix,frequency(Hz)"
#Print each row
foreach s $::sensor_obj_list {
    set name [$s cget -sensorname]
    set value [$s cget -value]
    set units [$s cget -u_value]
    set min [$s cget -min]
    set max [$s cget -max]
    # Scalefactor
    set sf [$s cget -scalefactor]
    # Frequency of update in Hz
    set freq [$s cget -freq]
    set ::acc_end($s) [$s cget -value_acc]
    set ::update_end($s) [$s cget -updates]

    #calculate average
    set updates [expr $::update_end($s) - $::update_begin($s)]
    set accdiff [expr $::acc_end($s) - $::acc_begin($s)]
    #correct accdiff for wrap-around of 32-bit accumulator in AME firmware
    set accdiff_fix [expr (round($accdiff / $sf) & 0x0ffffffff) * $sf]

    if {$updates > 0} {
	set avg [expr double($accdiff_fix)/$updates]
    } else {
	# Avoid divide by 0 when sensor does not update in desired interval.
	# Print the sensor value as the average
	set avg $value
    }

    puts $::outfile "$name,$units,$min,$max,$avg,$updates,$accdiff,$accdiff_fix,$freq"
}


# Flush file output
flush $::outfile
if {$::outfile ne "stdout" && $::outfile ne "stderr"} {
    close $::outfile
}

puts "Done"
exit
