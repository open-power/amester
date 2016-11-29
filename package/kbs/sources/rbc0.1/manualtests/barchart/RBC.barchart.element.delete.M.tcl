# RBC.barchart.element.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element delete 
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
	# Purpose: Ensure the element delete command works correctly when given a single
	# element name.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.delete.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.barchart.element.delete.M.1.1.Body {} {
		.barchart1 element delete Element1
	}
	
	proc RBC.barchart.element.delete.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element delete command works correctly when given multiple
	# element names.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.element.delete.M.1.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}
		.barchart1 element create Element2 -data {1 2 2 3}
	}
	
	proc RBC.barchart.element.delete.M.1.2.Body {} {
		.barchart1 element delete Element1 Element2
	}
	
	proc RBC.barchart.element.delete.M.1.2.Cleanup {} {
		destroy .barchart1
	}
}