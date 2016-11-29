# RBC.graph.element.show.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element show 
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
	# Purpose: Ensure the element show command works correctly when given a single element
	# name.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.show.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2} -hide yes
	}
	
	proc RBC.graph.element.show.M.1.1.Body {} {
		.graph1 element show Element1
	}
	
	proc RBC.graph.element.show.M.1.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element show command works correctly when given multiple element
	# names.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.show.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2} -hide yes
		.graph1 element create Element2 -data {1 2 2 3} -hide yes
	}
	
	proc RBC.graph.element.show.M.1.2.Body {} {
		.graph1 element show {Element1 Element2}
	}
	
	proc RBC.graph.element.show.M.1.2.Cleanup {} {
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
}