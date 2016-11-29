# RBC.barchart.marker.configure.line.M.tcl --
#
###Abstract
# This file contains the manual tests that test the line marker configure
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
	# Purpose: Ensure configuring dashes changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.line.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.barchart.marker.configure.line.M.1.1.Body {} {
		.barchart1 marker configure marker1 -dashes {2 3 2 5 2 6}
	}
	
	proc RBC.barchart.marker.configure.line.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring fill changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.line.M.2.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.barchart.marker.configure.line.M.2.1.Body {} {
		.barchart1 marker configure marker1 -fill red
	}
	
	proc RBC.barchart.marker.configure.line.M.2.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring linewidth changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.line.M.3.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.barchart.marker.configure.line.M.3.1.Body {} {
		.barchart1 marker configure marker1 -linewidth 20
	}
	
	proc RBC.barchart.marker.configure.line.M.3.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring outline changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.line.M.4.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.barchart.marker.configure.line.M.4.1.Body {} {
		.barchart1 marker configure marker1 -outline red
	}
	
	proc RBC.barchart.marker.configure.line.M.4.1.Cleanup {} {
		destroy .barchart1
	}
	
#	# ------------------------------------------------------------------------------------
#	# Purpose: Ensure dashoffset command works
#	# ------------------------------------------------------------------------------------
#	proc RBC.barchart.marker.configure.common.M.5.1.Setup {} {
#		barchart .barchart1
#		pack .barchart1
#		.barchart1 marker create text -name Marker1 -coords {0.5 0.5} -text "Marker1"
#	}
#	
#	proc RBC.barchart.marker.configure.common.M.5.1.Body {} {
#		.barchart1 marker configure Marker1 -dashoffset 3
#	}
#	
#	proc RBC.barchart.marker.configure.common.M.5.1.Cleanup {} {
#		destroy .barchart1
#	}
}
