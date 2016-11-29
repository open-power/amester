# RBC.graph.marker.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker bind
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
	# Purpose: Ensure bind actions execute
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.bind.M.1.1.Setup {} {
		graph .graph1
		.graph1 marker create text -name marker1 -coords {0.5 0.5} -text "test"
		pack .graph1
	}
	
	proc RBC.graph.marker.bind.M.1.1.Body {} {
		.graph1 marker bind marker1 <Double-1> {puts test}
	}
	
	proc RBC.graph.marker.bind.M.1.1.Cleanup {} {
		destroy .graph1
	}
}
