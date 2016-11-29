# RBC.eps.relief.M.tcl --
#
###Abstract
# This file contains the manual tests that test the relief 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.relief

package require rbc
namespace import rbc::*

namespace eval eps.relief {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the relief function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.relief.M.1.1.Setup {} {
		canvas .canvas1 -height 400 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill blue -borderwidth 10
		.canvas1 create eps 20 150 -width 100 -height 100 -fill red -borderwidth 10
		.canvas1 create eps 20 280 -width 100 -height 100 -fill green -borderwidth 10
		.canvas1 create eps 180 20 -width 100 -height 100 -fill purple -borderwidth 10
		.canvas1 create eps 180 150 -width 100 -height 100 -fill orange -borderwidth 10
		.canvas1 create eps 180 280 -width 100 -height 100 -fill yellow -borderwidth 10
		pack .canvas1
	}
	
	proc RBC.eps.relief.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -relief raised
		.canvas1 itemconfigure 2 -relief flat
		.canvas1 itemconfigure 3 -relief groove
		.canvas1 itemconfigure 4 -relief ridge
		.canvas1 itemconfigure 5 -relief solid
		.canvas1 itemconfigure 6 -relief sunken
	}
	
	proc RBC.eps.relief.M.1.1.Cleanup {} {
		.canvas1 delete 1 2 3 4 5 6
		destroy .canvas1
	}
}