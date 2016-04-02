#
# (C) Copyright IBM Corporation 2011, 2016
#

#--------------------------------------------------------------------
#
# Debug window
#
# Use like:
#
# debugWindow  # show the debug window
# debugSet network 1  # turn on network errors 
# debug network "This is a network error"  # post a network error
#
#--------------------------------------------------------------------

package provide debug 1.0

if {$::options(gui)} {
    package require Tk
}

namespace eval ::debug:: {

    variable pred
    variable debugsock

    array set pred {1 1 0 0}
    set debugsock ""

    namespace export debugOutput
    namespace export debugWindow
    namespace export debugSet
    namespace export debug

}

proc ::debug::debugOutput {{sock ""}} {
    variable debugsock
    if {$sock ne ""} {
	set debugsock $sock
    }
    return $debugsock
}

proc ::debug::debugSet {name {value}} {
    variable pred
    if {$value ne ""} {
	set pred($name) $value
    } elseif { [exists variable pred($name)] } {
	return $pred($name)
    }
    return $value
}

proc ::debug::debugWindowUpdate {} {
    .debugwindow.text mark set start {end - 1000 lines}
    .debugwindow.text delete 1.0 start
}

proc ::debug::debugWindow {} {
    if {[winfo exists .debugwindow]} {
	wm state .debugwindow normal
	focus .debugwindow
	raise .debugwindow
    } else {
	toplevel .debugwindow
	wm withdraw .debugwindow
	text .debugwindow.text -wrap word -yscrollcommand [list .debugwindow.yscroll set] -width 100 -height 15
	scrollbar .debugwindow.yscroll -orient vertical -command [list .debugwindow.text yview]

	grid .debugwindow.text .debugwindow.yscroll -sticky news
	grid rowconfigure .debugwindow 0 -weight 1
	grid columnconfigure .debugwindow 0 -weight 1
    }
}

proc ::debug::debug {t m} {
    variable pred
    variable debugsock
    if {[winfo exists .debugwindow] && [info exists pred($t)] && $pred($t)} {
	.debugwindow.text insert end "$m\n"
	.debugwindow.text yview moveto 1.0	
	debugWindowUpdate
	if {$debugsock ne ""} {puts $debugsock "$m"}
    }
}

proc ::debug::nothing {args} {}

if {$::options(gui)} {
    #Startup the debugwindow, but don't show it
    ::debug::debugWindow
} else {
    #Make all debug commands do nothing
    interp alias {} ::debug::debugWindow {} ::debug::nothing
    interp alias {} ::debug::debug {} ::debug::nothing
}
