# RBC.eps.shadow.M.tcl --
#
###Abstract
# This file contains the manual tests that test the shadow 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.shadow

package require rbc
namespace import rbc::*

namespace eval eps.shadow {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the shadow function of the eps component works correctly when only
	# given a color. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.shadow.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill red
		pack .canvas1
	}
	
	proc RBC.eps.shadow.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -shadow blue
	}
	
	proc RBC.eps.shadow.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the shadow function of the eps component works correctly when given
	# both a color and an integer value. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.shadow.M.1.2.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill red
		pack .canvas1
	}
	
	proc RBC.eps.shadow.M.1.2.Body {} {
		.canvas1 itemconfigure 1 -shadow {blue 10}
	}
	
	proc RBC.eps.shadow.M.1.2.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}