# RBC.barchart.crosshairs.on.tcl --
#
###Abstract
# This file contains the automatic tests that test the crosshairs on 
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
	# Purpose: Ensure the crosshairs can be displayed on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.crosshairs.on.M.1.1.Setup {} {
		barchart .barchart1
		Rbc_Crosshairs .barchart1
		pack .barchart1
		.barchart1 crosshairs off
	}
	
	proc RBC.barchart.crosshairs.on.M.1.1.Body {} {
		.barchart1 crosshairs on
	}
	
	proc RBC.barchart.crosshairs.on.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}
