# RBC.graph.crosshairs.on.tcl --
#
###Abstract
# This file contains the automatic tests that test the crosshairs on 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.crosshairs

package require rbc
namespace import rbc::*

namespace eval graph.crosshairs {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be displayed on a graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.crosshairs.on.M.1.1.Setup {} {
		graph .graph1
		Rbc_Crosshairs .graph1
		pack .graph1
		.graph1 crosshairs off
	}
	
	proc RBC.graph.crosshairs.on.M.1.1.Body {} {
		.graph1 crosshairs on
	}
	
	proc RBC.graph.crosshairs.on.M.1.1.Cleanup {} {
		destroy .graph1
	}
}
