# RBC.stripchart.crosshairs.toggle.tcl --
#
###Abstract
# This file contains the automatic tests that test the crosshairs toggle 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.crosshairs

package require rbc
namespace import rbc::*

namespace eval stripchart.crosshairs {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be toggled on a stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.toggle.M.1.1.Setup {} {
		stripchart .stripchart1
		Rbc_Crosshairs .stripchart1
		pack .stripchart1
		.stripchart1 crosshairs on
	}
	
	proc RBC.stripchart.crosshairs.toggle.M.1.1.Body {} {
		.stripchart1 crosshairs toggle
	}
	
	proc RBC.stripchart.crosshairs.toggle.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be toggled on a stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.toggle.M.1.2.Setup {} {
		stripchart .stripchart1
		Rbc_Crosshairs .stripchart1
		pack .stripchart1
		.stripchart1 crosshairs off
	}
	
	proc RBC.stripchart.crosshairs.toggle.M.1.2.Body {} {
		.stripchart1 crosshairs toggle
	}
	
	proc RBC.stripchart.crosshairs.toggle.M.1.2.Cleanup {} {
		destroy .stripchart1
	}
}
