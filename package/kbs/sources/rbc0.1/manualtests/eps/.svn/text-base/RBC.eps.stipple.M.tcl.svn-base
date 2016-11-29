# RBC.eps.stipple.M.tcl --
#
###Abstract
# This file contains the manual tests that test the stipple 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.stipple

package require rbc
namespace import rbc::*

namespace eval eps.stipple {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stipple function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.stipple.M.1.1.Setup {} {
		canvas .canvas1 -height 600 -width 600 -background white
		.canvas1 create eps 0 0 -width 600 -height 600 -fill green
		pack .canvas1
	}
	
	proc RBC.eps.stipple.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -stipple @greenback.xbm
	}
	
	proc RBC.eps.stipple.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}