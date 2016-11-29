# RBC.stripchart.marker.create.M.tcl --
#
###Abstract
# This file contains the manual tests that test the marker create
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
	# Purpose: Ensure creating a text marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.1.Body {} {
		.stripchart1 marker create text -name marker1 -coords {0.5 0.5} -text "Marker1"
	}
	
	proc RBC.stripchart.marker.create.M.1.1.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a line marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.2.Body {} {
		.stripchart1 marker create line -name marker1 -coords {0.5 0.5 1.0 1.0}
	}
	
	proc RBC.stripchart.marker.create.M.1.2.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a bitmap marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.3.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.3.Body {} {
		.stripchart1 marker create bitmap -name marker1 -coords {0.5 0.5} -bitmap @greenback.xbm
	}
	
	proc RBC.stripchart.marker.create.M.1.3.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a image marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.4.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.4.Body {} {
		set image [image create photo -file "buckskin.gif"]
		.stripchart1 marker create image -name marker1 -coords {0.5 0.5} -image $image
	}
	
	proc RBC.stripchart.marker.create.M.1.4.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a polygon marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.5.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.5.Body {} {
		.stripchart1 marker create polygon -name marker1 -coords {0.5 0.5 1.0 1.0 0.5 1.0}
	}
	
	proc RBC.stripchart.marker.create.M.1.5.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure creating a window marker actually creates the marker on the stripchart.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.create.M.1.6.Setup {} {
		stripchart .stripchart1
		button .stripchart1.button1 -text "A Button!"
		pack .stripchart1
	}
	
	proc RBC.stripchart.marker.create.M.1.6.Body {} {
		.stripchart1 marker create window -window .stripchart1.button1 -coords {0.1 0.1}
	}
	
	proc RBC.stripchart.marker.create.M.1.6.Cleanup {} {
		.stripchart1 marker delete marker1
		destroy .stripchart1
	}
}
