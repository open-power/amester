#
# (C) Copyright IBM Corporation 2011, 2016
#

package provide app-emtagent 5.10


#--------------------------------------------------------------------
#
# Structure of Amester
#
#--------------------------------------------------------------------

# Important global variables

# tsv:: thread - contains thread IDs for the GUI and IPMI threads
# sensor_list - a list of numerical sensor IDs that are displayed in GUI
# sensor_list_all - a list of numerical sensor IDs that exist in service processor
# s_$sensor() - current values related to sensor ID = $sensor. 
#                  name,freq,timestamp,last_timestamp,timestamp_min,timestamp_max,value,value_acc,min,max# v_$sensor_value - vector of last values for sensor
# v_$sensor_timestamp - vector of last values for timestamp
# topdir = top directory for finding files need by this program


#--------------------------------------------------------------------
#
# Packages
#
#--------------------------------------------------------------------

package require Itcl
namespace import itcl::*

package require Thread

if {$::options(gui)} {
    package require Tk
    package require commandline
    namespace import commandline::commandline
    package require multiselect
    namespace import multiselect::multiselect
}

# even if there is no Tk, we need vectors from BLT
package require BLT
namespace import blt::*

package require debug
namespace import debug::*


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

#set legendfont {-size 10}
#set axisfont {-size 10}
#set tickfont {-size 9}
#set markerfont {-size 9}
#set graphtitlefont {-size 10}
#set fixedfont {-family courier -size 10}
#set fixedfontbold {-family courier -size 10 -weight bold}
#set valuelabelwidth 12

set legendfont {-size 12}
set axisfont {-size 14}
set tickfont {-size 12}
set markerfont {-size 10}
set graphtitlefont {-size 12}
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
debugSet warn 0
debugSet options 0
debugSet network 0
debugSet bgerror 1
debugSet ame 0
debugSet sensor 0
debugSet gui 0
debugSet budget 0
debugSet power 0
debugSet scope 0
debugSet ta 0
debugSet bc 0
debugSet health 0
debugSet login 0
debugSet histogram 0
debugOutput stderr
set options(gui) 0
set options(bg) 1

set gthread [thread::id]
tsv::set thread gthread $gthread

# Current displayed blade stats
#set host_stats [list {menu} {name} {addr} {ame version} {inserted}]
# All available host stats
#set host_stats_list [list {menu} {name} {inserted} {on} {addr} {port} {link} {status} {version} {date} {ame version} {ame date} {api version} {requests} {budget} {budget_prealloc} {budget_postalloc} {budget_low} {budget_high} {control_enable} {control_type} {control_a} {control_16ms} {control_160ms} {control_1s} {frequency} {numcpu} {cpulist} {cpumask}]

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

#set ::default_stats_list {name freq value max min}
#set ::default_stats_list_all {name number freq max min scalefactor status test timestamp timestamp_min timestamp_max value value_acc has_hist }

set ::blade_list {}

set network 1
set ::new_data_callback ""

set ::start_time [clock clicks -milliseconds]

#--------------------------------------------------------------------
#
# Parse command line
#
#--------------------------------------------------------------------

proc parse_command_line {} {

    global options
    global argv
    
    debug options "argv = $argv"

    # We get argv as a list of 1 item because it is passed by upper leve.
    # Need to split each word into a new list
    set myargs [split [lindex $argv 0]]
    set myargi 0
    set args_extra {}
    
    
    for {set i 0} {$i < [llength $myargs] } {incr i} {
	set arg [lindex $myargs $i]
	debug options "processing arg $i: $arg"
	if { [string match "--*" $arg] } {
	    if {[string match "--nogui" $arg]} {
		debug options "Found $arg: turn off gui"
		set options(gui) 0
	    } elseif {[string match "--gui" $arg]} {
		debug options "Found $arg: turn on gui"
		set options(gui) 1
	    } elseif {[string match "--bg" $arg]} {
		debug options "Found $arg: run in background\n"
		set options(bg) 1
		set options(gui) 0
	    } elseif {[string match "--debug" $arg]} {
		debugWindow
		debug options "Found $arg: turn off gui"
	    } else {
		puts stderr "Unknown command line argument: $arg"
		exit_application
	    }
	} else {
	    lappend args_extra $arg
	}
    }
    
    debug options "extra args = $args_extra"
    
    if {[llength $args_extra] == 1} {set options(startscript) $args_extra}

    # Parse the extra arguments if possible
    # Currently, we understand -c <chassis ip> -b <blade ip> 
    # The chassis and the blade ip only need to include the 
    # last octet
    if {[llength $args_extra] > 1} {
	set options(startscript) [lindex $args_extra 0]
	for {set index 1} {$index < [llength $args_extra]} {incr index} {
	    set my_arg [lindex $args_extra $index]
	    debug options "Index = $index, argument = $my_arg"
	    if {$my_arg ==  "-c"} {
		incr index
		set my_ip [lindex $args_extra $index]
		debug options "Chassis IP: $my_ip"
		set options(chassis_ip) $my_ip
	    } elseif {$my_arg == "-b"} {
		incr index
		set my_ip [lindex $args_extra $index]
		debug options "Blade IP: $my_ip"
		set options(blade_ip) $my_ip
	    }	elseif {$my_arg == "-s"} {
		incr index
		set my_slot [lindex $args_extra $index]
		debug options "Slotmask : $my_slot"
		set options(slotmask) $my_slot
	    }	        
	}
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
set ::host_window_stats {menu name mtm addr link macaddr1 ame_version api_version}
set ::host_window_stats_all $::host_window_stats
set ::host_window_after 0

proc host_window_add {host key element {title none}} {
    debug gui "host_window_add host=$host key=$key element=$element title=$title"
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
    debug gui "host_window_delete $host"
    #remove from display
    foreach item [array names ::host_window_elements $host,*] {
	grid remove $::host_window_elements($item)	
	destroy $::host_window_elements($item)	
    }
    #forget element
    array unset ::host_window_elements "$host,*"
}

proc host_window_add_host {name} {
    #Host list is a list of thing to put in host (main) window
    lappend ::host_list $name
    host_window_update a b c
}

proc host_window_remove_host {name} {
    #Host list is a list of thing to put in host (main) window
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
    debug gui "host_window_update"
    if {!$::options(gui)} {return}

    #set beginheight [.host config -height]
    #puts "host height begin=$beginheight"

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
    #grid .host.c.f.yscroll -row $row -rowspan [llength $:host_list] -column [llength $::host_window_stats] -sticky news
    
    # Add all sockets (hosts) being watched
    debug gui "  host_list is $::host_list"
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
    set bbox [grid bbox .host.c.f 0 0]
    set inc [lindex $bbox 3]
    set width [winfo reqwidth .host.c.f]
    set height [winfo reqheight .host.c.f]
    #puts "Frame width=$width height=$height"


    .host.c config -scrollregion "0 0 $width $height"
    .host.c config -yscrollincrement $inc

    #set endheight [.host config -height]
    #puts "host height end=$endheight"

    set max [expr 2 + [llength $::host_list]]
    if {$max > 15} {set max 15}
    set height [expr $inc * $max]

    .host.c config -width $width -height $height
    .host config -width $width -height $height

    #.host.c config -scrollregion "0 0 $width $height"
    #.host.c config -yscrollincrement $inc
    #set max [expr 2 + [llength $::host_list]]
    #if {$max > 10} {set max 10}
    #set height [expr $inc * $max]
    #.host.c config -width $width -height $height
    #.host config -width $width -height $height

    #puts "grid bbox [grid bbox .host.c.f "0 0 [grid size .host.c.f]"]"
    

}



#
# Make a window of a sensor across all blades
#
proc make_sensor_window {sensorname {title ""} {max ""} {bladelist {}}} {
    global valuelabelwidth
    global sensorinfo
    global blade
    global blade_list

    if {[llength $bladelist] == 0} {
	set bladelist [find objects host]
    }

    if {[llength $bladelist] == 0} {
	puts "Error: make_sensor_window: bladelist empty"
	return
    }

    if {$title == ""} {set title "Sensor $sensorname"}

    # window
    
    # We use sensorname in window names
    # Tk doen't like "." in window names, so we replace "." with "_"
    # 
    #
    regsub -all "\\." $sensorname "_" newname
    set newname [string tolower $newname]
    set winname .sensorwin_${newname}

    if {[winfo exists $winname]} {
	focus $winname
	raise $winname
	return

    }

    toplevel $winname

    wm title $winname "Graph of sensor $sensorname for all blades"

    set unit ""
    foreach name $bladelist {
	if {![info exists sensorinfo($name,$sensorname,max)]} {
	    debug 1 "sensorinfo ($name,$sensorname,max) does not exist"
	    continue
	}
	set unit $sensorinfo($name,$sensorname,u_value)
	if {$max ne "" && $max < $sensorinfo($name,$sensorname,max)} {
	    set max $sensorinfo($name,$sensorname,max)
	    set max [expr $max + 10]
	}
    }

    frame $winname.g

    stripchart $winname.g.plot -plotbackground white -title $title  -font $::graphtitlefont -plotpadx $::plotpadx -plotpady $::plotpady
    $winname.g.plot axis configure y -min 0 -max $max -title $unit -stepsize 10 -subdivisions 2 -tickfont $::tickfont -titlefont $::axisfont  -loose 1
    $winname.g.plot axis configure x -title Time -loose 0  -shiftby 100 -tickfont $::tickfont -titlefont $::axisfont
    foreach name $bladelist {
	global v_value_${name}_${sensorname}
	global v_timestamp_${name}_${sensorname}
	if {![info exists v_value_${name}_${sensorname}]} {
	    debug 1 "can't make graph for $name"
	    continue
	}
	$winname.g.plot element create value_{$name} -color $::blade($name,color)  -ydata v_value_${name}_${sensorname} -xdata v_timestamp_${name}_${sensorname} -label $name -pixels 0 -linewidth 3
    }

    $winname.g.plot legend configure -hide 0  -font $::legendfont -padx $::legendpadx -pady $::legendpady -ipadx $::legendipadx -ipady $::legendipady -anchor $::legendanchor
    $winname.g.plot grid on

    pack $winname.g.plot -side left -expand yes -fill both
    pack $winname.g -side top -expand yes -fill both

    Blt_ZoomStack $winname.g.plot
    Blt_Crosshairs $winname.g.plot
    Blt_ActiveLegend $winname.g.plot
    Blt_PrintKey $winname.g.plot

    
}

proc host_window_get_columns {} {
    return $::host_window_stats
}

proc host_window_get_columns_all {} {
    return $::host_window_stats_all
}

proc host_window_set_columns {newlist} {
    #foreach item $newlist {
    #	if {[lsearch -exact ::host_window_stats_all $item] == -1} {
    #	    puts stderr "Error: host_window_set_columns unknown column $item. Must be one of $::host_window_stats_all"
    #	    return
    #	}
    #    }
    set ::host_window_stats $newlist
}


proc optionsWindow {} {
    global network

    if {[winfo exists .options]} {
	focus .options
	raise .options
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
    debug bgerror "BGERROR: $msg"
    debug bgerror "errorInfo: $errorInfo"
    debug bgerror "errorCode: $errorCode"
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
proc help {} {
    #global help_message
    if {[winfo exists .help]} {
	focus .help
	raise .help
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
    } else {
	toplevel .about
	wm resizable .about 0 0
	label .about.label -text "
EMT Agent


Version $amesterinit::amester_ver_string


(C) Copyright IBM Corporation 2011, 2016

"  -justify left
	pack .about.label 
    }
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



proc Scroll_Set {scrollbar geoCmd offset size} {
	if {$offset != 0.0 || $size != 1.0} {
		eval $geoCmd					;# Make sure it is visible
	}
	$scrollbar set $offset $size
}


proc Scrolled_Listbox { f args } {
	frame $f
	listbox $f.list \
		-xscrollcommand [list Scroll_Set $f.xscroll \
			[list grid $f.xscroll -row 1 -column 0 -sticky we]] \
		-yscrollcommand [list Scroll_Set $f.yscroll \
			[list grid $f.yscroll -row 0 -column 1 -sticky ns]]
	eval {$f.list configure} $args
	scrollbar $f.xscroll -orient horizontal \
		-command [list $f.list xview]
	scrollbar $f.yscroll -orient vertical \
		-command [list $f.list yview]
	grid $f.list -sticky news
	grid rowconfigure $f 0 -weight 1
	grid columnconfigure $f 0 -weight 1
	return $f.list
}


proc List_Select { parent values current } {
	# Create two lists side by side
	frame $parent
	frame $parent.fp
	frame $parent.fc
	
	set choices [Scrolled_Listbox $parent.fc.choices -width 20 -height 10 -selectmode extended]
	set picked [Scrolled_Listbox $parent.fp.picked -width 20 -height 10 -selectmode extended]
	label $parent.fc.l -text "Available choices" -anchor w
	label $parent.fp.l -text "Selected" -anchor w
	pack $parent.fc.l -side top -fill x
	pack $parent.fc.choices -side top -expand true -fill both
	pack $parent.fp.l -side top -fill x
	pack $parent.fp.picked -side top -expand true -fill both
	pack $parent.fc $parent.fp -side left -expand true -fill both

	# Selecting in choices moves items into picked
	bind $choices <ButtonRelease-1> \
		[list ListTransferSel %W $picked]

	# Selecting in picked deletes items
	bind $picked <ButtonRelease-1> {ListDeleteSel %W %y}

	# Insert all the choices
	foreach x $values {
		$choices insert end $x
	}
	foreach x $current {
		$picked insert end $x
	}
}

proc ListTransferSel {src dst} {
    set current [$dst get 0 end]
    foreach i [$src curselection] {
	# Only insert items not already picked
	set item [$src get $i]
	if {[lsearch $current $item] == -1} {
	    $dst insert end $item
	}
    }
}
proc ListDeleteSel {w y} {
	foreach i [lsort -integer -decreasing [$w curselection]] {
		$w delete $i
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
    global tmpdir
    global lastdir

    if {[info exists lastdir]} {
	set dir $lastdir
    } else {
	set dir $tmpdir
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

proc exit_application {{return_code 0}} {
    # Cancel all outstanding after commands so theads can die
    foreach id [after info] {
	after cancel $id
    }

    # Remove temporary files
    if {[set code [catch {file delete -force $::tmpdir}]]} {
	puts "Error: can't delete $::tmpdir with code=$code"
	puts "errorInfo: $::errorInfo"
	puts "errorCode: $::errorCode"
    }

    exit $return_code


}

#--------------------------------------------------------------------
#
# Start program
#
#--------------------------------------------------------------------

#
# Figure out what platform we are on
#

set tmpdir ""
set platform $tcl_platform(platform)
set pid [pid]
if {$platform eq "windows"} {
    set tmpdir "C:/tmp/amester-$pid"
} else {
    if {$platform eq "unix"} {
	set tmpdir "/tmp/amester-$pid"
    } else {
	puts "Error: don't recognize platform = $platform"
	exit 1
    }
}

tsv::set shared tmpdir $tmpdir



if {[set code [catch {file delete -force $tmpdir}]]} {
    puts "Error: can't delete $tmpdir with code=$code"
    puts "errorInfo: $errorInfo"
    puts "errorCode: $errorCode"
}
if {[catch {file mkdir $tmpdir} ]} {
    puts "Error: can't make directory $tmpdir"
    puts "errorInfo: $errorInfo"
    puts "errorCode: $errorCode"
}
if {$platform eq "unix"} {
    if {[catch {
	file attributes $tmpdir -permissions 0777
    }]} {puts "Error: can't set permissions on $tmpdir"}
}


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
    .mbar.file.menu add command -label "Open scope file..." -command ::amescope::open_file
    .mbar.file.menu add command -label "Run Tcl script..." -command run_script
    .mbar.file.menu add command -label "Quit" -command exit_application
    
    # tools menu
    menubutton .mbar.tools -text Tools -underline 0 -menu .mbar.tools.menu
    menu .mbar.tools.menu
    .mbar.tools.menu add command -label "Command line..." -command commandline
    .mbar.tools.menu add command -label "Debug messages..." -command debugWindow
    .mbar.tools.menu add command -label "Options..." -command optionsWindow

    # graph menu
    #menubutton .mbar.graph -text Graphs -underline 0 -menu .mbar.graph.menu
    #menu .mbar.graph.menu
    #.mbar.graph.menu add command -label "Power" -command {make_sensor_window pwr1sec "1s avg power"}
    #.mbar.graph.menu add command -label "Temperature" -command {make_sensor_window tempCPU0 "Temperature CPU1"}
    #.mbar.graph.menu add command -label "Performance" -command {make_sensor_window CPUspd1s "1s avg CPU Speed" 100}
    #.mbar.graph.menu add command -label "Budget graph" -command {budget_graph_window}
    #.mbar.graph.menu add command -label "Budget barchart" -command {cluster_budget_barchart}
    #.mbar.graph.menu add command -label "Cluster speed" -command {cluster_speed_graph}
    #.mbar.graph.menu add command -label "Cluster cycles" -command {cluster_cycles_graph}
    #.mbar.graph.menu add command -label "Latency results" -command {cluster_perf_latency_graph "Workload latency" "Time (s)"}
    #.mbar.graph.menu add command -label "Throughput results" -command {cluster_perf_throughput_graph "Workload throughput" "GFlops"}
    

    #help menu
    menubutton .mbar.help -text Help -underline 0 -menu .mbar.help.menu
    menu .mbar.help.menu
    .mbar.help.menu add command -label "Amester Manual" -command "help"
    .mbar.help.menu add command -label "AME Interface v2.15" -command "ameinterface_2_15"
    .mbar.help.menu add command -label "About Amester" -command "about"
    
    #pack .mbar.file .mbar.tools .mbar.graph .mbar.help -side left
    pack .mbar.file .mbar.tools .mbar.help -side left
    #focus .mbar

    #
    # Button bar
    #
    frame .bbar -relief raised -bd 2
    button .bbar.quit -text "Quit" -command exit_application
    button .bbar.selcols -text "Select columns" -command [list multiselect host_window_stats_all host_window_stats]
    button .bbar.pause -text "Pause" -command pause_toggle
    pack .bbar.selcols .bbar.pause -side left
    #focus .bbar
    
    #
    # Host pane
    #
    
    frame .host
    #frame .host.title
    canvas .host.c -yscrollcommand [list .host.yscroll set]
    frame .host.c.f
    scrollbar .host.yscroll -orient vertical -command [list .host.c yview]
    .host.c create window 0 0 -anchor nw -window .host.c.f

    frame .host.c.f.sep -bg black -height 2

    wm title . "Amester"
    wm resizable . 1 1

    #grid .mbar -sticky news
    #grid .bbar -sticky news
    # do not resize menu or button bar
    #grid rowconfigure . 0 -weight 0
    #grid rowconfigure . 1 -weight 0
    pack .mbar -side top -fill x
    pack .bbar -side top -fill x
    #grid .host -sticky news
    #grid .host.c .host.yscroll -sticky news
    # do not resize scroll bar
    #grid columnconfigure .host 1 -weight 0
    pack .host.yscroll -side right -fill y
    pack .host.c -side left -fill both -expand false
    pack .host -side top -fill both -expand false

    #grid .mbar -sticky ew
    #grid .bbar -sticky we
    #grid .host -sticky news

    #grid .host.c .host.yscroll -sticky news
    #pack .host.c -side left -fill both -expand true
    #pack .host.yscroll -side right -fill y

    

    bind .host <Control-c> {exit_application}
    bind . <Control-c> {exit_application}
    bind all <Control-c> {exit_application}
    wm protocol . WM_DELETE_WINDOW exit_application

} else {
    #wm withdraw .
}

# Packages required by classes or user scripts

# Load classes
set files [glob -directory $::emtagentinit::topdir/lib/app-emtagent sensor.itcl sensor_*.itcl ame.itcl ame_*.itcl host.itcl local.itcl ]
foreach f  $files {source $f}


#
# Socket server
#

# default port for EMT agent communication
set server(port) 1413
set server(main) {}

proc server_start {} {
    global server
    if {[catch { 
	set server(main) [socket -server server_accept $server(port)]
    }] } {
	puts stderr "ERROR: cannot start server on port $::server(port). Another EMT Agent may be running on that port."
	exit_application
    }

    set server(list) {}
    #server_send_data
}

proc server_stop {} {
    global server
    set slist $server(list)
    foreach s $slist {
	server_close_sock $s
    }

    if {$server(main) ne {}} {close $server(main)}
}

proc server_accept {sock addr port} {
    global server
    debug network "Accept $sock from $addr:$port\n"
    set server($sock,addr) [list $addr $port]

    # init socket
    set server($sock,senddata) 0

    fconfigure $sock -buffering line -blocking no
    fileevent $sock readable [list server_process $sock]

    lappend server(list) $sock

    server_write_msg $sock "\# Welcome to AMEC"

}

proc server_close_sock {sock} {
    global server
    close $sock
    debug network "Closed $server($sock,addr)"
    unset server($sock,addr)

    # Remove from the list of active sockets
    set i [lsearch -exact $server(list) $sock]
    if {$i > -1} {
	set server(list) [lreplace $server(list) $i $i]
    }
    
    debug network "Active sockets: $server(list)\n"
}

proc server_process {sock} {
    global server
    if {[eof $sock] || [catch {gets $sock line}]} {
	server_close_sock $sock
    } else {
	debug network "received from $sock $line\n"
	set tag [lindex $line 0]
	set msg [lindex $line 1]
	if {[string compare $msg "quit"] == 0} {
	    server_close_sock $sock
	} elseif {[string compare $msg "send_data"] == 0} {
	    send_data $sock $tag
	} elseif {[string compare [lindex $msg 0] "bg"] == 0} {
	    #remove bg command from msg
	    set msg [lreplace $msg 0 0]
	    #run message in background
	    if {[info complete $msg]} {
		server_bg $sock $tag $msg
	    }
	} elseif {[info complete $msg]} {
	    # Try to process the command
	    set code [catch {uplevel \#0 $msg} result]
	    debug network "ran $tag and got result=$result"
	    #convert end-of-line to whitespace. Required so AMESTER can grab complete lines with the returned result.  It doesn't know how to get multi-line responses.
	    set result [string map {\n { } \r { }} $result]
	    server_write_msg $sock [list $tag $result]
	} else {
	    debug network "Got invalid command: $line\n"
	}
	
    }

}

proc server_write_msg {sock msg} {
    global server
    if {[eof $sock] || [catch {puts $sock $msg}]} {
	server_close_sock $sock
    } else {
	#debug "sent $server($sock,addr): $msg"
    }
}

proc server_bg {sock tag msg} {
    set sthread [thread::create {

	global msg
	global sock
	global tag

	tsv::get thread gthread gthread

	proc go {} {
	    global msg
	    global sock
	    global tag
	    global gthread

	    #puts "running background $msg"
	    
	    set code [catch {uplevel \#0 $msg} result]
	    #convert end-of-line to whitespace. Required so AMESTER can grab complete lines with the returned result.  It doesn't know how to get multi-line responses.
	    set result [string map {\n { } \r { }} $result]
	    #puts "got result: $result"
	    #puts "tag: $tag"
	    #debug network "ran $tag and got result=$result"
	    thread::send -async $gthread [list server_write_msg $sock [list $tag $result]]
	    thread::release
	}
	
	thread::wait
    }]
    # Initialize the data collection thread for the sensor
    thread::send $sthread [list set msg $msg]
    thread::send $sthread [list set sock $sock]
    thread::send $sthread [list set tag $tag]
    thread::send -async $sthread [list go]
}


server_start




if {[info exists options(startscript)]} {
    if {[catch {source $options(startscript)} result]} {
	bgerror "script $options(startscript) failed: $result"
    }
}

# Start localhost

if {[catch {localhost me} result]} {
    bgerror "Could not open localhost object: $result"
    exit 1
}

#This causes the program to run in the background, when ssh hangsup.
if {!$::options(gui)} {
    puts "thread is waiting"
    thread::wait
}
