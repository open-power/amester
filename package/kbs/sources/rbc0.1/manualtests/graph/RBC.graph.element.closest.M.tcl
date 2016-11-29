# RBC.graph.element.closest.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element closest 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.element

package require rbc
namespace import rbc::*

namespace eval graph.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly when a closest element 
	# exists.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.1.1.Body {} {
		set coords [.graph1 transform 1 1]
		.graph1 element closest [lindex $coords 0] [lindex $coords 1] Array1
		puts [array get Array1]
		puts "dist 0.0 x 1.0 index 0 y 1.0 name Element1"
	}
	
	proc RBC.graph.element.closest.M.1.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly when a closest element 
	# does not exist.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.1.2.Body {} {
		set coords [.graph1 transform 3 3]
		puts [.graph1 element closest [lindex $coords 0] [lindex $coords 1] Array1]
		puts "0"
	}
	
	proc RBC.graph.element.closest.M.1.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly with the halo flag and a 
	# closest element exists.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.2.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.2.1.Body {} {
		set coords [.graph1 transform 1 1]
		.graph1 element closest [lindex $coords 0] [expr {[lindex $coords 1] + 8}] Array1 -halo 10
		puts [array get Array1]
		puts "dist 0.0 x 1.0 index 0 y 1.0 name Element1"
	}
	
	proc RBC.graph.element.closest.M.2.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly with the halo flag and a 
	# closest element exists.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.2.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.2.2.Body {} {
		set coords [.graph1 transform 1 1]
		puts [.graph1 element closest [lindex $coords 0] [expr {[lindex $coords 1] + 12}] Array1 -halo 10]
		puts "0"
	}
	
	proc RBC.graph.element.closest.M.2.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly  when a closest element 
	# exists and 'no' is given to the interpolate flag.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.3.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.3.1.Body {} {
		set coords [.graph1 transform 1.5 1.5]
		puts [.graph1 element closest [lindex $coords 0] [lindex $coords 1] Array1 -interpolate no]
		puts "0"
	}
	
	proc RBC.graph.element.closest.M.3.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element closest command works correctly  when a closest element 
	# exists and 'yes' is given to the interpolate flag.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.closest.M.3.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.closest.M.3.2.Body {} {
		set coords [.graph1 transform 1.5 1.5]
		.graph1 element closest [lindex $coords 0] [lindex $coords 1] Array1 -interpolate yes
		puts [array get Array1]
		puts "dist 0.0 x 1.5 index 0 y 1.5 name Element1"
	}
	
	proc RBC.graph.element.closest.M.3.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
}
