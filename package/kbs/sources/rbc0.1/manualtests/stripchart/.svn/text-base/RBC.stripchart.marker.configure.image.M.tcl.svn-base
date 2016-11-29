# RBC.stripchart.marker.configure.image.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image marker configure
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
	# Purpose: Ensure configuring anchor changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.configure.image.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 marker create image -name marker1 -image [image create photo -file "buckskin.gif"] -coords {0 0}
	}
	
	proc RBC.stripchart.marker.configure.image.M.1.1.Body {} {
		.stripchart1 marker configure marker1 -anchor n
	}
	
	proc RBC.stripchart.marker.configure.image.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring image changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.configure.image.M.2.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 marker create image -name marker1 -coords {0 0} -image [image create photo -file "buckskin.gif"]
	}
	
	proc RBC.stripchart.marker.configure.image.M.2.1.Body {} {
		.stripchart1 marker configure marker1 -image [image create photo -file "stopsign.gif"]
	}
	
	proc RBC.stripchart.marker.configure.image.M.2.1.Cleanup {} {
		destroy .stripchart1
	}
}
