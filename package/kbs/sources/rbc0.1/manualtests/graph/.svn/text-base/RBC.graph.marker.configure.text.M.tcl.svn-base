# RBC.graph.marker.configure.text.tcl --
#
###Abstract
# This file contains the manual tests that test the text marker configure
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
	# Purpose: Ensure anchor changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.1.1.Body {} {
		.graph1 marker configure Marker1 -anchor n
	}
	
	proc RBC.graph.marker.configure.text.1.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure background changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.2.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.2.1.Body {} {
		.graph1 marker configure Marker1 -background red
	}
	
	proc RBC.graph.marker.configure.text.2.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure font changes on screen when given a font string.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.3.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.3.1.Body {} {
		.graph1 marker configure Marker1 -font *-Helvetica-*-R-Normal-*-125-*
	}
	
	proc RBC.graph.marker.configure.text.3.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure font changes on screen when given the name of a font.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.3.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.3.2.Body {} {
		.graph1 marker configure Marker1 -font Times
	}
	
	proc RBC.graph.marker.configure.text.3.2.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure font changes on screen when given the name of a font and a size.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.3.3.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.3.3.Body {} {
		.graph1 marker configure Marker1 -font {Times 16}
	}
	
	proc RBC.graph.marker.configure.text.3.3.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure fill changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.4.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.4.1.Body {} {
		.graph1 marker configure Marker1 -fill red
	}
	
	proc RBC.graph.marker.configure.text.4.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure foreground changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.5.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.5.1.Body {} {
		.graph1 marker configure Marker1 -foreground red
	}
	
	proc RBC.graph.marker.configure.text.5.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure justify changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.6.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1\n2"
	}
	
	proc RBC.graph.marker.configure.text.6.1.Body {} {
		.graph1 marker configure Marker1 -justify left
	}
	
	proc RBC.graph.marker.configure.text.6.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure outline changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.7.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.7.1.Body {} {
		.graph1 marker configure Marker1 -outline red
	}
	
	proc RBC.graph.marker.configure.text.7.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure padx changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.8.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1" -fill red
	}
	
	proc RBC.graph.marker.configure.text.8.1.Body {} {
		.graph1 marker configure Marker1 -padx {20 30}
	}
	
	proc RBC.graph.marker.configure.text.8.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure pady changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.9.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1" -fill red
	}
	
	proc RBC.graph.marker.configure.text.9.1.Body {} {
		.graph1 marker configure Marker1 -pady {30 60}
	}
	
	proc RBC.graph.marker.configure.text.9.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure rotate changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.10.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.10.1.Body {} {
		.graph1 marker configure Marker1 -rotate 15.4
	}
	
	proc RBC.graph.marker.configure.text.10.1.Cleanup {} {
		destroy .graph1
	}
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure text changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.11.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.graph.marker.configure.text.11.1.Body {} {
		.graph1 marker configure Marker1 -text "Text"
	}
	
	proc RBC.graph.marker.configure.text.11.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the marker can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.marker.configure.text.M.12.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 marker create text -name Marker1 -text foo -coords {0.5 0.5}
	}
	
	proc RBC.graph.marker.configure.text.M.12.1.Body {} {
		.graph1 marker configure Marker1 -shadow red
	}
	
	proc RBC.graph.marker.configure.text.M.12.1.Cleanup {} {
		destroy .graph1
	}
}