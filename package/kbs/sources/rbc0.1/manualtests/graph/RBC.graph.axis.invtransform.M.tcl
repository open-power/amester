# RBC.graph.axis.invtransform.M.tcl --
#
###Abstract
# This file tests the axis invtransform function of the graph BLT component.
# Axis invtransform is an instance function of graph.
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
	# Purpose: Ensure the axis invtransform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.invtransform.M.1.1.Setup {} {
		graph .graph1
		.graph1 axis create A1
	}
	
	proc RBC.graph.axis.invtransform.M.1.1.Body {} {
		puts [.graph1 axis invtransform A1 10]
		puts {The result must be -34.0}
	}
	
	proc RBC.graph.axis.invtransform.M.1.1.Cleanup {} {
		destroy .graph1
	}
}