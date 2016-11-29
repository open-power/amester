# RBC.stripchart.legend.deactivate.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend deactivate 
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
    # Purpose: Ensure that deactivating all legend elements works properly.
    # ------------------------------------------------------------------------------------     
    proc RBC.stripchart.legend.deactivate.M.1.1.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        .stripchart1 element create Line2 -x $Y -y $X
        .stripchart1 legend activate *        
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.deactivate.M.1.1.Body {} {
        .stripchart1 legend deactivate *
    }
    
    proc RBC.stripchart.legend.deactivate.M.1.1.Cleanup {} {
        destroy .stripchart1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that deactivating a subset of legend elements works properly.
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.legend.deactivate.M.1.2.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        .stripchart1 element create Line2 -x $Y -y $X
        .stripchart1 legend activate *        
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.deactivate.M.1.2.Body {} {
        .stripchart1 legend deactivate Line1
    }
    
    proc RBC.stripchart.legend.deactivate.M.1.2.Cleanup {} {
        destroy .stripchart1
    }     
}