#
# (C) Copyright IBM Corporation 2011, 2016
#

package ifneeded app-amester 7.0 [list amesterinit::start $dir]

namespace eval amesterinit {
    variable error 0
    variable msgn 0

    variable amester_ver_major 7
    variable amester_ver_minor 1
    variable amester_ver_year "2017"
    variable amester_ver_month "8"
    variable amester_ver_day "29"
    variable amester_ver_string "${amester_ver_major}.${amester_ver_minor} ${amester_ver_year}-${amester_ver_month}-${amester_ver_day}"

    variable topdir
    variable toolname "Automated Measurement of Systems for Temperature and Energy Reporting"
}

set ::amesterinit::uid 0
proc ::amesterinit::create_uid {} {incr ::amesterinit::uid}

proc amesterinit::msg {w msg} {
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

proc amesterinit::center {w} {
    set width [winfo reqwidth $w]
    set height [winfo reqheight $w]
    set x [expr {([winfo vrootwidth $w] - $width)/2}]
    set y [expr {([winfo vrootheight $w] - $height)/2}]
    wm geometry $w +${x}+${y}
}

proc amesterinit::splash {} {
    set msg "
$::amesterinit::toolname
Version $amesterinit::amester_ver_string

Sheldon Bailey <baileysh@us.ibm.com>

(C) Copyright IBM Corporation 2011, 2017
"
    if {$::options(gui)} {
	set w .splash
	toplevel $w
	wm resizable $w 0 0
	wm overrideredirect $w 1
	label ${w}.m -text $msg -justify left -borderwidth 5 -pady 50 -padx 50 -relief solid -background lightblue
	grid ${w}.m -sticky news
	focus ${w}
	center ${w}
	raise ${w} .
	after 3000 [list destroy ${w}]
    } else {
	puts $msg
    }
}


proc amesterinit::init {} {
    variable platform $::tcl_platform(platform)
    variable topdir

    if {[info exists starkit::topdir]} {
	set topdir $starkit::topdir
    } else {
	set topdir {}
    }
}

proc amesterinit::start {dir} {
    set myargs [split [lindex $::argv 0]]
    set ::options(gui) 1
    foreach a $myargs {
	if {$a eq "--nogui"} {
	    set ::options(gui) 0
	}
    }

    #Load Tk only if we show the GUI
    if {$::options(gui)} {
	if {[catch {package require Tk} errMsg errOpt]} {
	    puts "Error: Tk package could not be loaded."
	    if {$::errorCode eq "TK DISPLAY CONNECT"} {
		puts "       Please check the DISPLAY environment variable is valid."
	    }
	    puts "       Use \'--nogui' AMESTER command line option to run without a graphical interface."
	    return -options $errOpt $errMsg
	}
	wm iconify .
    }

    amesterinit::splash

    if {$::options(gui)} {
	wm deiconify .
    }

    amesterinit::init

    if {! $amesterinit::error} {
	set file [file join $dir amester.tcl]
	set amester "{ $file }"
	namespace eval :: source \"$file\"
    }
}
