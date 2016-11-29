# RBC.winop.image.convolve.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image convolve 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.image

package require rbc
namespace import rbc::*

namespace eval winop.image {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the changes function of the winop component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.convolve.M.1.1.Setup {} {
		set src [image create photo -file ./sample.gif]
		button .button1 -image $src
		pack .button1
	}
	
	proc RBC.winop.image.convolve.M.1.1.Body {} {
		set src [image create photo -file ./sample.gif]
		set dest [image create photo]
		winop image convolve $src $dest {-2 -1 0 -1 1 1 0 1 2}
		.button1 configure -image $dest
	}
	
	proc RBC.winop.image.convolve.M.1.1.Cleanup {} {
		destroy .button1
	}
}

 