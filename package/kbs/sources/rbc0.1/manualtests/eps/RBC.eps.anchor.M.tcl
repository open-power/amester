# RBC.eps.anchor.M.tcl --
#
###Abstract
# This file contains the manual tests that test the anchor 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.anchor

package require rbc
namespace import rbc::*

namespace eval eps.anchor {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.anchor.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 150 10 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 40 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 70 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 100 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 130 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 160 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 190 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 220 -width 10 -height 10 -fill blue -anchor center
		.canvas1 create eps 150 250 -width 10 -height 10 -fill blue -anchor center
		pack .canvas1
	}
	
	proc RBC.eps.anchor.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -anchor n
		.canvas1 itemconfigure 2 -anchor ne
		.canvas1 itemconfigure 3 -anchor e
		.canvas1 itemconfigure 4 -anchor se
		.canvas1 itemconfigure 5 -anchor s
		.canvas1 itemconfigure 6 -anchor sw
		.canvas1 itemconfigure 7 -anchor w
		.canvas1 itemconfigure 8 -anchor nw
		.canvas1 itemconfigure 9 -anchor center
	}
	
	proc RBC.eps.anchor.M.1.1.Cleanup {} {
		.canvas1 delete 1 2 3 4 5 6 7 8 9
		destroy .canvas1
	}
}

 