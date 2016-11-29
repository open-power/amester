# RBC.eps.titleanchor.M.tcl --
#
###Abstract
# This file contains the manual tests that test the titleanchor 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.titleanchor

package require rbc
namespace import rbc::*

namespace eval eps.titleanchor {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the titleanchor function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.titleanchor.M.1.1.Setup {} {
		canvas .canvas1 -height 400 -width 460 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill blue -borderwidth 10 -title "Title text"
		.canvas1 create eps 20 150 -width 100 -height 100 -fill red -borderwidth 10 -title "Title text"
		.canvas1 create eps 20 280 -width 100 -height 100 -fill green -borderwidth 10 -title "Title text"
		.canvas1 create eps 180 20 -width 100 -height 100 -fill purple -borderwidth 10 -title "Title text"
		.canvas1 create eps 180 150 -width 100 -height 100 -fill orange -borderwidth 10 -title "Title text"
		.canvas1 create eps 180 280 -width 100 -height 100 -fill yellow -borderwidth 10 -title "Title text"
		.canvas1 create eps 340 20 -width 100 -height 100 -fill brown -borderwidth 10 -title "Title text"
		.canvas1 create eps 340 150 -width 100 -height 100 -fill gray -borderwidth 10 -title "Title text"
		.canvas1 create eps 340 280 -width 100 -height 100 -fill pink -borderwidth 10 -title "Title text"
		pack .canvas1
	}
	
	proc RBC.eps.titleanchor.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -titleanchor n
		.canvas1 itemconfigure 2 -titleanchor ne
		.canvas1 itemconfigure 3 -titleanchor e
		.canvas1 itemconfigure 4 -titleanchor se
		.canvas1 itemconfigure 5 -titleanchor s
		.canvas1 itemconfigure 6 -titleanchor sw
		.canvas1 itemconfigure 7 -titleanchor w
		.canvas1 itemconfigure 8 -titleanchor nw
		.canvas1 itemconfigure 9 -titleanchor center
	}
	
	proc RBC.eps.titleanchor.M.1.1.Cleanup {} {
		.canvas1 delete 1 2 3 4 5 6 7 8 9
		destroy .canvas1
	}
}