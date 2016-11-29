# RBC.stripchart.axis.transform.M.tcl --
#
###Abstract
# This file tests the axis transform function of the stripchart BLT component.
# Axis transform is an instance function of stripchart.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.axis

package require rbc
namespace import rbc::*

namespace eval stripchart.axis {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis transform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.axis.transform.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.axis.transform.M.1.1.Body {} {
		puts [.stripchart1 axis transform x 10]
		puts {The result must be 54.}
	}
	
	proc RBC.stripchart.axis.transform.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}