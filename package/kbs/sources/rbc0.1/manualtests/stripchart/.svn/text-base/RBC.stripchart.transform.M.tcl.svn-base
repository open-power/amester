# RBC.stripchart.transform.1.tcl --
#
###Abstract
# This file tests the transform functions that do not test properly in eclipse.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.transform

package require rbc
namespace import rbc::*

namespace eval stripchart.transform {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure transform works as specified
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.transform.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
	}
	
	proc RBC.stripchart.transform.M.1.1.Body {} {
		puts "RBC gave:  [.stripchart1 transform 3.09330143541 5.15030674847]"
		puts "Should be: 1337 -1337"
	}
	
	proc RBC.stripchart.transform.M.1.1.Cleanup {} {
		destroy .stripchart1
	}
}
