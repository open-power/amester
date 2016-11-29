# RBC.stripchart.legend.get.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend get 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.legend

package require rbc
namespace import rbc::*

namespace eval stripchart.legend {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure getting the current element in the legend (i.e. the one currently 
    # underneath the mouse pointer) works
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.legend.get.M.1.1.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.get.M.1.1.Body {} {
        # Should return Line1
        .stripchart1 legend get current        
    }
    
    proc RBC.stripchart.legend.get.M.1.1.Cleanup {} {
        destroy .stripchart1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that getting an element using @x,y notation works
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.legend.get.M.2.1.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.get.M.2.1.Body {} {
        # Should return Line1
        .stripchart1 legend get @450,20        
    }
    
    proc RBC.stripchart.legend.get.M.2.1.Cleanup {} {
        destroy .stripchart1
    }    
}