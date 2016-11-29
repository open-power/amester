# RBC.barchart.legend.activate.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend activate 
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
    # Purpose: Ensure that activating all legend elements works properly.
    # ------------------------------------------------------------------------------------     
    proc RBC.barchart.legend.activate.M.1.1.Setup {} {
        barchart .barchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .barchart1 element create Line1 -x $X -y $Y
        .barchart1 element create Line2 -x $Y -y $X
        pack .barchart1 -fill both
    }
    
    proc RBC.barchart.legend.activate.M.1.1.Body {} {
        .barchart1 legend activate *
    }
    
    proc RBC.barchart.legend.activate.M.1.1.Cleanup {} {
        destroy .barchart1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that activating a subset of legend elements works properly.
    # ------------------------------------------------------------------------------------
    proc RBC.barchart.legend.activate.M.1.2.Setup {} {
        barchart .barchart1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .barchart1 element create Line1 -x $X -y $Y
        .barchart1 element create Line2 -x $Y -y $X
        pack .barchart1 -fill both
    }
    
    proc RBC.barchart.legend.activate.M.1.2.Body {} {
        .barchart1 legend activate Line1
    }
    
    proc RBC.barchart.legend.activate.M.1.2.Cleanup {} {
        destroy .barchart1
    }     
}