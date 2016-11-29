# RBC.barchart.inside.M.tcl --
#
###Abstract
# This file tests the inside function of the barchart BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.inside

package require rbc
namespace import rbc::*

namespace eval barchart.inside {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 0 for when it is outside
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.inside.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.inside.M.1.1.Body {} {
		.barchart1 inside 30 30
	}
	
	proc RBC.barchart.inside.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that inside returns 1 for when it is inside the plot
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.inside.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.inside.M.1.2.Body {} {
		.barchart1 inside 100 100
	}
	
	proc RBC.barchart.inside.M.1.2.Cleanup {} {
		destroy .barchart1
	}
}
