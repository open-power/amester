# RBC.barchart.element.closest.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element closest 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.element

package require rbc
namespace import rbc::*

namespace eval barchart.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly when a closest element 
	# exists.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.1.1.Body {} {
		set coords [.barchart1 transform 1 1]
		.barchart1 element closest [lindex $coords 0] [lindex $coords 1] Array1
		puts [array get Array1]
		puts "dist 0.0 x 1.0 index 0 y 1.0 name Element1"
	}
	
	proc RBC.barchart.element.closest.M.1.1.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly when a closest element 
	# does not exist.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.1.2.Body {} {
		set coords [.barchart1 transform 3 3]
		puts [.barchart1 element closest [lindex $coords 0] [lindex $coords 1] Array1]
		puts "0"
	}
	
	proc RBC.barchart.element.closest.M.1.2.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly with the halo flag and a 
	# closest element exists.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.2.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.2.1.Body {} {
		set coords [.barchart1 transform 1 1]
		.barchart1 element closest [lindex $coords 0] [expr {[lindex $coords 1] + 8}] Array1 -halo 10
		puts [array get Array1]
		puts "dist 0.0 x 1.0 index 0 y 1.0 name Element1"
	}
	
	proc RBC.barchart.element.closest.M.2.1.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly with the halo flag and a 
	# closest element exists.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.2.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.2.2.Body {} {
		set coords [.barchart1 transform 1 1]
		puts [.barchart1 element closest [lindex $coords 0] [expr {[lindex $coords 1] + 12}] Array1 -halo 10]
		puts "0"
	}
	
	proc RBC.barchart.element.closest.M.2.2.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly  when a closest element 
	# exists and 'no' is given to the interpolate flag.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.3.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.3.1.Body {} {
		set coords [.barchart1 transform 1.5 1.5]
		puts [.barchart1 element closest [lindex $coords 0] [lindex $coords 1] Array1 -interpolate no]
		puts "0"
	}
	
	proc RBC.barchart.element.closest.M.3.1.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly  when a closest element 
	# exists and 'yes' is given to the interpolate flag.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.closest.M.3.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.closest.M.3.2.Body {} {
		set coords [.barchart1 transform 1.5 1.5]
		.barchart1 element closest [lindex $coords 0] [lindex $coords 1] Array1 -interpolate yes
		puts [array get Array1]
		puts "dist 0.0 x 1.5 index 0 y 1.5 name Element1"
	}
	
	proc RBC.barchart.element.closest.M.3.2.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
}
