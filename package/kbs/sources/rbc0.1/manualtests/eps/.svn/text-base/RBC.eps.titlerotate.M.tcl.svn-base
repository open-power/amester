# RBC.eps.titlerotate.M.tcl --
#
###Abstract
# This file contains the manual tests that test the titlerotate 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.titlerotate

package require rbc
namespace import rbc::*

namespace eval eps.titlerotate {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the titlerotate function of the eps component works correctly for
	# positive values. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.titlerotate.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -fill blue -title "Title text"
		pack .canvas1
	}
	
	proc RBC.eps.titlerotate.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -titlerotate 90
	}
	
	proc RBC.eps.titlerotate.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the titlerotate function of the eps component works correctly for
	# negative values. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.titlerotate.M.1.2.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -fill blue -title "Title text"
		pack .canvas1
	}
	
	proc RBC.eps.titlerotate.M.1.2.Body {} {
		.canvas1 itemconfigure 1 -titlerotate -90
	}
	
	proc RBC.eps.titlerotate.M.1.2.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}