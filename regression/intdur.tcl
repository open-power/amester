#
# (C) Copyright IBM Corporation 2011, 2016
#

#
# Trace the AME ISR to find max AMEintdur sensor value and
# find the states in the state machine that causes it.
# For POWER7 TPMD.
#
# Requires AME API 2.23 (5/29/09) or greater 

package require job


#
# Globals
#
debugSet tb 1
debugSet trace 1

set ::fsp_address s56a.austin.ibm.com
set ::fsp_passwd FipSdev
set ::partition_address s56d.austin.ibm.com
set ::partition_userid root

set ::command "ls"


# Set where the output goes.
set ::filename1ms "intdur.csv"
set ::job_output_filename "myjobout.txt"

# Set the sensors/scoms to view

# Valid sockets on a 4 socket system are {0 1 2 3}
set ::socket_list {0}
# The sensor list has pairs of sensor name and field.
# Valid fields are value,min,max,acc,updates,test,rcnt
# rcnt is a 1ms timer in the TPMD.
set ::sensor_list_1ms {{AMEintdur rcnt} {AMEintdur value} } 
#Parameter list
set ::parm_list_1ms {rcnt smcnt fm32scnt fm64scnt fm642scnt fm256scnt fm256thcnt empfm32scnt} 

# List of SCOM addresses to gather. (read 2 and write 1)
set ::scom_list {}


#
# Helper functions
#

proc my_stop {{job {}}} {
    #stop recording
    myfsp_ame0 trace_stop

    if {$job ne {}} {
	set jobresults [$job cget -output]

	if {[catch {set file [open $::job_output_filename w]}]} {
	    puts stderr "Cannot open file $::job_output_filename"
	    return
	}

	puts $file $jobresults
	close $file
    }
    

    puts "dumping..."
    #Turn on debugging output for tracebuffer to see something is happening
    debugSet tb 1
    my_dump myfsp_ame0_trace1ms $::filename1ms $::sensor_list_1ms $::parm_list_1ms {} {}
    #Turn off debugging output for tracebuffer
    debugSet tb 0
    puts "done"

    # The following line tells Amester to explicitly quit when --nogui 
    # commandline option is used.
    # Otherwise, it keeps running because it uses an event-loop style program.
    if {!$::options(gui)} {exit_application}

}

# Write tracebuffer to a comma-separated-value file
proc my_dump {tb filename sensors parms scoms sockets} {
    #
    # Open file
    #
    if {[catch {set file [open $filename w]}]} {
	puts stderr "Cannot open file $filename"
	return
    }

    #
    # Print a header line
    #
    set head {}
    foreach s $sensors {
	foreach {name field} $s {
	    lappend head "${name}_${field}"
	}
    }

    foreach s $parms {
	lappend head $s
    }


    foreach s $scoms {
	foreach sock $sockets {
	    lappend head "${s}_#${sock}"
	}
    }

    puts $file [join $head ","]

    #
    # Dump the data
    #
    set entries [$tb get_all_entries]
    foreach e $entries {
	puts $file [join $e ","]
    }
    close $file
}


#
# Main
#


# Connect to fsp
netc myfsp -addr $::fsp_address -passwd $::fsp_passwd

debugSet ipmi 1
# Configure and start recording in the trace buffer
puts "configuring..."
myfsp_ame0_trace1ms set_config $sensor_list_1ms $parm_list_1ms {}
puts "recording..."
myfsp_ame0 trace_start

###########################################
# Choose one of the following methods.
# By default, we use method 1.
##########################################

#
# Method 1: Record for fixed amount of time.
# For example, 3000 ms.
#
after 3000
my_stop


#
# Method 2: Record during a workload run.
# This method assumes you have passwordless ssh setup.
#
# Make a job
# job_ssh myjob $::partition_address $::command -userid $::partition_userid
#
# What do to when job is over
# myjob add_isdone_callback my_stop
#
# Start running the job
# myjob run
#
# When job is done, my_stop is triggered to stop recording


