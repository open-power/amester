# RBC.stripchart.axis.invtransform.M.tcl --
#
###Abstract
# This file tests the axis invtransform function of the stripchart BLT component.
# Axis invtransform is an instance function of stripchart.
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
	# Purpose: Ensure the axis invtransform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.axis.invtransform.M.1.1.Setup {} {
		stripchart .stripchart1
		.stripchart1 axis create A1
	}
	
	proc RBC.stripchart.axis.invtransform.M.1.1.Body {} {
		puts [.stripchart1 axis invtransform A1 10]
		puts {The result must be -34.0}
	}
	
	proc RBC.stripchart.axis.invtransform.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}