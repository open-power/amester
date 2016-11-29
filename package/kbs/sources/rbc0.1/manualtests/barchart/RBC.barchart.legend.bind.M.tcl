# RBC.barchart.legend.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend bind 
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
    # Purpose: Ensure that bindings can be created for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.barchart.legend.bind.M.1.1.Setup {} {
        barchart .barchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .barchart1 element create Line1 -x $X -y $Y
        pack .barchart1 -fill both
    }
    
    proc RBC.barchart.legend.bind.M.1.1.Body {} {
        .barchart1 legend bind Line1 <Double-1> {.barchart1 legend activate Line1}        
    }
    
    proc RBC.barchart.legend.bind.M.1.1.Cleanup {} {
        destroy .barchart1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that bindings can be appended for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.barchart.legend.bind.M.1.2.Setup {} {
        barchart .barchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .barchart1 element create Line1 -x $X -y $Y
        .barchart1 legend bind Line1 <Double-1> {.barchart1 legend activate Line1}         
        pack .barchart1 -fill both
    }
    
    proc RBC.barchart.legend.bind.M.1.2.Body {} {
        .barchart1 legend bind Line1 <Double-3> {+.barchart1 legend deactivate Line1}        
    }
    
    proc RBC.barchart.legend.bind.M.1.2.Cleanup {} {
        destroy .barchart1
    }    
}