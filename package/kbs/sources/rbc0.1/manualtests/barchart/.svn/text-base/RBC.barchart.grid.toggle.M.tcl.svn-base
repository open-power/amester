# RBC.barchart.grid.toggle.M.tcl --
#
###Abstract
# This file contains the manual tests that test the grid on 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.grid

package require rbc
namespace import rbc::*

namespace eval barchart.grid {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be toggled on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.grid.toggle.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 grid on
	}
	
	proc RBC.barchart.grid.toggle.M.1.1.Body {} {
		.barchart1 grid toggle
	}
	
	proc RBC.barchart.grid.toggle.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be toggled on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.grid.toggle.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 grid off
	}
	
	proc RBC.barchart.grid.toggle.M.1.2.Body {} {
		.barchart1 grid toggle
	}
	
	proc RBC.barchart.grid.toggle.M.1.2.Cleanup {} {
		destroy .barchart1
	}
}
