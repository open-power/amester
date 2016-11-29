# RBC.graph.legend.get.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend get 
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
    # Purpose: Ensure getting the current element in the legend (i.e. the one currently 
    # underneath the mouse pointer) works
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.get.M.1.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.get.M.1.1.Body {} {
        # Should return Line1
        .graph1 legend get current        
    }
    
    proc RBC.graph.legend.get.M.1.1.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that getting an element using @x,y notation works
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.get.M.2.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.get.M.2.1.Body {} {
        # Should return Line1
        .graph1 legend get @450,20        
    }
    
    proc RBC.graph.legend.get.M.2.1.Cleanup {} {
        destroy .graph1
    }   
}