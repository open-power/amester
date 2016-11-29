# RBC.graph.legend.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the legend configure 
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
    # Purpose: Ensure that the activebackground configuration works for valid colors.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.1.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.1.1.Body {} {
        .graph1 legend configure -activebackground salmon
    }
    
    proc RBC.graph.legend.configure.M.1.1.Cleanup {} {
        destroy .graph1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activeborderwidth configuration works for valid widths.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.2.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.2.1.Body {} {
        .graph1 legend configure -activeborderwidth 20
    }
    
    proc RBC.graph.legend.configure.M.2.1.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activeforeground configuration works for valid colors.
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.legend.configure.M.3.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.3.1.Body {} {
        .graph1 legend configure -activeforeground white
    }
    
    proc RBC.graph.legend.configure.M.3.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for raised reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.1.Body {} {
        .graph1 legend configure -activerelief raised
    }
    
    proc RBC.graph.legend.configure.M.4.1.Cleanup {} {
        destroy .graph1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for flat reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.2.Body {} {
        .graph1 legend configure -activerelief flat
    }
    
    proc RBC.graph.legend.configure.M.4.2.Cleanup {} {
        destroy .graph1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for grooved reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.3.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.3.Body {} {
        .graph1 legend configure -activerelief groove
    }
    
    proc RBC.graph.legend.configure.M.4.3.Cleanup {} {
        destroy .graph1
    }   
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for ridged reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.4.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.4.Body {} {
        .graph1 legend configure -activerelief ridge
    }
    
    proc RBC.graph.legend.configure.M.4.4.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for solid reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.5.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.5.Body {} {
        .graph1 legend configure -activerelief solid
    }
    
    proc RBC.graph.legend.configure.M.4.5.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the activerelief configuration works for sunken reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.4.6.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend activate Line1  
        .graph1 legend configure -activeborderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.4.6.Body {} {
        .graph1 legend configure -activerelief sunken
    }
    
    proc RBC.graph.legend.configure.M.4.6.Cleanup {} {
        destroy .graph1
    }   
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the anchor configuration works for all anchors.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.5.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y  
        .graph1 legend  configure -position plotarea
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.5.1.Body {} {
        .graph1 legend configure -anchor center
		sleep 1000
        .graph1 legend configure -anchor n
		sleep 1000
        .graph1 legend configure -anchor ne
		sleep 1000
        .graph1 legend configure -anchor e
		sleep 1000
        .graph1 legend configure -anchor se
		sleep 1000
        .graph1 legend configure -anchor s
		sleep 1000
        .graph1 legend configure -anchor sw
		sleep 1000
        .graph1 legend configure -anchor w
		sleep 1000
        .graph1 legend configure -anchor nw
    }
    
    proc RBC.graph.legend.configure.M.5.1.Cleanup {} {
        destroy .graph1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the background configuration works for no background.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.6.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 configure -background salmon  
        .graph1 legend configure -background gray        
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.6.1.Body {} {
        .graph1 legend configure -background ""
    }
    
    proc RBC.graph.legend.configure.M.6.1.Cleanup {} {
        destroy .graph1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the background configuration works for valid colors.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.6.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.6.2.Body {} {
        .graph1 legend configure -background black
    }
    
    proc RBC.graph.legend.configure.M.6.2.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the borderwidth configuration works for valid widths.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.7.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.7.1.Body {} {
        .graph1 legend configure -borderwidth 20
    }
    
    proc RBC.graph.legend.configure.M.7.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the font configuration works for valid font strings.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.8.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.8.1.Body {} {
        .graph1 legend configure -font "*-Arial-Bold-R-Normal-*-14-120-*" 
    }
    
    proc RBC.graph.legend.configure.M.8.1.Cleanup {} {
        destroy .graph1
    }
	
	# ------------------------------------------------------------------------------------
    # Purpose: Ensure that the font configuration works for a string.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.8.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.8.2.Body {} {
        .graph1 legend configure -font Times 
    }
    
    proc RBC.graph.legend.configure.M.8.2.Cleanup {} {
        destroy .graph1
    }
    
	# ------------------------------------------------------------------------------------
    # Purpose: Ensure that the font configuration works for a string and integer.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.8.3.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y      
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.8.3.Body {} {
        .graph1 legend configure -font {Times 12} 
    }
    
    proc RBC.graph.legend.configure.M.8.3.Cleanup {} {
        destroy .graph1
    }
	
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the foreground configuration works for valid colors.
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.legend.configure.M.9.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y  
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.9.1.Body {} {
        .graph1 legend configure -foreground white
    }
    
    proc RBC.graph.legend.configure.M.9.1.Cleanup {} {
        destroy .graph1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the hide configuration works.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.10.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.10.1.Body {} {
        .graph1 legend configure -hide true
    }
    
    proc RBC.graph.legend.configure.M.10.1.Cleanup {} {
        destroy .graph1
    }   
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the ipadx configuration works.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.11.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.11.1.Body {} {
        .graph1 legend configure -ipadx 5
    }
    
    proc RBC.graph.legend.configure.M.11.1.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the ipady configuration works.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.12.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.12.1.Body {} {
        .graph1 legend configure -ipady 5
    }
    
    proc RBC.graph.legend.configure.M.12.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the padx configuration works.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.13.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.13.1.Body {} {
        .graph1 legend configure -padx 5
    }
    
    proc RBC.graph.legend.configure.M.13.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the pady configuration works.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.14.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.14.1.Body {} {
        .graph1 legend configure -pady 5
    }
    
    proc RBC.graph.legend.configure.M.14.1.Cleanup {} {
        destroy .graph1
    }   
    # TODO position
	# TODO relief
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for raised reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.1.Body {} {
        .graph1 legend configure -relief raised
    }
    
    proc RBC.graph.legend.configure.M.15.1.Cleanup {} {
        destroy .graph1
    } 
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for flat reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.2.Body {} {
        .graph1 legend configure -relief flat
    }
    
    proc RBC.graph.legend.configure.M.15.2.Cleanup {} {
        destroy .graph1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for grooved reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.3.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.3.Body {} {
        .graph1 legend configure -relief groove
    }
    
    proc RBC.graph.legend.configure.M.15.3.Cleanup {} {
        destroy .graph1
    }   
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for ridged reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.4.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.4.Body {} {
        .graph1 legend configure -relief ridge
    }
    
    proc RBC.graph.legend.configure.M.15.4.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for solid reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.5.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.5.Body {} {
        .graph1 legend configure -relief solid
    }
    
    proc RBC.graph.legend.configure.M.15.5.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the relief configuration works for sunken reliefs.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.15.6.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y 
        .graph1 legend configure -borderwidth 10
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.15.6.Body {} {
        .graph1 legend configure -relief sunken
    }
    
    proc RBC.graph.legend.configure.M.15.6.Cleanup {} {
        destroy .graph1
    }     
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the shadow configuration works for valid colors.
    # ------------------------------------------------------------------------------------
    proc RBC.graph.legend.configure.M.16.1.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y 
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.16.1.Body {} {
        .graph1 legend configure -shadow red
    }
    
    proc RBC.graph.legend.configure.M.16.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the shadow configuration works for a shadow and a depth.
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.legend.configure.M.16.2.Setup {} {
        graph .graph1
        set X [list 1 2 3 4 5]
        set Y [list 2 4 6 8 10]
        .graph1 element create Line1 -x $X -y $Y 
        pack .graph1 -fill both
    }
    
    proc RBC.graph.legend.configure.M.16.2.Body {} {
        .graph1 legend configure -shadow {red 3}
    }
    
    proc RBC.graph.legend.configure.M.16.2.Cleanup {} {
        destroy .graph1
    }    
}