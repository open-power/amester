# RBC.stripchart.element.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element bind 
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
	# Purpose: Ensure the element bind command works correctly when given a tag name, an
	# event sequence, and a command.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.bind.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.bind.M.1.1.Body {} {
		.stripchart1 element bind Binding1 <Double-1> {.stripchart1 element configure Element1 -color red}
		.stripchart1 element configure Element1 -bindtags Binding1
	}
	
	proc RBC.stripchart.element.bind.M.1.1.Cleanup {} {
		destroy Binding1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
}