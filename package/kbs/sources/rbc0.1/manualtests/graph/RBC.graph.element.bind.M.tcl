# RBC.graph.element.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element bind 
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
	# Purpose: Ensure the element bind command works correctly when given a tag name, an
	# event sequence, and a command.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.bind.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.bind.M.1.1.Body {} {
		.graph1 element bind Binding1 <Double-1> {.graph1 element configure Element1 -color red}
		.graph1 element configure Element1 -bindtags Binding1
	}
	
	proc RBC.graph.element.bind.M.1.1.Cleanup {} {
		destroy Binding1
		.graph1 element delete Element1
		destroy .graph1
	}
}