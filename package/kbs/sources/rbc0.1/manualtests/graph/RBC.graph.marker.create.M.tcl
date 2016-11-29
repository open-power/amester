# RBC.graph.marker.create.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker create
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
	# Purpose: Ensure creating a text marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.1.Body {} {
		.graph1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.create.M.1.1.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a line marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.2.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.2.Body {} {
		.graph1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.graph.marker.create.M.1.2.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a bitmap marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.3.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.3.Body {} {
		.graph1 marker create bitmap -name marker1 -coords {0.5 0.5} -bitmap @greenback.xbm
	}
	
	proc RBC.graph.marker.create.M.1.3.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a image marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.4.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.4.Body {} {
		set image [image create photo -file "buckskin.gif"]
		.graph1 marker create image -name marker1 -coords {0.5 0.5} -image $image
	}
	
	proc RBC.graph.marker.create.M.1.4.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a polygon marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.5.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.5.Body {} {
		.graph1 marker create polygon -name marker1 -coords {0.5 0.5 1.0 1.0 0.5 1.0}
	}
	
	proc RBC.graph.marker.create.M.1.5.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a window marker actually creates the marker on the graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.create.M.1.6.Setup {} {
		graph .graph1
		button .graph1.button1 -text "A Button!"
		pack .graph1
	}
	
	proc RBC.graph.marker.create.M.1.6.Body {} {
		.graph1 marker create window -window .graph1.button1 -coords {0.1 0.1}
	}
	
	proc RBC.graph.marker.create.M.1.6.Cleanup {} {
		.graph1 marker delete marker1
		destroy .graph1
	}
}
