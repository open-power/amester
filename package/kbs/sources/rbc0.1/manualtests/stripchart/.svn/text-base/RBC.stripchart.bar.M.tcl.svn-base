# RBC.stripchart.bar.M.tcl --
#
###Abstract
# Ensures that bar works with line elements, but doesn't not test bar elements
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.bar

package require rbc
namespace import rbc::*

namespace eval stripchart.bar {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure bar components may be added to a line stripchart
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.bar.M.1.1.Setup {} {
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3 4] -y [list 2 4 8 16]
		pack .stripchart1
	}
	
	proc RBC.stripchart.bar.M.1.1.Body {} {
		.stripchart1 bar create Bar1 -x [list 1 2 3 4] -y [list 1 2 3 4]
	}
	
	proc RBC.stripchart.bar.M.1.1.Cleanup {} {
		.stripchart1 bar delete Bar1
		.stripchart1 element delete Line1
		destroy .stripchart1
	}
}
