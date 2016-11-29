# RBC.barchart.grid.off.tcl --
#
###Abstract
# This file contains the manual tests that test the grid off 
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
	# Purpose: Ensure the grid can be hidden on a barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.grid.off.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 grid on
	}
	
	proc RBC.barchart.grid.off.M.1.1.Body {} {
		.barchart1 grid off
	}
	
	proc RBC.barchart.grid.off.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}
