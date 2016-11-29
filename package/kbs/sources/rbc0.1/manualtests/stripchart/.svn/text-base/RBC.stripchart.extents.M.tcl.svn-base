# RBC.stripchart.extents.M.tcl --
#
###Abstract
# This file tests the extent function of the stripchart BLT Component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.extents

package require rbc
namespace import rbc::*

namespace eval stripchart.extents {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for leftmargin
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.1.1.Setup {} {
		stripchart .stripchart1 -leftmargin 20
	}
	
	proc RBC.stripchart.extents.M.1.1.Body {} {
		.stripchart1 extents leftmargin
	}
	
	proc RBC.stripchart.extents.M.1.1.Cleanup {} {
		destroy .stripchart1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for rightmargin
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.2.1.Setup {} {
		stripchart .stripchart1 -rightmargin 20
	}
	
	proc RBC.stripchart.extents.M.2.1.Body {} {
		.stripchart1 extents rightmargin
	}
	
	proc RBC.stripchart.extents.M.2.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for topmargin
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.3.1.Setup {} {
		stripchart .stripchart1 -topmargin 20
	}
	
	proc RBC.stripchart.extents.M.3.1.Body {} {
		.stripchart1 extents topmargin
	}
	
	proc RBC.stripchart.extents.M.3.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for bottommargin
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.4.1.Setup {} {
		stripchart .stripchart1 -bottommargin 20
	}
	
	proc RBC.stripchart.extents.M.4.1.Body {} {
		.stripchart1 extents bottommargin
	}
	
	proc RBC.stripchart.extents.M.4.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for plotwidth
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.5.1.Setup {} {
		stripchart .stripchart1
	}
	
	proc RBC.stripchart.extents.M.5.1.Body {} {
		.stripchart1 extents plotwidth
	}
	
	proc RBC.stripchart.extents.M.5.1.Cleanup {} {
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the stripchart extents are valid for plotheight
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.extents.M.6.1.Setup {} {
		stripchart .stripchart1
	}
	
	proc RBC.stripchart.extents.M.6.1.Body {} {
		.stripchart1 extents plotheight
	}
	
	proc RBC.stripchart.extents.M.6.1.Cleanup {} {
		destroy .stripchart1
	}
}
