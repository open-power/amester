# RBC.eps.font.M.tcl --
#
###Abstract
# This file contains the manual tests that test the font 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.font

package require rbc
namespace import rbc::*

namespace eval eps.font {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font function of the eps component works correctly when given
	# the name of a font. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.font.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100
		pack .canvas1
	}
	
	proc RBC.eps.font.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -font Times
	}
	
	proc RBC.eps.font.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font function of the eps component works correctly when given
	# the name of a font and a size. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.font.M.1.2.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100
		pack .canvas1
	}
	
	proc RBC.eps.font.M.1.2.Body {} {
		.canvas1 itemconfigure 1 -font {Times 16}
	}
	
	proc RBC.eps.font.M.1.2.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font function of the eps component works correctly when given a
	# font string. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.font.M.1.3.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100
		pack .canvas1
	}
	
	proc RBC.eps.font.M.1.3.Body {} {
		.canvas1 itemconfigure 1 -font "*-Arial-Bold-R-Normal-*-14-120-*"
	}
	
	proc RBC.eps.font.M.1.3.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}