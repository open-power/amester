# RBC.stripchart.marker.configure.window.M.test --
#
###Abstract
# This file contains the manual tests that test the window marker configure
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
	proc RBC.stripchart.marker.configure.window.M.1.1.Setup {} {
		stripchart .stripchart1
		button .stripchart1.button1 -text "Button"
		pack .stripchart1
		.stripchart1 marker create window -window .stripchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.stripchart.marker.configure.window.M.1.1.Body {} {
		.stripchart1 marker configure marker1 -anchor n
	}
	
	proc RBC.stripchart.marker.configure.window.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring height changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.configure.window.M.2.1.Setup {} {
		stripchart .stripchart1
		button .stripchart1.button1 -text "Button"
		pack .stripchart1
		.stripchart1 marker create window -window .stripchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.stripchart.marker.configure.window.M.2.1.Body {} {
		.stripchart1 marker configure marker1 -height 10
	}
	
	proc RBC.stripchart.marker.configure.window.M.2.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring width changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.configure.window.M.3.1.Setup {} {
		stripchart .stripchart1
		button .stripchart1.button1 -text "Button"
		pack .stripchart1
		.stripchart1 marker create window -window .stripchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.stripchart.marker.configure.window.M.3.1.Body {} {
		.stripchart1 marker configure marker1 -width 10
	}
	
	proc RBC.stripchart.marker.configure.window.M.3.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring window changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.marker.configure.window.M.4.1.Setup {} {
		stripchart .stripchart1
		button .stripchart1.button1 -text "Button"
		button .stripchart1.button2 -text "Test"
		pack .stripchart1
		.stripchart1 marker create window -window .stripchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.stripchart.marker.configure.window.M.4.1.Body {} {
		.stripchart1 marker configure marker1 -window .stripchart1.button2
	}
	
	proc RBC.stripchart.marker.configure.window.M.4.1.Cleanup {} {
		destroy .stripchart1
	}
}
