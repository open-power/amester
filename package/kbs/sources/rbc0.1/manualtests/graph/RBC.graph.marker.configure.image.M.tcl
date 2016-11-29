# RBC.graph.marker.configure.image.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image marker configure
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
	# Purpose: Ensure configuring anchor changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.image.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create image -name marker1 -image [image create photo -file "buckskin.gif"] -coords {0 0}
	}
	
	proc RBC.graph.marker.configure.image.M.1.1.Body {} {
		.graph1 marker configure marker1 -anchor n
	}
	
	proc RBC.graph.marker.configure.image.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring image changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.image.M.2.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create image -name marker1 -coords {0 0} -image [image create photo -file "buckskin.gif"]
	}
	
	proc RBC.graph.marker.configure.image.M.2.1.Body {} {
		.graph1 marker configure marker1 -image [image create photo -file "stopsign.gif"]
	}
	
	proc RBC.graph.marker.configure.image.M.2.1.Cleanup {} {
		destroy .graph1
	}
}
