# RBC.graph.bar.M.tcl --
#
###Abstract
# Ensures that bar works with line elements, but doesn't not test bar elements
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.bar

package require rbc
namespace import rbc::*

namespace eval graph.bar {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure bar components may be added to a line graph
	# ------------------------------------------------------------------------------------
	proc RBC.graph.bar.M.1.1.Setup {} {
		graph .graph1
		.graph1 element create Line1 -x [list 1 2 3 4] -y [list 2 4 8 16]
		pack .graph1
	}
	
	proc RBC.graph.bar.M.1.1.Body {} {
		.graph1 bar create Bar1 -x [list 1 2 3 4] -y [list 1 2 3 4]
	}
	
	proc RBC.graph.bar.M.1.1.Cleanup {} {
		.graph1 bar delete Bar1
		.graph1 element delete Line1
		destroy .graph1
	}
}
