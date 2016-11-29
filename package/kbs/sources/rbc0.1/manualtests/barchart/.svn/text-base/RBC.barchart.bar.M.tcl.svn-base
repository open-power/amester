# RBC.barchart.bar.M.tcl --
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
package provide barchart.bar

package require rbc
namespace import rbc::*

namespace eval barchart.bar {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure bar components may be added to a line barchart
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.bar.M.1.1.Setup {} {
		barchart .barchart1
		.barchart1 element create Line1 -x [list 1 2 3 4] -y [list 2 4 8 16]
		pack .barchart1
	}
	
	proc RBC.barchart.bar.M.1.1.Body {} {
		.barchart1 bar create Bar1 -x [list 1 2 3 4] -y [list 1 2 3 4]
	}
	
	proc RBC.barchart.bar.M.1.1.Cleanup {} {
		.barchart1 bar delete Bar1
		.barchart1 element delete Line1
		destroy .barchart1
	}
}
