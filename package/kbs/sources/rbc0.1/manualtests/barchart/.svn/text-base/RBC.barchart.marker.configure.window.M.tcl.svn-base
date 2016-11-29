# RBC.barchart.marker.configure.window.M.test --
#
###Abstract
# This file contains the manual tests that test the window marker configure
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
	# Purpose: Ensure configuring anchor changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.window.M.1.1.Setup {} {
		barchart .barchart1
		button .barchart1.button1 -text "Button"
		pack .barchart1
		.barchart1 marker create window -window .barchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.barchart.marker.configure.window.M.1.1.Body {} {
		.barchart1 marker configure marker1 -anchor n
	}
	
	proc RBC.barchart.marker.configure.window.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring height changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.window.M.2.1.Setup {} {
		barchart .barchart1
		button .barchart1.button1 -text "Button"
		pack .barchart1
		.barchart1 marker create window -window .barchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.barchart.marker.configure.window.M.2.1.Body {} {
		.barchart1 marker configure marker1 -height 10
	}
	
	proc RBC.barchart.marker.configure.window.M.2.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring width changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.window.M.3.1.Setup {} {
		barchart .barchart1
		button .barchart1.button1 -text "Button"
		pack .barchart1
		.barchart1 marker create window -window .barchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.barchart.marker.configure.window.M.3.1.Body {} {
		.barchart1 marker configure marker1 -width 10
	}
	
	proc RBC.barchart.marker.configure.window.M.3.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring window changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.window.M.4.1.Setup {} {
		barchart .barchart1
		button .barchart1.button1 -text "Button"
		button .barchart1.button2 -text "Test"
		pack .barchart1
		.barchart1 marker create window -window .barchart1.button1 -coords {0.1 0.1} -name marker1
	}
	
	proc RBC.barchart.marker.configure.window.M.4.1.Body {} {
		.barchart1 marker configure marker1 -window .barchart1.button2
	}
	
	proc RBC.barchart.marker.configure.window.M.4.1.Cleanup {} {
		destroy .barchart1
	}
}
