#
# (C) Copyright IBM Corporation 2011, 2016
#

package provide app-amester 7.0


#--------------------------------------------------------------------
#
# Organization of code
#
#--------------------------------------------------------------------

# Important global variables

# tsv:: thread - contains thread IDs for the GUI and IPMI threads
# topdir = top directory for finding files need by this program


#--------------------------------------------------------------------
#
# Packages
#
#--------------------------------------------------------------------

package require Itcl
namespace import itcl::*

package require Thread
#catch {wm withdraw .}
if {$::options(gui)} {

    package require Tk

    #Required for sensor objects (vector)
    #NOTE: we only use vectors for GUI mode, since inclusion of rbc
    #triggers loading of Tk
    package require rbc
    namespace import rbc::*

    package require commandline
    namespace import commandline::commandline
    package require multiselect
    namespace import multiselect::multiselect
}


package require http

set result [package require amesterdebug]
#namespace import debug::*

set result [package require data]
#puts "require data: $result"

#For signal handling
package require Tclx


#--------------------------------------------------------------------
#
# Global data
#
#--------------------------------------------------------------------

if {[info exists starkit::topdir]} {
    set topdir $starkit::topdir
} else {
    set topdir {}
}

set legendfont { -size 12}
set axisfont { -size 14}
set tickfont { -size 12}
set markerfont { -size 10}
set graphtitlefont { -size 12}
set fixedfont {-family courier -size 14}
set fixedfontbold {-family courier -size 14 -weight bold}
set valuelabelwidth 10

set valuenumwidth 9
set legendpadx 0
set legendpady 0
set legendipadx 0
set legendipady 0
set legendanchor nw
set plotpadx 0
set plotpady 1

tsv::set shared topdir $topdir

# Turn these on in your script, if possible
::amesterdebug::set warn 0
::amesterdebug::set options 0
::amesterdebug::set network 0
::amesterdebug::set bgerror 1
::amesterdebug::set ame 0
::amesterdebug::set sensor 0
::amesterdebug::set gui 0
::amesterdebug::set budget 0
::amesterdebug::set power 0
::amesterdebug::set scope 0
::amesterdebug::set ta 0
::amesterdebug::set bc 0
::amesterdebug::set health 0
::amesterdebug::set login 0
::amesterdebug::set histogram 0
::amesterdebug::output stdout
set ::options(gui) 1
set ::options(startscript) ""

set gthread [thread::id]
tsv::set thread gthread $gthread
thread::configure $gthread -unwindonerror 1


# Justify text
set ::host_stats_anchor(addr) w
set ::host_stats_anchor(ameutilport) w
set ::host_stats_anchor(status) w
set ::host_stats_anchor(link) w
set ::host_stats_anchor(name) w
set ::host_stats_anchor(date) w
set ::host_stats_anchor(version) w
set ::host_stats_anchor(macaddr1) w
set ::host_stats_anchor(macaddr2) w
set ::host_stats_anchor(macaddr3) w
set ::host_stats_anchor(macaddr4) w
set ::host_stats_anchor(mtm) w
set ::host_stats_anchor(model) w
set [list ::host_stats_anchor(ame date)] w
set [list ::host_stats_anchor(ame version)] w
set [list ::host_stats_anchor(ame_date)] w
set [list ::host_stats_anchor(ame_version)] w
set [list ::host_stats_anchor(api_version)] w

set ::blade_list {}

set network 1
set ::new_data_callback ""

set ::start_time [clock clicks -milliseconds]

#Arguments to user script
set ::script_argv {}

#--------------------------------------------------------------------
#
# Parse command line
#
#--------------------------------------------------------------------

proc parse_command_line {} {
    # ::argv is the TCL global that holds the command line args

    # Note: when run.tcl is used, it encloses arguments in {} braces.

    # Turn on ::amesterdebug::debug for options if --debug_options appears
    # anywhere on commandline.
    # We do this since it is too early for a user script
    # to turn on debugging
    if [string match "*--debug_options*" $::argv] {
	::amesterdebug::set options 1
    }

    set myargs ""
    ::amesterdebug::debug options "argv = $::argv"
    ::amesterdebug::debug options "argv length = [llength $::argv]"
    if {$::argv ne "{}"} {
	::amesterdebug::debug options "platform is $::tcl_platform(platform)"
	if {[string index $::argv 0] eq "\{"} {
	    # We get argv as a list of 1 item because it is passed by upper leve.
	    # Need to split each word into a new list
	    set myargs [split [lindex $::argv 0]]
	} else {
	    # argv is already a list
	    set myargs $::argv
	}
    }
    set myargi 0
    set args_extra ""
    ::amesterdebug::debug options "myargs = $myargs"
    ::amesterdebug::debug options "myargs len = [llength $myargs]"

    for {set i 0} {$i < [llength $myargs] } {incr i} {
	set arg [lindex $myargs $i]
	::amesterdebug::debug options "processing arg $i: $arg"
	if { [string match "--*" $arg] } {
	    if {[string match "--nogui" $arg]} {
		::amesterdebug::debug options "Found $arg: turn off gui"
		set ::options(gui) 0
	    } elseif {[string match "--debug" $arg]} {
		::amesterdebug::window
		::amesterdebug::debug options "Found $arg: turn off gui"
	    } elseif {[string match "--debug_options" $arg]} {
	    } else {
		puts stderr "Unknown command line argument: $arg"
		exit_application
	    }
	} else {
	    #done parsing "--" args
	    set args_extra [lrange $myargs $i end]
	    break
	}
    }

    ::amesterdebug::debug options "extra args = $args_extra"

    if {[llength $args_extra] >= 1} {
	set ::options(startscript) [lindex $args_extra 0]
	set ::script_argv [lrange $args_extra 1 end]
	::amesterdebug::debug options "script = $::options(startscript)"
	::amesterdebug::debug options "script args = $::script_argv"
    }

}






#--------------------------------------------------------------------
#
# Host procedures
#
#--------------------------------------------------------------------


#--------------------------------------------------------------------
#
# GUI for host window
#
#--------------------------------------------------------------------

# ::host_window_stats : The current columns in the host window
# ::host_window_stats_all : All available columns in the host window
# ::host_window_elements : All gui elements in the host window
# ::host_window_titles : All the gui titles in the host window
#
#
# Tk names
#
# .host.title_${key} is the title of the column

#Start with a few well-known columns
set ::host_window_stats {menu name addr ame_version api_version}
set ::host_window_stats_all $::host_window_stats
set ::host_window_after 0

proc host_window_add {host key element {title none}} {
    ::amesterdebug::debug gui "host_window_add host=$host key=$key element=$element title=$title"
    set ::host_window_elements($host,$key) $element
    if {[lsearch -exact $::host_window_stats_all $key] == -1} {
	lappend ::host_window_stats_all $key
    }
    if {$title ne "none"} {
	if {![info exists ::host_window_titles($key)]} {
	    if {![info exists ::host_stats_anchor($key)]} {
		set anchor e
	    } else {
		set anchor $::host_stats_anchor($key)
	    }
	    set ::host_window_titles($key) [label .host.c.f.title_${key}  -text $title -anchor $anchor -font $::fixedfont]
	}
    }
    host_window_update a b c
}

proc host_window_delete {host} {
    ::amesterdebug::debug gui "host_window_delete $host"
    #remove from display
    foreach item [array names ::host_window_elements $host,*] {
	destroy $::host_window_elements($item)
    }
    #forget element
    array unset ::host_window_elements "$host,*"
    host_window_update a b c
}

proc host_window_add_host {name} {
    #Host list is a list of thing to put in host (main) window
    lappend ::host_list $name
    host_window_update a b c
}

proc host_window_remove_host {name} {
    #Host_list is a list of things to put in host (main) window
    #lappend ::host_list $name
    set index [lsearch $::host_list $name]
    if {$index == -1} {
	return
    } else {
	set ::host_list [lreplace $::host_list $index $index]
    }
    host_window_update a b c
}

proc host_window_update {varname key op} {
    after cancel $::host_window_after
    set ::host_window_after [after 500 {host_window_update_do 1 2 3} ]
}

proc host_window_update_do {varname key op} {

    ::amesterdebug::debug gui "host_window_update"
    if {!$::options(gui)} {return}

    #child is the last element put in the grid. Need to sync window update.
    set child ""

    #variables for specifying the grid
    set row 0
    set col 0

    # unpack things in .host
    foreach t [grid slaves .host.c.f] {
	grid remove $t
    }

    # Pack column titles
    set row 0
    set col 0

    foreach t $::host_window_stats  {
	if {[info exists ::host_window_titles($t)]} {
	    if {[winfo exists $::host_window_titles($t)]} {
		grid $::host_window_titles($t) -row $row -column $col -ipadx 10 -sticky news
		set child $::host_window_titles($t)
	    }
	}
	incr col
    }

    incr row
    grid .host.c.f.sep -row $row -column 0 -columnspan [llength $::host_window_stats] -sticky news

    # grid scrollbar

    incr row

    # Add all sockets (hosts) being watched
    ::amesterdebug::debug gui "  host_list is $::host_list"
    foreach {name} $::host_list {
	set col 0
	foreach {t}  $::host_window_stats  {
	    if {[info exists ::host_window_elements($name,$t)]} {
		if {[winfo exists $::host_window_elements($name,$t)]} {
		    grid $::host_window_elements($name,$t) -row $row -column $col -sticky news -ipadx 10
		}
	    }
	    incr col
        }
	incr row
    }

    #Make grid stretchable
    set size [grid size .host.c.f]
    set rm [lindex $size 1]
    set cm [lindex $size 0]
    for {set row 0} {$row < $rm} {incr row} {
	grid rowconfigure .host.c.f $row -weight 1
    }
    for {set col 0} {$col < [expr $cm - 1]} {incr col} {
	grid columnconfigure .host.c.f $col -weight 1
    }

    if {$child ne ""} {
	#puts "child is $child"
	tkwait visibility $child
    } else {
	#puts "no child"
    }

    set bbox [grid bbox .host.c.f 0 2]
    set inc [lindex $bbox 3]
    set incw [lindex $bbox 2]
    set width [winfo reqwidth .host.c.f]
    set height [winfo reqheight .host.c.f]

    .host.c config -scrollregion "0 0 $width $height"
    .host.c config -yscrollincrement $inc
    .host.c config -xscrollincrement $incw
}

proc host_window_get_columns {} {
    return $::host_window_stats
}

proc host_window_get_columns_all {} {
    return $::host_window_stats_all
}

proc host_window_set_columns {newlist} {
    set ::host_window_stats $newlist
}


proc optionsWindow {} {
    global network

    if {[winfo exists .options]} {
	focus .options
	raise .options
	wm deiconify .options
	return
    }

    toplevel .options
    wm title .options "Options"
    wm resizable .options 0 0
    checkbutton .options.network -variable network -text {Receive network traffic}
    grid .options.network -sticky news

}





proc bgerror {msg} {
    global errorInfo
    global errorCode
    ::amesterdebug::debug bgerror "BGERROR: $msg"
    ::amesterdebug::debug bgerror "errorInfo: $errorInfo"
    ::amesterdebug::debug bgerror "errorCode: $errorCode"
}



#--------------------------------------------------------------------
#
# GUI thread (main thread)
#
#--------------------------------------------------------------------

#
# Name space structure for GUI
#
#
#
#. = main window
#

#
# Globals
#

set host_list ""

set ame_num_sensors 0


# Show the same stats in the GUI as are being collected
set stats "name calibrated freq value timestamp max timestamp_max min timestamp_min avg value_acc status sptime localtime"
set stats_list "name calibrated freq avg value timestamp max timestamp_max min timestamp_min"

set anchor_cols(name) "w"


set stats_trace "name value timestamp max timestamp_max min timestamp_min sptime"
set opt_trace 0
set tracefile stdout

#Ignore any data that comes in with the same timestamp for a particular sensor
set opt_ignore_same_timestamps 1

set pause 0


#
# Show the help message
#
proc readme {} {
    #global readme_message
    if {[winfo exists .readme]} {
	focus .readme
	raise .readme
	wm deiconify .readme
    } else {
	# Get manual from virtual file system
	set _readme_filename [file join $::amesterinit::topdir doc/README.txt]
	set _readme_file [open $_readme_filename r]
	set _readme_message [read $_readme_file]

	toplevel .readme
	text .readme.text -wrap word -yscrollcommand [list .readme.yscroll set] -width 80 -height 20
	scrollbar .readme.yscroll -orient vertical -command [list .readme.text yview]
	grid .readme.text .readme.yscroll -sticky news
	grid rowconfigure .readme 0 -weight 1
	grid columnconfigure .readme 0 -weight 1
	.readme.text insert end $_readme_message
    }
}


proc help {} {
    #global help_message
    if {[winfo exists .help]} {
	focus .help
	raise .help
	wm deiconify .help
    } else {
	# Get manual from virtual file system
	set help_filename [file join $::amesterinit::topdir doc/manual.txt]
	set help_file [open $help_filename r]
	set help_message [read $help_file]

	toplevel .help
	text .help.text -wrap word -yscrollcommand [list .help.yscroll set] -width 80 -height 20
	scrollbar .help.yscroll -orient vertical -command [list .help.text yview]
	grid .help.text .help.yscroll -sticky news
	grid rowconfigure .help 0 -weight 1
	grid columnconfigure .help 0 -weight 1
	.help.text insert end $help_message
    }
}

#
# Show the AME v2.15 manual
#
proc ameinterface_2_15 {} {
    set w .ame_2_15
    if {[winfo exists $w]} {
	focus $w
	raise $w
	wm deiconify $w
    } else {
	# Get manual from virtual file system
	set filename [file join $::amesterinit::topdir doc/ame_2_15.txt]
	set file [open $filename r]
	set message [read $file]

	toplevel $w
	text $w.text -wrap word -yscrollcommand [list $w.yscroll set] -width 80 -height 20
	scrollbar $w.yscroll -orient vertical -command [list $w.text yview]
	grid $w.text $w.yscroll -sticky news
	grid rowconfigure $w 0 -weight 1
	grid columnconfigure $w 0 -weight 1
	$w.text insert end $message
    }
}




proc about {} {
    if {[winfo exists .about]} {
	focus .about
	raise .about
	wm deiconify .about
    } else {
	toplevel .about
	wm resizable .about 0 0
	label .about.label -text "
$::amesterinit::toolname
Sheldon Bailey <baileysh@us.ibm.com>

Version $amesterinit::amester_ver_string

(C) Copyright IBM Corporation 2011, 2017
"  -justify left
	pack .about.label
    }
}

proc update_check {} {
    set updateurl "http://amester.austin.ibm.com/ame/download/amester/version.txt"
    if {[winfo exists .update]} {
	focus .update
	raise .update
	wm deiconify .update
    } else {
	toplevel .update
	wm resizable .update 0 0
	label .update.label
	pack .update.label
    }

    .update.label configure -text "
$::amesterinit::toolname

Checking for new version.....
"  -justify left


    if {[catch {http::geturl $updateurl -command update_callback} result]} {
	#Something went wrong
	update_callback "fail"
    }
}

proc update_callback {token} {
    set currentversion "Unknown. Bad response from server."

    #Did user close update window?
    if {![winfo exists .update]} {return}

    foreach once {x} {
	if {$token eq "fail"} {
	    set currentversion "Unknown. Error connecting to server."
	    break
	}

	#If HTTP code is not OK, abort
	set thehttp [http::code $token]
	if {![string match -nocase *OK* $thehttp ]} {
	    break
	}

	#Grab version info from the http response
	set thebody [http::data $token]
	if [info exists thebody] {
	    set currentversion $thebody
	}
    }

    .update.label configure -text "
$::amesterinit::toolname

Your version: $amesterinit::amester_ver_string
Current version: $currentversion

"  -justify left


}


proc HighlightTrace { graph } {
    set entry [$graph legend get current]
    set active [$graph legend activate]
    if { [lsearch $active $entry] < 0 } {
	$graph legend activate $entry
	$graph element activate $entry
    } else {
        $graph legend deactivate $entry
	$graph element deactivate $entry
    }
}


#
# Init AME
#

if {$::options(gui)} {
    trace variable host_window_stats w host_window_update
}

# Get local copies of shared thread IDs
tsv::get thread ithread ithread

if ($opt_trace) {
    #puts -nonewline $tracefile "#"
    foreach col $stats_trace {
	puts -nonewline  $tracefile "$col "
    }
    puts -nonewline $tracefile "\n"
}



proc pause_toggle {} {
    global pause
    set pause [expr !$pause]
    if {$pause} {
	.bbar.pause configure -text "Go"
    } else {
	.bbar.pause configure -text "Pause"
    }
}


proc run_script {} {
    if {[info exists lastdir]} {
	set dir $::lastdir
    } else {
	set dir $::tmpdir
    }

    set filename [tk_getOpenFile -defaultextension .tcl -initialdir $dir -title "Run Tcl script..."]
    if {$filename ne ""} {
	set lastdir [file dirname $filename]

	# Run the script in the global namespace
	namespace eval :: source $filename
    }

}


#--------------------------------------------------------------------
#
# UID
#
#--------------------------------------------------------------------

set uid_count 0
proc uid_create {} {
    global uid_count
    incr uid_count
    return "u${uid_count}"
}



#--------------------------------------------------------------------
#
# Exit program
#
#--------------------------------------------------------------------

proc cleanup {{return_code 0}} {
    ::amesterdebug::debug exit "Cleanup"
    # Cancel all outstanding after commands so theads can die
    foreach id [after info] {
	after cancel $id
    }

    # Remove temporary files
    ::amesterdebug::debug exit "Removing temp directory $::tmpdir"
    if {[set code [catch {file delete -force $::tmpdir}]]} {
	puts "Error: can't delete $::tmpdir with code=$code"
	puts "errorInfo: $::errorInfo"
	puts "errorCode: $::errorCode"
    }

    # Release all threads
    ::amesterdebug::debug exit "Releasing threads"
    foreach t [thread::names] {
	thread::release $t
    }

    ::amesterdebug::debug exit "removing host objects"
    if {[set code [catch {
	# Delete all host objects
	foreach h [find object -isa host] {
	    delete object $h
	}
    } ]]} {
	puts "Error: can't delete object $h with code=$code"
	puts "errorInfo: $::errorInfo"
	puts "errorCode: $::errorCode"
    }

    # Delete all remaining Tk objects
    #if {$::options(gui)} {
#	destroy .
#    }

    # Debug
    if {[::amesterdebug::set exit]} {
	# show remaining objects
	set objs [find objects]
	if {$objs ne {}} {puts "remaining objs: $objs"}

	if {$::options(gui)} {
	    set widgets [winfo children .]
	    while {$widgets ne {}} {
		set newlist {}
		foreach w $widgets {
		    puts "remining widgets: $w"
		    foreach x [winfo children $w] {
			lappend newlist $x
		    }
		}
		set widgets $newlist
	    }
	}
    }
}

proc exit_application {{return_code 0}} {
    ::amesterdebug::debug exit "exit_application"

    if {[catch {set exit_time [time {cleanup}]} result]} {
	if {$::options(gui)} {
	    ::commandline::commandline_puts_original "Abnormal exit: $result"
	} else {
	    puts "Abnormal exit: $result"
	}
	exit $return_code
    }

    if {[::amesterdebug::set exit]} {
	if {$::options(gui)} {
	    ::commandline::commandline_puts_original "exit_time $exit_time"
	} else {
	    puts "exit_time $exit_time"
	}
    }

    ::_exit_original $return_code
}

proc amester_sigint {trapname} {
    ::amesterdebug::debug exit "my_sigint"
    if {$::options(gui)} {
	::commandline::commandline_puts_original "Exit due to signal $trapname"
    } else {
	puts "Exit due to signal $trapname"
    }
    exit_application
}

proc amester_sigchld {} {
    puts "my_sigchld"
    if [catch {wait -i -1} output] {
	puts "sigchld wait failed"
    }
    if {$::options(gui)} {
	::commandline::commandline_puts_original "caught SIGCHLD"
	::commandline::commandline_puts_original "output = $output"
	::commandline::commandline_puts_original "pid is [lindex $output 0]"
	::commandline::commandline_puts_original "status is [lindex $output 3]"
    } else {
	puts "caught SIGCHLD"
	puts "output = $output"
	puts "pid is [lindex $output 0]"
	puts "status is [lindex $output 3]"
    }
}


#Make sure to clean up temporary files by calling exit_application
rename ::exit ::_exit_original
interp alias {} ::exit {} ::exit_application

#Removed because it doesn't work for Catie Sherry from Java launched Amester.
#
#Cleanup when program is shutdown by a kill signal or control-C on command line.
#Use Extended Tcl (Tclx library) for signal handling.
#Note: Previously tried Expect trap command, but it didn't always work.
#Note: Do not trap SIGCHLD because it is sent when Expect spawn closes.
#signal trap {SIGINT SIGTERM} "::amester_sigint %S"


#--------------------------------------------------------------------
#
# Start program
#
#--------------------------------------------------------------------

#
# Figure out what platform we are on
#

proc make_tmpdir {} {

    set ::tmpdir ""
    set platform $::tcl_platform(platform)
    set pid [pid]
    set seconds [clock seconds]
    if {$platform eq "windows"} {
	set ::tmpdir "C:/tmp/amester-${pid}-${seconds}"
    } else {
	if {$platform eq "unix"} {
	    set ::tmpdir "/tmp/amester-${pid}-${seconds}"
	} else {
	    puts "Error: don't recognize platform = $platform"
	    exit 1
	}
    }

    tsv::set shared tmpdir $::tmpdir



    if {[set code [catch {file delete -force $::tmpdir}]]} {
	puts "Error: can't delete $tmpdir with code=$code"
	puts "errorInfo: $errorInfo"
	puts "errorCode: $errorCode"
    }
    if {[catch {file mkdir $::tmpdir} ]} {
	puts "Error: can't make directory $tmpdir"
	puts "errorInfo: $errorInfo"
	puts "errorCode: $errorCode"
    }
    if {$platform eq "unix"} {
	if {[catch {
	    file attributes $::tmpdir -permissions 0777
	}]} {puts "Error: can't set permissions on $::tmpdir"}
    }
}


make_tmpdir

parse_command_line

#
# Main window
#
if {$options(gui)} {
    #
    # Menu bar
    #
    frame .mbar -relief raised -bd 2

    # file menu
    menubutton .mbar.file -text File -underline 0 -menu .mbar.file.menu
    menu .mbar.file.menu
    .mbar.file.menu add cascade -label "Connect to..." -menu .mbar.file.menu.connect
    #.mbar.file.menu add command -label "Open scope file..." -command ::amescope::open_file
    .mbar.file.menu add command -label "Run Tcl script..." -command run_script
    .mbar.file.menu add command -label "Quit" -command exit_application

    menu .mbar.file.menu.connect

    # tools menu
    menubutton .mbar.tools -text Tools -underline 0 -menu .mbar.tools.menu
    menu .mbar.tools.menu
    .mbar.tools.menu add command -label "Command line..." -command commandline
    .mbar.tools.menu add command -label "Debug messages..." -command ::amesterdebug::window
    .mbar.tools.menu add command -label "Options..." -command optionsWindow

    #help menu
    menubutton .mbar.help -text Help -underline 0 -menu .mbar.help.menu
    menu .mbar.help.menu
    .mbar.help.menu add command -label "README.txt" -command "readme"
    .mbar.help.menu add command -label "User Manual" -command "help"
    #.mbar.help.menu add command -label "Check for new version" -command "update_check"
    .mbar.help.menu add command -label "About" -command "about"

    pack .mbar.file .mbar.tools .mbar.help -side left

    #
    # Button bar
    #
    frame .bbar -relief raised -bd 2
    button .bbar.quit -text "Quit" -command exit_application
    button .bbar.selcols -text "Select columns" -command [list multiselect \#auto host_window_stats_all host_window_stats]
    button .bbar.pause -text "Pause" -command pause_toggle
    pack .bbar.selcols .bbar.pause -side left

    #
    # Host pane
    #

    frame .host
    canvas .host.c -yscrollcommand [list .host.yscroll set] -xscrollcommand [list .host.xscroll set]
    frame .host.c.f
    scrollbar .host.yscroll -orient vertical -command [list .host.c yview]
    scrollbar .host.xscroll -orient horizontal -command [list .host.c xview]
    .host.c create window 0 0 -anchor nw -window .host.c.f

    frame .host.c.f.sep -bg black -height 2

    wm title . $::amesterinit::toolname
    wm resizable . 1 1

    pack .mbar -side top -fill x
    pack .bbar -side top -fill x
    pack .host.yscroll -side right -fill y
    pack .host.xscroll -side bottom -fill x
    pack .host.c -side left -fill both -expand true
    pack .host -side top -fill both -expand true

    bind .host <Control-c> {exit_application}
    bind . <Control-c> {exit_application}
    bind all <Control-c> {exit_application}
    wm protocol . WM_DELETE_WINDOW exit_application
} else {
}

# Packages required by classes or user scripts
# Note: dqkit has TclUDP compiled inside.
if {[catch {package require udp} result]} {
    #bgerror "Cannot load UDP library. rmcp feature will not work: $result"
    puts "Cannot load UDP library. rmcp feature will not work: $result"
    package forget udp
}

# Load classes
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester sensor.itcl sensor_*.itcl]]
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester ame.itcl ame_*.itcl]]
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester bc.itcl]]
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester scope.itcl scope_*.itcl ]]
lappend files [glob -directory $::amesterinit::topdir/lib/app-amester host.itcl blade.itcl local.itcl rmcp.itcl netc.itcl emtagent.itcl systemz.itcl tunasim.itcl openpower.itcl openbmc.itcl]
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester parm_*.itcl]]
lappend files [lsort [glob -directory $::amesterinit::topdir/lib/app-amester tracebuffer.itcl tracebuffer_*.itcl ]]


::amesterdebug::debug init "loading files: $files"
foreach f  [join $files] {
    source $f
}

if {[info exists ::options(startscript)]} {
    ::amesterdebug::debug options "startscript = $::options(startscript)"
    if {$::options(startscript) ne ""} {
	if {[catch {source $::options(startscript)} result]} {
	    bgerror "script $::options(startscript) failed: $result"
	    puts "script $::options(startscript) failed: $result"
	}
    }
}



if {!$::options(gui)} {
    ::amesterdebug::debug threads "$::amesterinit::toolname is waiting"
    thread::wait
}
