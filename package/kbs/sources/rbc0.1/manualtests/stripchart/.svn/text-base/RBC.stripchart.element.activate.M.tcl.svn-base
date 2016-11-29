# RBC.stripchart.element.activate.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element activate 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.element

package require rbc
namespace import rbc::*

namespace eval stripchart.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element activate command works correctly when given a valid
	# element name.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.activate.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.activate.M.1.1.Body {} {
		.stripchart1 element activate Element1
	}
	
	proc RBC.stripchart.element.activate.M.1.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
}