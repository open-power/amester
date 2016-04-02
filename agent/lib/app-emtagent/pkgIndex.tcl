#
# (C) Copyright IBM Corporation 2011, 2016
#


package ifneeded app-emtagent 5.10 [list emtagentinit::start $dir]

#
#Determine which version of AMESTER to run
#

namespace eval emtagentinit {
    variable debug 0

    variable error 0
    variable msgn 0

    variable emtagent_ver_major 5
    variable emtagent_ver_minor 10
    variable emtagent_ver_year "2007"
    variable emtagent_ver_month "11"
    variable emtagent_ver_day "15"
    variable emtagent_ver_string "${emtagent_ver_major}.${emtagent_ver_minor} ${emtagent_ver_year}-${emtagent_ver_month}-${emtagent_ver_day}"

    variable topdir
}

set ::emtagentinit::uid 0
proc ::emtagentinit::create_uid {} {incr ::emtagentinit::uid}

proc emtagentinit::msg {w msg} {
    if {$::options(gui)} {
	set uid [::amecinit::create_uid]
	toplevel ${w}_${uid}
	message ${w}_${uid}.m -text $msg -relief groove -aspect 300 -width 500 -borderwidth 20 
	pack ${w}_${uid}.m -side top
	focus ${w}_${uid}
	raise ${w}_${uid}
	update
	after 6000 [list destroy ${w}_${uid}]
	tkwait window ${w}_${uid}
    } else {
	puts $msg
    }
}

proc emtagentinit::center {w} {
    set width [winfo reqwidth $w]
    set height [winfo reqheight $w]
    set x [expr {([winfo vrootwidth $w] - $width)/2}]
    set y [expr {([winfo vrootheight $w] - $height)/2}]
    wm geometry $w +${x}+${y}
}

proc emtagentinit::splash {} {
    set msg "
EMT agent ${emtagentinit::emtagent_ver_major}.${emtagentinit::emtagent_ver_minor}
${emtagentinit::emtagent_ver_year}-${emtagentinit::emtagent_ver_month}-${emtagentinit::emtagent_ver_day}


(C) Copyright IBM Corporation 2011, 2016
"
    if {$::options(gui)} {
	set w .splash
	toplevel $w
	wm resizable $w 0 0
	wm overrideredirect $w 1
	#message ${w}.m -text $msg -aspect 300 -width 500 -borderwidth 10 
	label ${w}.m -text $msg -justify left -borderwidth 5 -pady 50 -padx 50 -relief solid -background lightblue
	grid ${w}.m -sticky news
	focus ${w}
	center ${w}
	raise ${w} .
	after 3000 [list destroy ${w}]
	# tkwait window ${w}
    } else {
	puts $msg
    }
}


proc emtagentinit::init {} {
    variable platform $::tcl_platform(platform)
    variable topdir

    if {[info exists starkit::topdir]} {
	set topdir $starkit::topdir
    } else {
	set topdir {}
    }

}

proc emtagentinit::start {dir} {
    set myargs [split [lindex $::argv 0]]
    set ::options(bg) 0
    set ::options(gui) 0
    foreach a $myargs {
	if {$a eq "--bg"} {
	    set ::options(bg) 1 
	    set ::options(gui) 0
	}
	if {$a eq "--nogui"} {
	    set ::options(gui) 0
	}
	if {$a eq "--gui"} {
	    set ::options(gui) 1
	}
    }
    
    #Load Tk only if we show the GUI
    if {$::options(gui)} {
	package require Tk
    }

    if {$::options(gui)} {
	wm iconify .
    }
    emtagentinit::splash
    if {$::options(gui)} {
	wm deiconify .
	#emtagentinit::center .
    }
    

    set rc [emtagentinit::init]
    
    if {! $emtagentinit::error} {
	set file [file join $dir main.tcl]
	namespace eval :: source \"$file\"
    }
}

