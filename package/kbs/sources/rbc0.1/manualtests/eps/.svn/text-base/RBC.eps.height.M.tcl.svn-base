# RBC.eps.height.M.tcl --
#
###Abstract
# This file contains the manual tests that test the height 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.height

package require rbc
namespace import rbc::*

namespace eval eps.height {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the height function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.height.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -fill blue
		pack .canvas1
	}
	
	proc RBC.eps.height.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -height 100
	}
	
	proc RBC.eps.height.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}