# RBC.stripchart.legend.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend bind 
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
    # Purpose: Ensure that bindings can be created for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.legend.bind.M.1.1.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.bind.M.1.1.Body {} {
        .stripchart1 legend bind Line1 <Double-1> {.stripchart1 legend activate Line1}        
    }
    
    proc RBC.stripchart.legend.bind.M.1.1.Cleanup {} {
        destroy .stripchart1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that bindings can be appended for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.legend.bind.M.1.2.Setup {} {
        stripchart .stripchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .stripchart1 element create Line1 -x $X -y $Y
        .stripchart1 legend bind Line1 <Double-1> {.stripchart1 legend activate Line1}         
        pack .stripchart1 -fill both
    }
    
    proc RBC.stripchart.legend.bind.M.1.2.Body {} {
        .stripchart1 legend bind Line1 <Double-3> {+.stripchart1 legend deactivate Line1}        
    }
    
    proc RBC.stripchart.legend.bind.M.1.2.Cleanup {} {
        destroy .stripchart1
    }    
}