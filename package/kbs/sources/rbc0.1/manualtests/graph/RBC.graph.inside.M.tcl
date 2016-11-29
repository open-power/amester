# RBC.graph.inside.M.tcl --
#
###Abstract
# This file tests the inside function of the graph BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.inside

package require rbc
namespace import rbc::*

namespace eval graph.inside {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 0 for when it is outside
	# ------------------------------------------------------------------------------------
	proc RBC.graph.inside.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.inside.M.1.1.Body {} {
		.graph1 inside 30 30
	}
	
	proc RBC.graph.inside.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 1 for when it is inside the plot
	# ------------------------------------------------------------------------------------
	proc RBC.graph.inside.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.inside.M.1.2.Body {} {
		.graph1 inside 100 100
	}
	
	proc RBC.graph.inside.M.1.2.Cleanup {} {
		destroy .graph1
	}
}
