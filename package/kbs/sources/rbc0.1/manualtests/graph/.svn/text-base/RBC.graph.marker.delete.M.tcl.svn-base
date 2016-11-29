# RBC.graph.marker.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker delete
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.marker

package require rbc
namespace import rbc::*

namespace eval graph.marker {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure deleting a text marker actually removes the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.delete.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.delete.M.1.1.Body {} {
		.graph1 marker delete marker1
	}
	
	proc RBC.graph.marker.delete.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure deleting multiple markers actually remove them from the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.delete.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
		.graph1 marker create text -name marker2 -coords {0.5 0.25} -text "Marker2"
	}
	
	proc RBC.graph.marker.delete.M.1.2.Body {} {
		.graph1 marker delete marker1 marker2
	}
	
	proc RBC.graph.marker.delete.M.1.2.Cleanup {} {
		destroy .graph1
	}
}
