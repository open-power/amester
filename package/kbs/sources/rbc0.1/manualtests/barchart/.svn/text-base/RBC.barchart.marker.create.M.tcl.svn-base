# RBC.barchart.marker.create.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker create
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
	# Purpose: Ensure creating a text marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.1.Body {} {
		.barchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.barchart.marker.create.M.1.1.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a line marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.2.Body {} {
		.barchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.barchart.marker.create.M.1.2.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a bitmap marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.3.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.3.Body {} {
		.barchart1 marker create bitmap -name marker1 -coords {0.5 0.5} -bitmap @greenback.xbm
	}
	
	proc RBC.barchart.marker.create.M.1.3.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a image marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.4.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.4.Body {} {
		set image [image create photo -file "buckskin.gif"]
		.barchart1 marker create image -name marker1 -coords {0.5 0.5} -image $image
	}
	
	proc RBC.barchart.marker.create.M.1.4.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a polygon marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.5.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.5.Body {} {
		.barchart1 marker create polygon -name marker1 -coords {0.5 0.5 1.0 1.0 0.5 1.0}
	}
	
	proc RBC.barchart.marker.create.M.1.5.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a window marker actually creates the marker on the barchart.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.create.M.1.6.Setup {} {
		barchart .barchart1
		button .barchart1.button1 -text "A Button!"
		pack .barchart1
	}
	
	proc RBC.barchart.marker.create.M.1.6.Body {} {
		.barchart1 marker create window -window .barchart1.button1 -coords {0.1 0.1}
	}
	
	proc RBC.barchart.marker.create.M.1.6.Cleanup {} {
		.barchart1 marker delete marker1
		destroy .barchart1
	}
}
