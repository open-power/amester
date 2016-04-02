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

package provide amesterdebug 1.0

if {$::options(gui)} {
    package require Tk
}

namespace eval ::amesterdebug:: {

    variable pred
    variable debugsock

    array set pred {1 1 0 0}
    ::set debugsock stdout

    namespace export output
    namespace export window
    namespace export set
    namespace export debug

}

proc ::amesterdebug::output {{sock ""}} {
    variable debugsock
    if {$sock ne ""} {
	::set debugsock $sock
    }
    return $debugsock
}

proc ::amesterdebug::set {name {value ""}} {
    variable pred
    if {$value ne ""} {
	::set pred($name) $value
	return $value
    } elseif { [info exists pred($name)] } {
	return $pred($name)
    } else {
	return 0
    }
}

proc ::amesterdebug::windowUpdate {} {
    .debugwindow.text mark set start {end - 1000 lines}
    .debugwindow.text delete 1.0 start
}

proc ::amesterdebug::window {} {
    if {!$::options(gui)} {return}

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

proc ::amesterdebug::debug {t m} {
    variable pred
    variable debugsock
    if {[info exists pred($t)] && $pred($t)} {
	if {$::options(gui) == 1} {
	    catch {
		#.debugwindow.text may not exist
		.debugwindow.text insert end "$m\n"
		.debugwindow.text yview moveto 1.0	
		windowUpdate
	    } result
	}
	if {$debugsock ne ""} {puts $debugsock "$m"}
    }
}

proc ::amesterdebug::nothing {args} {}

if {$::options(gui)} {
    #Startup the debugwindow, but don't show it
    ::amesterdebug::window
} else {
    #Make all debug commands do nothing
    interp alias {} ::amesterdebug::window {} ::amesterdebug::nothing
    #interp alias {} ::amesterdebug::debug {} ::amesterdebug::nothing
}
