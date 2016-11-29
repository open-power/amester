# RBC.winop.image.gradient.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image gradient 
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
	# Purpose: Ensure the changes function of the winop component works correctly for
	# linear types. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.gradient.M.1.1.Setup {} {
		set img [image create photo -height 200 -width 200]
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.image.gradient.M.1.1.Body {} {
		set img [image create photo -height 200 -width 200]
		winop image gradient $img blue green linear
		.button1 configure -image $img
	}
	
	proc RBC.winop.image.gradient.M.1.1.Cleanup {} {
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the changes function of the winop component works correctly for
	# radial types. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.gradient.M.1.2.Setup {} {
		set img [image create photo  -height 200 -width 200]
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.image.gradient.M.1.2.Body {} {
		set img [image create photo  -height 200 -width 200]
		winop image gradient $img blue green radial
		.button1 configure -image $img
	}
	
	proc RBC.winop.image.gradient.M.1.2.Cleanup {} {
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the changes function of the winop component works correctly for
	# rectangular types. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.gradient.M.1.3.Setup {} {
		set img [image create photo  -height 200 -width 200]
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.image.gradient.M.1.3.Body {} {
		set img [image create photo  -height 200 -width 200]
		winop image gradient $img blue green rectangular
		.button1 configure -image $img
	}
	
	proc RBC.winop.image.gradient.M.1.3.Cleanup {} {
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the changes function of the winop component works correctly for
	# blank types. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.gradient.M.1.4.Setup {} {
		set img [image create photo  -height 200 -width 200]
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.image.gradient.M.1.4.Body {} {
		set img [image create photo  -height 200 -width 200]
		winop image gradient $img blue green blank
		.button1 configure -image $img
	}
	
	proc RBC.winop.image.gradient.M.1.4.Cleanup {} {
		destroy .button1
	}
}

 