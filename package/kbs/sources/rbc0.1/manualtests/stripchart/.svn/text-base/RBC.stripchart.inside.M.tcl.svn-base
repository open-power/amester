# RBC.stripchart.inside.M.tcl --
#
###Abstract
# This file tests the inside function of the stripchart BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.inside

package require rbc
namespace import rbc::*

namespace eval stripchart.inside {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 0 for when it is outside
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.inside.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.inside.M.1.1.Body {} {
		.stripchart1 inside 30 30
	}
	
	proc RBC.stripchart.inside.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 1 for when it is inside the plot
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.inside.M.1.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.inside.M.1.2.Body {} {
		.stripchart1 inside 100 100
	}
	
	proc RBC.stripchart.inside.M.1.2.Cleanup {} {
		destroy .stripchart1
	}
}
