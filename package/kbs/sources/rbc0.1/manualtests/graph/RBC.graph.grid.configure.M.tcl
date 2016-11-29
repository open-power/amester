# RBC.graph.grid.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the grid configure 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.grid

package require rbc
namespace import rbc::*

namespace eval graph.grid {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -color red
	}
	
	proc RBC.graph.grid.configure.M.1.1.Body {} {
		.graph1 grid configure -color blue
	}
	
	proc RBC.graph.grid.configure.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.2.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
	}
	
	proc RBC.graph.grid.configure.M.2.1.Body {} {
		.graph1 grid configure -dashes {10 3 5 2}
	}
	
	proc RBC.graph.grid.configure.M.2.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.3.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -hide no
	}
	
	proc RBC.graph.grid.configure.M.3.1.Body {} {
		.graph1 grid configure -hide yes
	}
	
	proc RBC.graph.grid.configure.M.3.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the grid can be show if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.3.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -hide yes
	}
	
	proc RBC.graph.grid.configure.M.3.2.Body {} {
		.graph1 grid configure -hide no
	}
	
	proc RBC.graph.grid.configure.M.3.2.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the linewidth of the grid can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.4.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -dashes {0}
	}
	
	proc RBC.graph.grid.configure.M.4.1.Body {} {
		.graph1 grid configure -linewidth 10
	}
	
	proc RBC.graph.grid.configure.M.4.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the x-axis of the grid can be set to an existing axis instance.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.5.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 axis create Axis1 -min 0 -max 3
		.graph1 grid on
	}
	
	proc RBC.graph.grid.configure.M.5.1.Body {} {
		.graph1 xaxis use Axis1
		.graph1 grid configure -mapx Axis1
	}
	
	proc RBC.graph.grid.configure.M.5.1.Cleanup {} {
		.graph1 axis delete Axis1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the y-axis of the grid can be set to an existing axis instance.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.6.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 axis create Axis1 -min 0 -max 3
		.graph1 grid on
	}
	
	proc RBC.graph.grid.configure.M.6.1.Body {} {
		.graph1 yaxis use Axis1
		.graph1 grid configure -mapy Axis1
	}
	
	proc RBC.graph.grid.configure.M.6.1.Cleanup {} {
		.graph1 axis delete Axis1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the minor tick gridlines can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.7.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -minor 1
	}
	
	proc RBC.graph.grid.configure.M.7.1.Body {} {
		.graph1 grid configure -minor 0
	}
	
	proc RBC.graph.grid.configure.M.7.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the minor tick gridlines can be shown if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.grid.configure.M.7.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 grid on
		.graph1 grid configure -minor 0
	}
	
	proc RBC.graph.grid.configure.M.7.2.Body {} {
		.graph1 grid configure -minor 1
	}
	
	proc RBC.graph.grid.configure.M.7.2.Cleanup {} {
		destroy .graph1
	}
}
