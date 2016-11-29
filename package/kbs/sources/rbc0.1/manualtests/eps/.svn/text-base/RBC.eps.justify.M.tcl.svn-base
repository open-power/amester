# RBC.eps.justify.M.tcl --
#
###Abstract
# This file contains the manual tests that test the justify 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.justify

package require rbc
namespace import rbc::*

namespace eval eps.justify {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the justify function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.justify.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill blue -title "Title text\nwith multiple lines" -font {Times 16}
		.canvas1 create eps 20 150 -width 100 -height 100 -fill blue -title "Title text\nwith multiple lines" -font {Times 16}
		.canvas1 create eps 20 280 -width 100 -height 100 -fill blue -title "Title text\nwith multiple lines" -font {Times 16}
		pack .canvas1
	}
	
	proc RBC.eps.justify.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -justify left
		.canvas1 itemconfigure 1 -justify center
		.canvas1 itemconfigure 1 -justify right
	}
	
	proc RBC.eps.justify.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}