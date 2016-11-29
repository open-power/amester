# RBC.barchart.extents.M.tcl --
#
###Abstract
# This file tests the extent function of the barchart BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.extents

package require rbc
namespace import rbc::*

namespace eval barchart.extents {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for leftmargin
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.1.1.Setup {} {
		barchart .barchart1 -leftmargin 20
	}
	
	proc RBC.barchart.extents.M.1.1.Body {} {
		.barchart1 extents leftmargin
	}
	
	proc RBC.barchart.extents.M.1.1.Cleanup {} {
		destroy .barchart1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for rightmargin
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.2.1.Setup {} {
		barchart .barchart1 -rightmargin 20
	}
	
	proc RBC.barchart.extents.M.2.1.Body {} {
		.barchart1 extents rightmargin
	}
	
	proc RBC.barchart.extents.M.2.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for topmargin
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.3.1.Setup {} {
		barchart .barchart1 -topmargin 20
	}
	
	proc RBC.barchart.extents.M.3.1.Body {} {
		.barchart1 extents topmargin
	}
	
	proc RBC.barchart.extents.M.3.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for bottommargin
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.4.1.Setup {} {
		barchart .barchart1 -bottommargin 20
	}
	
	proc RBC.barchart.extents.M.4.1.Body {} {
		.barchart1 extents bottommargin
	}
	
	proc RBC.barchart.extents.M.4.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for plotwidth
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.5.1.Setup {} {
		barchart .barchart1
	}
	
	proc RBC.barchart.extents.M.5.1.Body {} {
		.barchart1 extents plotwidth
	}
	
	proc RBC.barchart.extents.M.5.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the barchart extents are valid for plotheight
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.extents.M.6.1.Setup {} {
		barchart .barchart1
	}
	
	proc RBC.barchart.extents.M.6.1.Body {} {
		.barchart1 extents plotheight
	}
	
	proc RBC.barchart.extents.M.6.1.Cleanup {} {
		destroy .barchart1
	}
}
