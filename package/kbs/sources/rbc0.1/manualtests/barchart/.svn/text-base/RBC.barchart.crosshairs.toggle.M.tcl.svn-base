# RBC.barchart.crosshairs.toggle.tcl --
#
###Abstract
# This file contains the automatic tests that test the crosshairs toggle 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.crosshairs

package require rbc
namespace import rbc::*

namespace eval barchart.crosshairs {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be toggled on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.crosshairs.toggle.M.1.1.Setup {} {
		barchart .barchart1
		Rbc_Crosshairs .barchart1
		pack .barchart1
		.barchart1 crosshairs on
	}
	
	proc RBC.barchart.crosshairs.toggle.M.1.1.Body {} {
		.barchart1 crosshairs toggle
	}
	
	proc RBC.barchart.crosshairs.toggle.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be toggled on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.crosshairs.toggle.M.1.2.Setup {} {
		barchart .barchart1
		Rbc_Crosshairs .barchart1
		pack .barchart1
		.barchart1 crosshairs off
	}
	
	proc RBC.barchart.crosshairs.toggle.M.1.2.Body {} {
		.barchart1 crosshairs toggle
	}
	
	proc RBC.barchart.crosshairs.toggle.M.1.2.Cleanup {} {
		destroy .barchart1
	}
}
