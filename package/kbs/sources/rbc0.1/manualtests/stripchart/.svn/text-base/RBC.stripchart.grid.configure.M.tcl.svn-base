# RBC.stripchart.grid.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the grid configure 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.grid

package require rbc
namespace import rbc::*

namespace eval stripchart.grid {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -color red
	}
	
	proc RBC.stripchart.grid.configure.M.1.1.Body {} {
		.stripchart1 grid configure -color blue
	}
	
	proc RBC.stripchart.grid.configure.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.2.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
	}
	
	proc RBC.stripchart.grid.configure.M.2.1.Body {} {
		.stripchart1 grid configure -dashes {10 3 5 2}
	}
	
	proc RBC.stripchart.grid.configure.M.2.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.3.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -hide no
	}
	
	proc RBC.stripchart.grid.configure.M.3.1.Body {} {
		.stripchart1 grid configure -hide yes
	}
	
	proc RBC.stripchart.grid.configure.M.3.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be show if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.3.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -hide yes
	}
	
	proc RBC.stripchart.grid.configure.M.3.2.Body {} {
		.stripchart1 grid configure -hide no
	}
	
	proc RBC.stripchart.grid.configure.M.3.2.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the linewidth of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.4.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -dashes {0}
	}
	
	proc RBC.stripchart.grid.configure.M.4.1.Body {} {
		.stripchart1 grid configure -linewidth 10
	}
	
	proc RBC.stripchart.grid.configure.M.4.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the x-axis of the grid can be set to an existing axis instance.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.5.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 axis create Axis1 -min 0 -max 3
		.stripchart1 grid on
	}
	
	proc RBC.stripchart.grid.configure.M.5.1.Body {} {
		.stripchart1 xaxis use Axis1
		.stripchart1 grid configure -mapx Axis1
	}
	
	proc RBC.stripchart.grid.configure.M.5.1.Cleanup {} {
		.stripchart1 axis delete Axis1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the y-axis of the grid can be set to an existing axis instance.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.6.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 axis create Axis1 -min 0 -max 3
		.stripchart1 grid on
	}
	
	proc RBC.stripchart.grid.configure.M.6.1.Body {} {
		.stripchart1 yaxis use Axis1
		.stripchart1 grid configure -mapy Axis1
	}
	
	proc RBC.stripchart.grid.configure.M.6.1.Cleanup {} {
		.stripchart1 axis delete Axis1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the minor tick gridlines can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.7.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -minor 1
	}
	
	proc RBC.stripchart.grid.configure.M.7.1.Body {} {
		.stripchart1 grid configure -minor 0
	}
	
	proc RBC.stripchart.grid.configure.M.7.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the minor tick gridlines can be shown if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.grid.configure.M.7.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 grid on
		.stripchart1 grid configure -minor 0
	}
	
	proc RBC.stripchart.grid.configure.M.7.2.Body {} {
		.stripchart1 grid configure -minor 1
	}
	
	proc RBC.stripchart.grid.configure.M.7.2.Cleanup {} {
		destroy .stripchart1
	}
}
