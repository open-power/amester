# all.tcl --
#
# This file contains a top-level script to run all of the Tcl
# tests.  Execute it by invoking "make test" 
#

# restart using tclsh \
exec tclsh "$0" "$@"

package require tcltest 2

package require Tk ;# This is for a Tk Widget; fail early if no Tk!

# Get RBC
load [lindex $argv 0]
source [file normalize [file dirname [file dirname [info script]]]]/library/graph.tcl

eval tcltest::configure [lrange $argv 1 end]
tcltest::configure -testdir [file normalize [file dirname [info script]]]

tcltest::configure -singleproc 1
tcltest::runAllTests

