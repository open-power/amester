#
# (C) Copyright IBM Corporation 2011, 2016
#

#--------------------------------------------------------------------
#
# Console window
#
# The console window uses the array command()
# to hold all state.
# command(line) is the command
# command(history) is the array of previous commands
# command(index) points into the history array
# command(count) is the command number
#
# We replicate some of the Tcl history commands because
# they do not appear to work inside starpacks (dqkit)
#
# The console is in the window .cmdline
#
#--------------------------------------------------------------------

package provide commandline 1.0

package require Tk

namespace eval ::commandline:: {

    variable command

    # Command history always holds a blank command at the beginning
    # so that commands are 1..N, like tcl history.
    # There is also a blank command at position N (the current one)
    set command(count) 0
    set command(index) 1
    set command(history) [list "" ""]
    set command(line) ""

    namespace export commandline
}

proc ::commandline::commandline_history {} {
    variable command
    # set count to first element
    set count [expr $command(count) - [llength $command(history)] + 3]
    # don't show first or last dummy elements
    set l [expr [llength $command(history)] - 1]
    for {set i 1} {$i < $l} {incr i} {
	puts [format "%5i %s" $count [lindex $command(history) $i]]
	incr count
    }
}

# Up-arrow
proc ::commandline::commandline_up {} {
    variable command
    incr command(index) -1
    if {$command(index) == 0} {
	#we moved beyond the end of list. move back
	incr command(index)
    } else {
	#only set the command line if we moved the index
	set command(line) [lindex $command(history) $command(index)]
	.cmdline.f2.entry icursor end
    }
}

# Down-arrow
proc ::commandline::commandline_down {} {
    variable command
    incr command(index)
    if {$command(index) == [llength $command(history)]} {
	#we moved beyond the end of list. move back
	incr command(index) -1
    } else {
	#only set the command line if we moved the index
	set command(line) [lindex $command(history) $command(index)]
	.cmdline.f2.entry icursor end
    }
}

#
# Trap puts for console. Non-console puts pass thru to Tcl ::puts
#
# Tcl puts is defined: puts ?-nonewline? ?channelID? string
#
proc ::commandline::commandline_puts {args} {

    # defaults
    set err 0
    set nonewline 0
    set stream stdout

    set myargs $args

    if [string match "-nonewline" [lindex $args 0]] {
	set nonewline 1
	set myargs [lreplace $myargs 0 0]
    }
    
    switch -- [llength $myargs] {
	1 {set string [lindex $myargs 0]}
	2 {
	    set stream [lindex $myargs 0]
	    set string [lindex $myargs 1]
	}
	default {set err 1}
    }

    #Copy output to console window, if stdout or stderr
    switch -- $stream {
	stdout {}
	stderr {}
	default {set err 1}
    }

    #Write console window, if no errors
    if {!$err} {
	if {$nonewline} {
	    .cmdline.text insert end "$string"
	} else {
	    .cmdline.text insert end "$string\n"
	}
    } else {
	# err=1 means do not write to console
    }
    
    # Always pass-thru to ::puts and return its results
    if [catch "commandline_puts_original $args" result] {
	commandline_puts_original $result
	return -code error $result
    }
    return $result
}

# Clip command window to last 1000 lines
proc ::commandline::commandline_clip {} {
    .cmdline.text mark set start {end - 1000 lines}
    .cmdline.text delete 1.0 start
}

# Evaluate a command in global command(line) variable
proc ::commandline::commandline_process {} {
    variable command

    if {[info complete $command(line)]} {

	if {$command(line) eq "!!"} {
	    set command(line) [lindex $command(history) end-1]
	    commandline_process
	    return
	}
	
	set command(history) [linsert $command(history) end-1 $command(line)]
	incr command(count)
	if {[llength $command(history)] > 102} {
	    set command(history) [lreplace $command(history) 1 1]
	}
	set command(index) [expr [llength $command(history)] - 1]

	.cmdline.text insert end "$command(line)\n" cmd
	set code [catch {uplevel \#0 $command(line)} result]
	if {$result ne ""} {
	    .cmdline.text insert end "$result\n"
	}
	.cmdline.text yview moveto 1.0
	commandline_clip

	set command(line) {}
    }
}


proc ::commandline::commandline {} {
    variable command

    set winname ".cmdline"

    # if window exists, raise it
    if {[winfo exists $winname]} {
	wm state $winname normal
	focus $winname
	raise $winname
	return
    }
    
    toplevel $winname
    wm title $winname "Command line"
    wm withdraw $winname

    frame .cmdline.f1
    text .cmdline.text -wrap word -yscrollcommand [list .cmdline.yscroll set] -width 80 -height 10
    scrollbar .cmdline.yscroll -orient vertical -command [list .cmdline.text yview]
    frame .cmdline.f2
    entry .cmdline.f2.entry -textvariable ::commandline::command(line) -relief sunken
    label .cmdline.f2.l -text "Enter command:"
    grid .cmdline.f2.l .cmdline.f2.entry -sticky news
    bind .cmdline.f2.entry <Return> ::commandline::commandline_process
    bind .cmdline.f2.entry <KeyPress-Up> ::commandline::commandline_up
    bind .cmdline.f2.entry <KeyPress-Down> ::commandline::commandline_down

    grid .cmdline.text .cmdline.yscroll -sticky news
    grid .cmdline.f2 -sticky news
    grid rowconfigure .cmdline 0 -weight 1
    grid columnconfigure .cmdline 0 -weight 1

    grid columnconfigure .cmdline.f2 1 -weight 1
    
    .cmdline.text tag configure cmd -foreground blue
}

# Do this only if you want to copy stdout/stderr to console window
rename ::puts ::commandline::commandline_puts_original
interp alias {} ::puts {} ::commandline::commandline_puts

# Do this only to make "history" work in dqkit starpacks
#rename ::history ::commandline_history_original
interp alias {} ::history {} ::commandline::commandline_history

# Initialize commandline, but do not show it until run again.
::commandline::commandline
 
