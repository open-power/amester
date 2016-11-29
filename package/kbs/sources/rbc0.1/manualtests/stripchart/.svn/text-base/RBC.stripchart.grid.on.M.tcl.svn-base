# RBC.graph.grid.on.M.tcl --
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
	# Purpose: Ensure the grid can be displayed on a graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.on.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid off
	}
	
	proc RBC.stripchart.grid.on.M.1.1.Body {} {
		.stripchart1 grid on
	}
	
	proc RBC.stripchart.grid.on.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}
