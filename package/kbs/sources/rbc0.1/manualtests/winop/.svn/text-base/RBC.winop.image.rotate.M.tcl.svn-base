# RBC.winop.image.rotate.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image rotate 
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
	# Purpose: Ensure the rotate function of the winop component works correctly when
	# given a single filter. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.rotate.M.1.1.Setup {} {
		set src [image create photo -file ./rain.gif]
		button .button1 -image $src
		pack .button1
	}
	
	proc RBC.winop.image.rotate.M.1.1.Body {} {
		set src [image create photo -file ./rain.gif]
		set dest [image create photo]
		
		winop image rotate $src $dest 90
		.button1 configure -image $dest
	}
	
	proc RBC.winop.image.rotate.M.1.1.Cleanup {} {
		destroy .button1
	}	
} 