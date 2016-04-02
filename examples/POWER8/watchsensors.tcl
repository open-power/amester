#
# (C) Copyright IBM Corporation 2011, 2016
#

# Example AMESTER script for tracing sensors and parameters.  Prints
# to CVS file or console (stdout).  If IPMI error is encountered while
# reading parameters then re-try up to 5 times before printing "#N/A"

#
# Important globals. Change for your environment.
#


# Number of milliseconds to pause between printing lines
set ::interval 0

# Sensors to trace
#Use "all" if you want to trace all sensors
#set ::my_sensor_list "all"
set ::my_sensor_list {
    FREQA2MSP0
    IPS2MSP0
    PWR250US
    TEMP2MSP0
    VOLT250USP0V0
}

# Parameters to trace
set ::my_parm_list {
    freq_reason
}

if {[llength $::script_argv] < 4} {
    puts "usage:  amester --nogui watchsensors.tcl <bmc ip addr> <bmc user> <bmc pw> <output filename | stdout>"
    exit 0;
} else {
    set ::bmcaddr [lindex $::script_argv 0]
    set ::bmcusr [lindex $::script_argv 1]
    set ::bmcpw [lindex $::script_argv 2]
    set ::tracefile [lindex $::script_argv 3]
}


set ::firstread "true"

# Connect to the POWER server
puts "Connecting to $::bmcaddr ..."
openpower mysys -addr $::bmcaddr -ipmi_user $::bmcusr -ipmi_passwd $::bmcpw
#localhost mysys

# Either set the AMEC to trace manually, or trace all.
#set ::theameclist "mysys_node0_ame0"
set ::theameclist [mysys get ameclist]
if {$::theameclist eq ""} {
    puts "ERROR: $::bmcaddr does not have firmware supporting Amester"
    exit_application
}

puts "About to begin tracing..."

# If a file was given, open it, else point the handle at stdout
if {$::tracefile ne "stdout"} {
    set ::tracefp [open $::tracefile "a"]
} else {
    set ::tracefp stdout
}

set ::api_major [mysys_node0_ame0 get api_major]
set ::api_minor [mysys_node0_ame0 get api_minor]
puts "Detected FW level: [mysys_node0_ame0 get ame_version] [mysys_node0_ame0 get ame_date]"
puts "API level: ${::api_major}.${::api_minor}"

#Select parameter access method
set ::read_and_print_parameters_proc {}
if {($::api_major > 2) || 
    (($::api_major==2) && ($::api_minor>=28))} {
    #API >= 2.28
    set ::read_and_print_parameters_proc read_and_print_parameters_2_28
} else {
    set ::read_and_print_parameters_proc read_and_print_parameters_2_25
}
#puts "Using parameter access method: $::read_and_print_parameters_proc"

#Set write buffer size to be 500000 bytes so the AmesterPoller will read full lines.
fconfigure $::tracefp -buffersize 500000

# Tell AME object to monitor the desired sensors.
if {$::theameclist eq ""} {
    puts "ERROR: $::fspaddr does not have TPMD firmware supporting Amester"
    exit_application
}

set ::allsensors {}
set ::allparms {}
foreach amec $::theameclist {
    if {$::my_sensor_list eq "all"} {
	set allsensorobjs [$amec get sensors]
	set allsensornames {}
	foreach s $allsensorobjs {
	    lappend allsensornames [$s cget -sensorname]
	}
	set ::my_sensor_list [lsort -ascii $allsensornames]
    }
    $amec set_sensor_list $::my_sensor_list
    # Make allsensors, a list of all sensor objects
    set ::allsensors [concat $::allsensors [$amec get sensorname $::my_sensor_list]]
    set ::allparms [concat $::allparms [${amec}_parm get parmname $::my_parm_list]]
}

# Print header
puts -nonewline $::tracefp "AMESTER Date,AMESTER Time,"
foreach s $::allsensors {
    set shortName [regsub "^::" $s ""]
    puts -nonewline $::tracefp "$shortName,"
}
foreach s $::allsensors {
    set shortName [regsub "^::" $s ""]
    puts -nonewline $::tracefp "$shortName acc,"
    puts -nonewline $::tracefp "$shortName updates,"
}
foreach s $::allparms {
    puts -nonewline $::tracefp "[$s cget -objname],"
}
puts $::tracefp ""
flush $::tracefp
set ::starttime [clock clicks -milliseconds]
proc timestamp {} { return [clock format [clock seconds] -format "%D,%T"]}
# Set the callback for all sensor data updates
set ::new_data_callback my_data_callback

#Read and print parameters comma delimited
#Use old API which reads parameters one at a time
proc read_and_print_parameters_2_25 {} {
    foreach p $::allparms {
        
        set _pass 0
        set _attempts 1
        while {$_attempts <= 5} {
            if {[catch {$p read} _result]} {
                #error
                puts "FAIL: Attempt ${_attempts} to read $p. result=$_result"
                incr _attempts
            } else {
                #OK
                set _pass 1
                break
            }
        }
        if {$_pass == 1} {
            #Print the cached value of the parameter, since we just updated it.
            puts -nonewline $::tracefp "[$p cget -value],"
        } else {
            puts -nonewline $::tracefp "#N/A,"
        }
        
    }
}

#Return all parameters comma delimited
#Use new API using bulk read of parameters
proc read_and_print_parameters_2_28 {} {
    #parameters: gather for each ame interface
    foreach amec $::theameclist {
        set _pass 0
        set _attempts 1
        while {$_attempts <= 5} {
            if {[catch {set _values [${amec}_parm read_by_name_sync $::my_parm_list]} _result]} {
                #error
                puts "FAIL: Attempt ${_attempts} to read ${amec} parameters. result=$_result"
                incr _attempts
                set _values {}
            } else {
                #OK
                set _pass 1
                break
            }
        }
        if {$_pass == 1} {
            #Print the cached value of the parameter, since we just updated it.
            puts -nonewline $::tracefp "[join $_values ","],"
        } else {
            foreach i $::my_parm_list {
                puts -nonewline $::tracefp "#N/A,"
            }
        }
        
    }
}

proc my_data_callback {sensorobj} {
    # Only print results after all sensors have updated.  Since
    # sensors are all queued waiting to be updated, we can just wait
    # for a particular one to update and know that all of the others
    # have also been updated.
    #
    # Therefore, if this isn't the very last sensor, skip this update
    if {$sensorobj != [lindex $::allsensors end]} {return}
    # emit readings
    if {$::firstread eq "false"} { 
	puts -nonewline $::tracefp "[timestamp],"
	foreach s $::allsensors {
	    puts -nonewline  $::tracefp "[$s cget -value],"
	}
        #Print the accumulator values for each sensor and the number
        #of internal updates. Use for precise averages over any time
        #period.
	foreach s $::allsensors {
	    puts -nonewline  $::tracefp "[$s cget -value_acc],"
	    puts -nonewline  $::tracefp "[$s cget -updates],"
	}

        #Call procedure pointer to read and print parameters
        #for this AME API version
        $::read_and_print_parameters_proc

	puts $::tracefp ""
	flush $::tracefp
    }  else { 
	set ::firstread "false" 
    } 
    # Pause before printing next line
    after $::interval
}
