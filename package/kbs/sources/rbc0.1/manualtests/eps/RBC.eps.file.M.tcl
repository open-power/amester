# RBC.eps.file.M.tcl --
#
###Abstract
# This file contains the manual tests that test the file 
# function of the eps BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide eps.file

package require rbc
namespace import rbc::*

namespace eval eps.file {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the file function of the eps component works correctly. 
	# ------------------------------------------------------------------------------------
	proc RBC.eps.file.M.1.1.Setup {} {
		canvas .canvas1 -height 300 -width 300 -background white
		.canvas1 create eps 20 20 -width 100 -height 100
		pack .canvas1
	}
	
	proc RBC.eps.file.M.1.1.Body {} {
		.canvas1 itemconfigure 1 -file out.ps
	}
	
	proc RBC.eps.file.M.1.1.Cleanup {} {
		.canvas1 delete 1
		destroy .canvas1
	}
}