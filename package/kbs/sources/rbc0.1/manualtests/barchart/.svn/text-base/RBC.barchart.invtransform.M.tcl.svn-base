# RBC.barchart.invtransform.M.tcl --
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
package provide barchart.invtransform

package require rbc
namespace import rbc::*

namespace eval barchart.invtransform {
	set tcl_precision 12
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the invtransform command works correctly
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.invtransform.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.invtransform.M.1.1.Body {} {
		puts "RBC gave:  [.barchart1 invtransform 12 25]"
		puts "Should be: -0.0765550239234 0.972392638037"
	}
	
	proc RBC.barchart.invtransform.M.1.1.Cleanup {} {
		destroy .barchart1
	}
}