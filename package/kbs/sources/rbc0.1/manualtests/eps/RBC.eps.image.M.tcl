# RBC.eps.image.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.image

package require rbc
namespace import rbc::*

namespace eval eps.image {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the image function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.image.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100 -fill black
		pack .canvas1
	}
	
	proc RBC.eps.image.M.1.1.Body {} {
		set img [image create photo -file ./stopsign.gif]
		.canvas1 itemconfigure 1 -image $img -showimage yes
	}
	
	proc RBC.eps.image.M.1.1.Cleanup {} {
		destroy image1
		.canvas1 delete 1
		destroy .canvas1
	}
}