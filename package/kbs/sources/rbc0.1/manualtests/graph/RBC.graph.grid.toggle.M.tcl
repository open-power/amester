# RBC.graph.grid.toggle.M.tcl --
#
###Abstract
# This file contains the manual tests that test the grid on 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.grid

package require rbc
namespace import rbc::*

namespace eval graph.grid {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be toggled on a graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.toggle.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
	}
	
	proc RBC.graph.grid.toggle.M.1.1.Body {} {
		.graph1 grid toggle
	}
	
	proc RBC.graph.grid.toggle.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be toggled on a graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.toggle.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid off
	}
	
	proc RBC.graph.grid.toggle.M.1.2.Body {} {
		.graph1 grid toggle
	}
	
	proc RBC.graph.grid.toggle.M.1.2.Cleanup {} {
		destroy .graph1
	}
}
