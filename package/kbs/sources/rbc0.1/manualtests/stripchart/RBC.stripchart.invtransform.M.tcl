# RBC.stripchart.invtransform.M.tcl --
#
###Abstract
# This file tests the invtransform functions that do not test properly in eclipse.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.invtransform

package require rbc
namespace import rbc::*

namespace eval stripchart.invtransform {
	set tcl_precision 12
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the invtransform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.invtransform.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.invtransform.M.1.1.Body {} {
		puts "RBC gave:  [.stripchart1 invtransform 12 25]"
		puts "Should be: -0.0765550239234 0.972392638037"
	}
	
	proc RBC.stripchart.invtransform.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}