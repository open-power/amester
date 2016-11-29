# RBC.stripchart.marker.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker bind
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.marker

package require rbc
namespace import rbc::*

namespace eval stripchart.marker {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure bind actions execute
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.bind.M.1.1.Setup {} {
		stripchart .stripchart1
		.stripchart1 marker create text -name marker1 -coords {0.5 0.5} -text "test"
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.bind.M.1.1.Body {} {
		.stripchart1 marker bind marker1 <Double-1> {puts test}
	}
	
	proc RBC.stripchart.marker.bind.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}
