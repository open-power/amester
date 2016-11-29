# RBC.winop.query.M.tcl --
#
###Abstract
# This file contains the manual tests that test the query 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.query

package require rbc
namespace import rbc::*

namespace eval winop.query {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the query function of the winop component works correctly when the
	# pointer is over the center of a graph widget. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.query.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.winop.query.M.1.1.Body {} {
		puts "Should be:   [winop warpto .graph1]"
		puts "winop query: [winop query]"
	}
	
	proc RBC.winop.query.M.1.1.Cleanup {} {
		destroy .graph1
	}
}