# RBC.graph.legend.bind.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend bind 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.legend

package require rbc
namespace import rbc::*

namespace eval graph.legend {
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that bindings can be created for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.bind.M.1.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.bind.M.1.1.Body {} {
        .graph1 legend bind Line1 <Double-1> {.graph1 legend activate Line1}        
    }
    
    proc RBC.graph.legend.bind.M.1.1.Cleanup {} {
        destroy .graph1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that bindings can be appended for a legend element.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.bind.M.1.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend bind Line1 <Double-1> {.graph1 legend activate Line1}         
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.bind.M.1.2.Body {} {
        .graph1 legend bind Line1 <Double-3> {+.graph1 legend deactivate Line1}        
    }
    
    proc RBC.graph.legend.bind.M.1.2.Cleanup {} {
        destroy .graph1
    }    
}