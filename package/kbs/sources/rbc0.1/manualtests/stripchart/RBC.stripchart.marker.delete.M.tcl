# RBC.stripchart.marker.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker delete
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
	# Purpose: Ensure deleting a text marker actually removes the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.delete.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.stripchart.marker.delete.M.1.1.Body {} {
		.stripchart1 marker delete marker1
	}
	
	proc RBC.stripchart.marker.delete.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure deleting multiple markers actually remove them from the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.delete.M.1.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
		.stripchart1 marker create text -name marker2 -coords {0.5 0.25} -text "Marker2"
	}
	
	proc RBC.stripchart.marker.delete.M.1.2.Body {} {
		.stripchart1 marker delete marker1 marker2
	}
	
	proc RBC.stripchart.marker.delete.M.1.2.Cleanup {} {
		destroy .stripchart1
	}
}
