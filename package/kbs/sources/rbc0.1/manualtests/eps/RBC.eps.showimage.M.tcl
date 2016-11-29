# RBC.eps.showimage.M.tcl --
#
###Abstract
# This file contains the manual tests that test the showimage 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.showimage

package require rbc
namespace import rbc::*

namespace eval eps.showimage {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the showimage function of the eps component works correctly when
	# given 1. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.showimage.M.1.1.Setup {} {
		set img [image create photo -file ./stopsign.gif]
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -image $img -showimage 0
		pack .canvas1
	}
	
	proc RBC.eps.showimage.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -showimage 1
	}
	
	proc RBC.eps.showimage.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the showimage function of the eps component works correctly when
	# given 0. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.showimage.M.1.2.Setup {} {
		set img [image create photo -file ./stopsign.gif]
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -image $img -showimage 1
		pack .canvas1
	}
	
	proc RBC.eps.showimage.M.1.2.Body {} {
		.canvas1 itemconfigure 1 -showimage 0
	}
	
	proc RBC.eps.showimage.M.1.2.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}