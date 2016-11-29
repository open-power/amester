# RBC.barchart.element.create.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element create 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.element

package require rbc
namespace import rbc::*

namespace eval barchart.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element create command works correctly when given a unique 
	# element name.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.create.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
	}
	
	proc RBC.barchart.element.create.M.1.1.Body {} {
		.barchart1 element create Element1
	}
	
	proc RBC.barchart.element.create.M.1.1.Cleanup {} {
		.barchart1 element delete Element1
		destroy .barchart1
	}
}