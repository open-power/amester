# RBC.graph.axis.transform.M.tcl --
#
###Abstract
# This file tests the axis transform function of the graph BLT component.
# Axis transform is an instance function of graph.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.axis

package require rbc
namespace import rbc::*

namespace eval graph.axis {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis transform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.transform.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.transform.M.1.1.Body {} {
		puts [.graph1 axis transform x 10]
		puts {The result must be 54.}
	}
	
	proc RBC.graph.axis.transform.M.1.1.Cleanup {} {
		destroy .graph1
	}
}