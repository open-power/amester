#
# (C) Copyright IBM Corporation 2011, 2016
#

# blower.tcl: An AMEster example configuration file
#   Shows how to read a few sensors from a few blades, inlcuding bladecenter  
#   the fan speeds.  Results are dumped eitehr to stdout or to a tracefile.  
#   The format of the results is Comma-Separated Values, which is suitable for
#   opening by any spreadsheet application. 
#
# Notes: 
#   All variables intended for user configuration are tagged with 
#   an "OPTION" comment.
#


# OPTION: If you want the ::amesterdebug::debug window, uncomment the next line
#::amesterdebug::window

# OPTION: To see debugging output from various AMEster subsytems, uncomment 
# some of the following lines
#::amesterdebug::set options 1
#::amesterdebug::set network 1
#::amesterdebug::set ame 1
#::amesterdebug::set sensor 1
#::amesterdebug::set gui 1
#::amesterdebug::set budget 1
#::amesterdebug::set power 1
#::amesterdebug::set scope 1
#::amesterdebug::set ta 1
#::amesterdebug::set bc 1
#::amesterdebug::set health 1
#::amesterdebug::set login 1
#::amesterdebug::set histogram 1

# OPTION: To send ::amesterdebug::debug output to a file, uncomment the following lines.
# set ::thedebugfile [open "mydebugfile" w]
# ::amesterdebug::output $::thedebugfile


# OPTION: If you want to only use some of the blades in your chassis,
# modify the next line to list the slot numbers that you care about
# Comment the line to pick up all blades in the ip() list below 
#set ::slotmask [list 1 2 3 4 5 6 7 8 9 10 11 12 13 14]

# OPTION: In some cases, you will need to modify the following lines so that 
# AMEster will know the IP address of each blade. Go ahead and do it now. 
# Uncomment each line that corresponds to a slot that has a blade and update the IP address.
# For blades that take 2 or more slots, use the lowest slot number and do not uncomment the other slots.
 set ::ip(1)  9.3.61.214
#set ::ip(2)  9.3.61.215
#set ::ip(3)  9.3.61.216
#set ::ip(4)  9.3.61.205
#set ::ip(5)  --
#set ::ip(6)  9.3.61.202
#set ::ip(7)  9.3.61.206
#set ::ip(8)  9.3.61.203
#set ::ip(9)  9.3.61.208
#set ::ip(10) 9.3.61.209
 set ::ip(11) 9.3.61.210
#set ::ip(12) 9.3.61.211
#set ::ip(13) 9.3.61.212
#set ::ip(14) 9.3.61.213

proc timestamp {} { return [clock format [clock seconds] -format %H:%M:%S] }

# If no slotmask is set, create a complete slotmask
if {![info exists ::slotmask]} {
	set ::slotmask [array names ip]
}

# OPTION:  Modify the IP address in the next line to be the address of your 
# MM. Also change the user ID and password if you actually care about 
# security (this is the same account you use to log in to the MM Web 
# interface).
puts "[timestamp] Creating mybc..."
bc mybc -addr 9.3.61.9 -userid USERID -password PASSW0RD -port 6090 -slotmask $slotmask
puts "[timestamp] mybc is created."

# This code informs AMEster of the IP address for each slot
set bladelist [mybc get blades]
foreach blade $bladelist {
	set slot [$blade cget -slot]
	$blade configure -addr $::ip($slot)
}

# End of boilerplate code. Add your own Tcl code below to do whatever you want.

# Send a request to get the fan speed
# (Based on bc_fan and bc_fan_rcv from Amester 4.2)
proc get_fan {bcname fan {callback {}}} {
	set type 2
	set cmd [list 2 3 $fan]
	set databytes {}
	if {$callback eq {}} {
		set callback "get_fan_callback $bcname $fan \$status \$databytes"
	}
	$bcname send $type $cmd $databytes $callback $::priority_data
}

# Receive a response to a fan speed request and update a global variable
proc get_fan_callback {name fan status databytes} {
	if {[binary scan $databytes "c" speedpcnt]} {
		set ::fan($name,$fan) $speedpcnt
	} else {
		return -code error
	}
}

# Periodically send requests for fan speed to the given blade center; 
# once it is called, it runs every every $interval ms forever.
proc monitor_fan_speed {name interval} {
	# Get data for each fan
	get_fan $name 1
	get_fan $name 2
	
	# Pause for a while and run this function again
	after $interval [list monitor_fan_speed $name $interval]
}

#Initialize global fan variables
set ::fan(mybc,1) 0
set ::fan(mybc,2) 0

# OPTION: You can set the interval of fan monitoring in milliseconds by 
# changing the second argument (default is 5000 ms = 5 s)
monitor_fan_speed mybc 5000

# OPTION: The list of sensors to watch for each blade
set ::my_sensor_list {pwr1ms pwr1s tempCPU0}

# OPTION: Defines our trace file, which is in Comma-Separated Values format, 
# suitable for opening in any spreadsheet.
#   Set to "stdout" to emit to standard out
#   Set to a filename to append to that file 
set ::tracefile stdout
#set ::tracefile "stats.csv"

# If a file was given, open it, else point the handle at stdout 
if {$::tracefile != "stdout"} {
	set ::tracefp [open "stats.csv" "a"]
} else {
	set ::tracefp stdout
}

# Tell each blade's amec which sensors to monitor (from $my_sensor_list)
set bladelist [mybc get blades]
foreach blade $bladelist {
	set amec [$blade get amec]
	$amec set_sensor_list $::my_sensor_list
}

puts "[timestamp] About to begin tracing..."

# Make allsensors, a list of all sensor objects across the cluster
foreach blade $bladelist {
	set amec [$blade get amec]
	
	#get a list of sensorobjs for this blade
	set sensorobjs [$amec get sensorname $::my_sensor_list]
	
	#add each sensor to my global variable of all sensors I want
	foreach s $sensorobjs {
		lappend ::allsensors $s
	}
}

# Emit header
puts -nonewline $::tracefp "Time ([timestamp]),"
# Emit sensor names (with those two colons trimmed off)
foreach s $::allsensors {
	set shortName [regsub "^::" $s ""]
	puts -nonewline $::tracefp "$shortName,"
}
puts $::tracefp "Fan1,Fan2"
flush $::tracefp

# Set the callback for all sensor data updates
set ::new_data_callback my_data_callback

puts "[timestamp] Trace started, output going to $::tracefile"

proc my_data_callback {sensorobj} {

	# Only print results after all sensors have updated.  Since
	# sensors are all queued waiting to be updated, we can just wait
	# for a particular one to update and know that all of the others
	# have also been updated.
	#
	# Therefore, if this isn't the very first sensor, skip this update
	if {$sensorobj != [lindex $::allsensors 0]} {return}
	
	puts -nonewline $::tracefp "[timestamp],"
	
	# emit readings 
	foreach s $::allsensors {
		puts -nonewline  $::tracefp "[$s cget -value],"
	}
	
	# emit fan info
	puts $::tracefp "$::fan(mybc,1),$::fan(mybc,2)"
	
	flush $::tracefp
}

