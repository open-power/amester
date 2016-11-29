# RBC.winop.convolve.M.tcl --
#
###Abstract
# This file contains the manual tests that test the convolve 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.convolve

package require rbc
namespace import rbc::*

namespace eval winop.convolve {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the convolve function of the winop component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.convolve.M.1.1.Setup {} {
		set src [image create photo -file ./sample.gif]
		button .button1 -image $src
		pack .button1
	}
	
	proc RBC.winop.convolve.M.1.1.Body {} {
		set src [image create photo -file ./sample.gif]
		set dest [image create photo]
		winop convolve $src $dest {-2 -1 0 -1 1 1 0 1 2}
		.button1 configure -image $dest
	}
	
	proc RBC.winop.convolve.M.1.1.Cleanup {} {
		destroy .button1
	}
}

 