# RBC.stripchart.pen.delete.M.tcl --
#
###Abstract
# This file contains the manual tests that test the pen delete 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.pen

package require rbc
namespace import rbc::*

namespace eval stripchart.pen {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure deleting a pen does not affect elements using the pen
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.delete.M.1.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Pen1 -color red
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.delete.M.1.1.Body {} {
        .stripchart1 pen delete Pen1
    }
    
    proc RBC.stripchart.pen.delete.M.1.1.Cleanup {} {
        destroy .stripchart1
    }       
}
