# RBC.barchart.axis.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the axis bind
# function of the barchart BLT component.
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
	# Purpose: Ensure bind actions execute
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.axis.bind.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.axis.bind.M.1.1.Body {} {
		.barchart1 axis bind x <Double-1> {puts test}
	}
	
	proc RBC.barchart.axis.bind.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}
