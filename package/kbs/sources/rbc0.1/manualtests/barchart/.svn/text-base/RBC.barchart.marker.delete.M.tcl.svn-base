# RBC.barchart.marker.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker delete
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
	# Purpose: Ensure deleting a text marker actually removes the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.delete.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.barchart.marker.delete.M.1.1.Body {} {
		.barchart1 marker delete marker1
	}
	
	proc RBC.barchart.marker.delete.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure deleting multiple markers actually remove them from the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.delete.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
		.barchart1 marker create text -name marker2 -coords {0.5 0.25} -text "Marker2"
	}
	
	proc RBC.barchart.marker.delete.M.1.2.Body {} {
		.barchart1 marker delete marker1 marker2
	}
	
	proc RBC.barchart.marker.delete.M.1.2.Cleanup {} {
		destroy .barchart1
	}
}
