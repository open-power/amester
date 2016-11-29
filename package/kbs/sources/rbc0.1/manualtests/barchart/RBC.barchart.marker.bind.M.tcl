# RBC.barchart.marker.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker bind
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.marker

package require rbc
namespace import rbc::*

namespace eval barchart.marker {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure bind actions execute
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.bind.M.1.1.Setup {} {
		barchart .barchart1
		.barchart1 marker create text -name marker1 -coords {0.5 0.5} -text "test"
		pack .barchart1
	}
	
	proc RBC.barchart.marker.bind.M.1.1.Body {} {
		.barchart1 marker bind marker1 <Double-1> {puts test}
	}
	
	proc RBC.barchart.marker.bind.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}
