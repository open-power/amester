# RBC.winop.snap.M.tcl --
#
###Abstract
# This file contains the manual tests that test the snap 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.snap

package require rbc
namespace import rbc::*

namespace eval winop.snap {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the snap function of the winop component works correctly when given
	# an existing Tk photo image. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.snap.M.1.1.Setup {} {
		graph .graph1 -background blue
		pack .graph1
	}
	
	proc RBC.winop.snap.M.1.1.Body {} {
		set img [image create photo]
		winop snap .graph1 $img
		destroy .graph1
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.snap.M.1.1.Cleanup {} {
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the snap function of the winop component works correctly when given
	# an existing Tk photo image and a single screen distance. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.snap.M.2.1.Setup {} {
		graph .graph1 -background blue
		pack .graph1
	}
	
	proc RBC.winop.snap.M.2.1.Body {} {
		set img [image create photo]
		winop snap .graph1 $img 50
		destroy .graph1
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.snap.M.2.1.Cleanup {} {
		destroy .button1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the snap function of the winop component works correctly when given
	# an existing Tk photo image and 2 screen distances. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.snap.M.2.2.Setup {} {
		graph .graph1 -background blue
		pack .graph1
	}
	
	proc RBC.winop.snap.M.2.2.Body {} {
		set img [image create photo]
		winop snap .graph1 $img 200 200
		destroy .graph1
		button .button1 -image $img
		pack .button1
	}
	
	proc RBC.winop.snap.M.2.2.Cleanup {} {
		destroy .button1
	}
}