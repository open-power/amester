# RBC.graph.transform.1.tcl --
#
###Abstract
# This file tests the transform functions that do not test properly in eclipse.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.transform

package require rbc
namespace import rbc::*

namespace eval graph.transform {
	set tcl_precision 12
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure transform works as specified.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.transform.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.transform.M.1.1.Body {} {
		puts "RBC gave:  [.graph1 transform 3.09330143541 5.15030674847]"
		puts "Should be: 1337 -1337"
	}
	
	proc RBC.graph.transform.M.1.1.Cleanup {} {
		destroy .graph1
	}
}
