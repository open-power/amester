#
# (C) Copyright IBM Corporation 2011, 2016
#

#
#New choice select
#
package provide multiselect 1.0

package require Tk

namespace eval ::multiselect:: {

    namespace export multiselect
}

proc ::multiselect::multiselect_ok {current {cmd {}}} {
    set r [.multiselect_window.f.fp.picked.list get 0 end]
    upvar \#0 $current c
    set c $r
    destroy .multiselect_window
    namespace eval :: $cmd
}

proc ::multiselect::multiselect_cancel {} {
    destroy .multiselect_window
}

proc ::multiselect::multiselect {all current {cmd {}}} {

    #global stats 
    #global stats_list
    upvar \#0 $all a
    upvar \#0 $current c
    set winname ".multiselect_window"

    # if window exists, raise it
    if {[winfo exists $winname]} {
	focus $winname
	raise $winname
	return
    }
    
    toplevel $winname
    wm title $winname "Select"
    wm resizable $winname 0 1

    List_Select $winname.f $a $c
    pack $winname.f -side top -expand true -fill both 
    #-side top
    #-expand true -fill both -side top

    frame $winname.bbar -relief raised -bd 2
    button $winname.bbar.ok -background lightblue -text "Ok" -command [list ::multiselect::multiselect_ok $current $cmd]
    button $winname.bbar.cancel -background lightblue -text "Cancel" -command ::multiselect::multiselect_cancel
    pack $winname.bbar.ok $winname.bbar.cancel -side left 
#-expand false -fill x
    pack $winname.bbar -expand false -fill x -side bottom
    #-expand false -fill x -side bottom
}

