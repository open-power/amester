# RBC.graph.pen.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the pen delete 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.pen

package require rbc
namespace import rbc::*

namespace eval graph.pen {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure deleting a pen does not affect elements using the pen
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.delete.1.1.Setup {} {
        graph .graph1
        .graph1 pen create Pen1 -color red
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .graph1
    }
    
    proc RBC.graph.pen.delete.1.1.Body {} {
        .graph1 pen delete Pen1
    }
    
    proc RBC.graph.pen.delete.1.1.Cleanup {} {
        destroy .graph1
    }       
}
