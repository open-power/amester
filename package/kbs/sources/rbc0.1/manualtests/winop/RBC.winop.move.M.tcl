# RBC.winop.move.M.tcl --
#
###Abstract
# This file contains the manual tests that test the move 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.move

package require rbc
namespace import rbc::*

namespace eval winop.move {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the move function of the winop component works correctly when given
	# positive integer coordinates. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.move.M.1.1.Setup {} {
		graph .graph1 -background blue
		graph .graph2 -background red
		pack .graph1
		pack .graph2
	}
	
	proc RBC.winop.move.M.1.1.Body {} {
		winop move .graph2 100 100
	}
	
	proc RBC.winop.move.M.1.1.Cleanup {} {
		destroy .graph2
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the move function of the winop component works correctly when given
	# negative integer coordinates. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.move.M.1.2.Setup {} {
		graph .graph1 -background blue
		graph .graph2 -background red
		pack .graph1
		pack .graph2
	}
	
	proc RBC.winop.move.M.1.2.Body {} {
		winop move .graph2 -100 -100
	}
	
	proc RBC.winop.move.M.1.2.Cleanup {} {
		destroy .graph2
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the move function of the winop component works correctly when given
	# positive decimal coordinates. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.move.M.1.3.Setup {} {
		graph .graph1 -background blue
		graph .graph2 -background red
		pack .graph1
		pack .graph2
	}
	
	proc RBC.winop.move.M.1.3.Body {} {
		winop move .graph2 100.4 100.4
	}
	
	proc RBC.winop.move.M.1.3.Cleanup {} {
		destroy .graph2
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the move function of the winop component works correctly when given
	# negative decimal coordinates. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.move.M.1.4.Setup {} {
		graph .graph1 -background blue
		graph .graph2 -background red
		pack .graph1
		pack .graph2
	}
	
	proc RBC.winop.move.M.1.4.Body {} {
		winop move .graph2 -100.4 -100.4
	}
	
	proc RBC.winop.move.M.1.4.Cleanup {} {
		destroy .graph2
		destroy .graph1
	}
}

 