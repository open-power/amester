# RBC.winop.warpto.M.tcl --
#
###Abstract
# This file contains the manual tests that test the warpto 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.warpto

package require rbc
namespace import rbc::*

namespace eval winop.warpto {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the warpto function of the winop component works correctly when the
	# pointer is over the center of a graph widget. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.warpto.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.winop.warpto.M.1.1.Body {} {
		winop warpto .graph1
	}
	
	proc RBC.winop.warpto.M.1.1.Cleanup {} {
		destroy .graph1
	}
}