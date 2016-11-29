# RBC.graph.extents.M.tcl --
#
###Abstract
# This file tests the extent function of the graph BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.extents

package require rbc
namespace import rbc::*

namespace eval graph.extents {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for leftmargin
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.1.1.Setup {} {
		graph .graph1 -leftmargin 20
		pack .graph1
	}
	
	proc RBC.graph.extents.M.1.1.Body {} {
		.graph1 extents leftmargin
	}
	
	proc RBC.graph.extents.M.1.1.Cleanup {} {
		destroy .graph1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for rightmargin
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.2.1.Setup {} {
		graph .graph1 -rightmargin 20
		pack .graph1
	}
	
	proc RBC.graph.extents.M.2.1.Body {} {
		.graph1 extents rightmargin
	}
	
	proc RBC.graph.extents.M.2.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for topmargin
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.3.1.Setup {} {
		graph .graph1 -topmargin 20
		pack .graph1
	}
	
	proc RBC.graph.extents.M.3.1.Body {} {
		.graph1 extents topmargin
	}
	
	proc RBC.graph.extents.M.3.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for bottommargin
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.4.1.Setup {} {
		graph .graph1 -bottommargin 20
		pack .graph1
	}
	
	proc RBC.graph.extents.M.4.1.Body {} {
		.graph1 extents bottommargin
	}
	
	proc RBC.graph.extents.M.4.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for plotwidth
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.5.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.extents.M.5.1.Body {} {
		.graph1 extents plotwidth
	}
	
	proc RBC.graph.extents.M.5.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the graph extents are valid for plotheight
	# ------------------------------------------------------------------------------------
	proc RBC.graph.extents.M.6.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.extents.M.6.1.Body {} {
		.graph1 extents plotheight
	}
	
	proc RBC.graph.extents.M.6.1.Cleanup {} {
		destroy .graph1
	}
}
