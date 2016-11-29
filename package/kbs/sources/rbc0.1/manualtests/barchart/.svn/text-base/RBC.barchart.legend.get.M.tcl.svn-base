# RBC.barchart.legend.get.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend get 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.legend

package require rbc
namespace import rbc::*

namespace eval barchart.legend {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure getting the current element in the legend (i.e. the one currently 
    # underneath the mouse pointer) works
    # ------------------------------------------------------------------------------------
    proc RBC.barchart.legend.get.M.1.1.Setup {} {
        barchart .b1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .b1 element create Bar1 -x $X -y $Y
        pack .b1 -fill both
    }
    
    proc RBC.barchart.legend.get.M.1.1.Body {} {
        # Should return Bar1
        .b1 legend get current        
    }
    
    proc RBC.barchart.legend.get.M.1.1.Cleanup {} {
        destroy .b1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that getting an element using @x,y notation works
    # ------------------------------------------------------------------------------------
    proc RBC.barchart.legend.get.M.2.1.Setup {} {
        barchart .b1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .b1 element create Bar1 -x $X -y $Y
        pack .b1 -fill both
    }
    
    proc RBC.barchart.legend.get.M.2.1.Body {} {
        # Should return Bar1
        .b1 legend get @450,20        
    }
    
    proc RBC.barchart.legend.get.M.2.1.Cleanup {} {
        destroy .b1
    }      
}