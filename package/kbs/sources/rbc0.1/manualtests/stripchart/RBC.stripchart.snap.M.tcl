# RBC.stripchart.snap.M.1.tcl --
#
###Abstract
# This file tests the snap function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.snap

package require rbc
namespace import rbc::*

namespace eval stripchart.snap {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a picture and stores it as a Tk image
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.1.1.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.1.1.Body {} {
		.stripchart1 snap Line1
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.1.1.Cleanup {} {
		image delete Line1
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a set height picture and stores it as a Tk image
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.2.1.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.2.1.Body {} {
		.stripchart1 snap Line1 -height 20
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.2.1.Cleanup {} {
		image delete Line1
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a set width picture and stores it as a Tk image
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.3.1.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.3.1.Body {} {
		.stripchart1 snap Line1 -width 20
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.3.1.Cleanup {} {
		image delete Line1
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a picture and stores it as a Tk image in photo format.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.4.1.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.4.1.Body {} {
		.stripchart1 snap Line1 -format photo
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.4.1.Cleanup {} {
		image delete Line1
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a picture and stores it as a Tk image in wmf format.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.4.2.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.4.2.Body {} {
		.stripchart1 snap Line1 -format wmf
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.4.2.Cleanup {} {
		image delete Line1
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure snap takes a picture and stores it as a Tk image in emf format.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.snap.M.4.3.Setup {} {
		image create photo Line1
		button .button1 -bg red
		stripchart .stripchart1
		.stripchart1 element create Line1 -x [list 1 2 3] -y [list 2 6 18]
		pack .stripchart1
	}
	
	proc RBC.stripchart.snap.M.4.3.Body {} {
		.stripchart1 snap Line1 -format emf
		destroy .stripchart1
		.button1 configure -image Line1
		pack .button1
	}
	
	proc RBC.stripchart.snap.M.4.3.Cleanup {} {
		image delete Line1
		destroy .button1
	}
}
