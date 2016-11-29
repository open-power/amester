# RBC.barchart.axis.transform.M.tcl --
#
###Abstract
# This file tests the axis transform function of the barchart BLT component.
# Axis transform is an instance function of barchart.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.axis

package require rbc
namespace import rbc::*

namespace eval barchart.axis {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis transform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.axis.transform.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.axis.transform.M.1.1.Body {} {
		puts [.barchart1 axis transform x 10]
		puts {The result must be 54.}
	}
	
	proc RBC.barchart.axis.transform.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}