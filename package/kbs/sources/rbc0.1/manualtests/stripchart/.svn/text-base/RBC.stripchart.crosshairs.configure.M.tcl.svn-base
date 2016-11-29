# RBC.stripchart.crosshairs.configure.M.tcl --
#
###Abstract
# This file contains the automatic tests that test the crosshairs configure 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.crosshairs

package require rbc
namespace import rbc::*

namespace eval stripchart.crosshairs {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the crosshairs can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
		.stripchart1 crosshairs configure -color red
	}
	
	proc RBC.stripchart.crosshairs.configure.M.1.1.Body {} {
		.stripchart1 crosshairs configure -color blue
	}
	
	proc RBC.stripchart.crosshairs.configure.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the crosshairs can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.2.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
	}
	
	proc RBC.stripchart.crosshairs.configure.M.2.1.Body {} {
		.stripchart1 crosshairs configure -dashes {10 3 5 2}
	}
	
	proc RBC.stripchart.crosshairs.configure.M.2.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.3.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
		.stripchart1 crosshairs configure -hide no
	}
	
	proc RBC.stripchart.crosshairs.configure.M.3.1.Body {} {
		.stripchart1 crosshairs configure -hide yes
	}
	
	proc RBC.stripchart.crosshairs.configure.M.3.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the crosshairs can be show if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.3.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
		.stripchart1 crosshairs configure -hide yes
	}
	
	proc RBC.stripchart.crosshairs.configure.M.3.2.Body {} {
		.stripchart1 crosshairs configure -hide no
	}
	
	proc RBC.stripchart.crosshairs.configure.M.3.2.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the linewidth of the crosshairs can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.4.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
	}
	
	proc RBC.stripchart.crosshairs.configure.M.4.1.Body {} {
		.stripchart1 crosshairs configure -linewidth 20
	}
	
	proc RBC.stripchart.crosshairs.configure.M.4.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the position of the crosshairs can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.crosshairs.configure.M.5.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		Rbc_Crosshairs .stripchart1
	}
	
	proc RBC.stripchart.crosshairs.configure.M.5.1.Body {} {
		.stripchart1 crosshairs configure -position @0.5,0.8
	}
	
	proc RBC.stripchart.crosshairs.configure.M.5.1.Cleanup {} {
		destroy .stripchart1
	}
}
