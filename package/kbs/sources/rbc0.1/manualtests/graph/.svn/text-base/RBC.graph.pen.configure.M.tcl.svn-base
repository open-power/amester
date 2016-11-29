# RBC.graph.pen.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the pen configure 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.pen

package require rbc
namespace import rbc::*

namespace eval graph.pen {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the color configuration works for valid colors
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.configure.M.1.1.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.1.1.Body {} {
        .graph1 pen create Pen1 -color red
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.1.1.Cleanup {} {
        destroy .graph1
    }    

    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the dashes configuration works for valid dashes
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.configure.M.2.1.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 2]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.2.1.Body {} {
        .graph1 pen create Pen1 -dashes {10 2}
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.2.1.Cleanup {} {
        destroy .graph1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the dashes configuration works for no dashes
    # ------------------------------------------------------------------------------------
    proc RBC.graph.pen.configure.M.2.2.Setup {} {
        graph .graph1
        .graph1 pen create Pen1 -dashes {10 2}        
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.2.2.Body {} {
        .graph1 pen configure Pen1 -dashes ""
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.2.2.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the fill configuration works for valid fill colors
    # ------------------------------------------------------------------------------------     
    proc RBC.graph.pen.configure.M.3.1.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.3.1.Body {} {
        .graph1 pen create Pen1 -fill yellow
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.3.1.Cleanup {} {
        destroy .graph1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the fill configuration works for no fill
    # ------------------------------------------------------------------------------------  
    proc RBC.graph.pen.configure.M.3.2.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.3.2.Body {} {
        .graph1 pen create Pen1 -fill ""
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.3.2.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the linewidth configuration works for valid linewidths
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.configure.M.4.1.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.4.1.Body {} {
        .graph1 pen create Pen1 -linewidth 10
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.4.1.Cleanup {} {
        destroy .graph1
    }     
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the offdash configuration works for valid offdash colors
	# DOES NOT WORK IN 8.4
    # ------------------------------------------------------------------------------------  
    proc RBC.graph.pen.configure.M.5.1.Setup {} {
        graph .graph1
        .graph1 pen create Pen1 -dashes {10 3}
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.5.1.Body {} {
        .graph1 pen configure Pen1 -offdash red
    }
    
    proc RBC.graph.pen.configure.M.5.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outline configuration works for valid outline colors
    # ------------------------------------------------------------------------------------    
    proc RBC.graph.pen.configure.M.6.1.Setup {} {
        graph .graph1
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.6.1.Body {} {
        .graph1 pen create Pen1 -outline red
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.6.1.Cleanup {} {
        destroy .graph1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outline configuration works for defcolor (the same color
    # as the color configuration option)
    # ------------------------------------------------------------------------------------     
    proc RBC.graph.pen.configure.M.6.2.Setup {} {
        graph .graph1       
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.6.2.Body {} {
        .graph1 pen create Pen1 -color red         
        .graph1 pen configure Pen1 -outline defcolor
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.6.2.Cleanup {} {
        destroy .graph1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outlinewidth configuration works for valid widths
    # ------------------------------------------------------------------------------------
    proc RBC.graph.pen.configure.M.7.1.Setup {} {
        graph .graph1
        .graph1 pen create Pen1 -outline red        
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.7.1.Body {} {
        .graph1 pen configure Pen1 -outlinewidth 5         
    }
    
    proc RBC.graph.pen.configure.M.7.1.Cleanup {} {
        destroy .graph1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outlinewidth configuration works for no width
    # ------------------------------------------------------------------------------------  
    proc RBC.graph.pen.configure.M.7.2.Setup {} {
        graph .graph1
        .graph1 pen create Pen1 -outline red        
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.7.2.Body {} {
        .graph1 pen configure Pen1 -outlinewidth 0         
    }
    
    proc RBC.graph.pen.configure.M.7.2.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the pixels configuration works for valid symbol sizes
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.configure.M.8.1.Setup {} {
        graph .graph1       
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.8.1.Body {} {
        .graph1 pen create Pen1 -pixels 30         
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.8.1.Cleanup {} {
        destroy .graph1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the pixels configuration works for symbol size zero
    # ------------------------------------------------------------------------------------  
    proc RBC.graph.pen.configure.M.8.2.Setup {} {
        graph .graph1       
        .graph1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.8.2.Body {} {
        .graph1 pen create Pen1 -pixels 0        
        .graph1 element configure Line1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.8.2.Cleanup {} {
        destroy .graph1
    }       
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the symbol configuration works for all valid symbols
    # ------------------------------------------------------------------------------------ 
    proc RBC.graph.pen.configure.M.9.1.Setup {} {
        graph .graph1
        .graph1 pen create Square -symbol square
        .graph1 pen create Circle -symbol circle
        .graph1 pen create Diamond -symbol diamond
        .graph1 pen create Plus -symbol plus
        .graph1 pen create Cross -symbol cross
        .graph1 pen create Splus -symbol splus
        .graph1 pen create Scross -symbol scross
        .graph1 pen create Triangle -symbol triangle
        .graph1 pen create NoSymbol -symbol none
        .graph1 pen create Bitmap -symbol warning -fill ""
        .graph1 element create Line1 -x [list 1 2 3] -y [list 1 2 3]
        .graph1 element create Line2 -x [list 1 2 3] -y [list 1 3 5]
        .graph1 element create Line3 -x [list 1 2 3] -y [list 1 4 7]
        .graph1 element create Line4 -x [list 1 2 3] -y [list 1 5 9]
        .graph1 element create Line5 -x [list 1 2 3] -y [list 1 6 11]
        .graph1 element create Line6 -x [list 1 2 3] -y [list 1 7 13]
        .graph1 element create Line7 -x [list 1 2 3] -y [list 1 8 15]
        .graph1 element create Line8 -x [list 1 2 3] -y [list 1 9 17]
        .graph1 element create Line9 -x [list 1 2 3] -y [list 1 10 19]
        .graph1 element create Line10 -x [list 1 2 3] -y [list 1 11 21]        
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.9.1.Body {} {     
        .graph1 element configure Line1 -pen Square
        .graph1 element configure Line2 -pen Circle
        .graph1 element configure Line3 -pen Diamond
        .graph1 element configure Line4 -pen Plus
        .graph1 element configure Line5 -pen Cross
        .graph1 element configure Line6 -pen Splus
        .graph1 element configure Line7 -pen Scross
        .graph1 element configure Line8 -pen Triangle
        .graph1 element configure Line9 -pen NoSymbol
        .graph1 element configure Line10 -pen Bitmap     
    }
    
    proc RBC.graph.pen.configure.M.9.1.Cleanup {} {
        destroy .graph1
    }    
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the xerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.10.1.Setup {} {
        graph .graph1
        .graph1 element create Element1 -xerror {1 2} -data {1 1 2 2}
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.10.1.Body {} {
        .graph1 pen create Pen1 -errorbarcolor red
        .graph1 element configure Element1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.10.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
        destroy .graph1
    }
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the yerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.10.2.Setup {} {
        graph .graph1
        .graph1 element create Element1 -yerror {1 2} -data {1 1 2 2}
        pack .graph1
    }
    
    proc RBC.graph.pen.configure.M.10.2.Body {} {
        .graph1 pen create Pen1 -errorbarcolor red
        .graph1 element configure Element1 -pen Pen1
    }
    
    proc RBC.graph.pen.configure.M.10.2.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
        destroy .graph1
    }    

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the xerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.11.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -xerror {1 2} -data {1 1 2 2}
	}
	
	proc RBC.graph.pen.configure.M.11.1.Body {} {
		.graph1 pen create Pen1 -errorbarwidth 5
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.11.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the yerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.11.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -yerror {1 2} -data {1 1 2 2}
	}
	
	proc RBC.graph.pen.configure.M.11.2.Body {} {
		.graph1 pen create Pen1 -errorbarwidth 5
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.11.2.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element values can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.12.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 4 2 5 3 6} -label x -color blue \
			-valuefont {Arial 12}
		.graph1 element create Element2 -data {1 3 2 4 3 5} -label y -color red \
			-valuefont {Arial 12}
		.graph1 element create Element3 -data {1 2 2 3 3 4} -label both -color green \
			-valuefont {Arial 12}
		.graph1 element create Element4 -data {1 1 2 2 3 3} -label none -color orange
	}
	
	proc RBC.graph.pen.configure.M.12.1.Body {} {
		.graph1 pen create Pen1 -showvalues x -valuefont {Arial 12} -color blue
		.graph1 pen create Pen2 -showvalues y -valuefont {Arial 12} -color red
		.graph1 pen create Pen3 -showvalues both -valuefont {Arial 12} -color green
		.graph1 pen create Pen4 -showvalues none -valuefont {Arial 12} -color orange
		.graph1 element configure Element1 -pen Pen1
		.graph1 element configure Element2 -pen Pen2
		.graph1 element configure Element3 -pen Pen3
		.graph1 element configure Element4 -pen Pen4
	}
	
	proc RBC.graph.pen.configure.M.12.1.Cleanup {} {
		.graph1 pen delete Pen4
		.graph1 pen delete Pen3
		.graph1 pen delete Pen2
		.graph1 pen delete Pen1
		.graph1 element delete Element4
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.13.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 9 2 10 3 11} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label n -color blue
		.graph1 element create Element2 -data {1 8 2 9 3 10} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label ne -color red
		.graph1 element create Element3 -data {1 7 2 8 3 9} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label e -color green
		.graph1 element create Element4 -data {1 6 2 7 3 8} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label se -color purple
		.graph1 element create Element5 -data {1 5 2 6 3 7} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label s -color orange
		.graph1 element create Element6 -data {1 4 2 5 3 6} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label sw -color yellow
		.graph1 element create Element7 -data {1 3 2 4 3 5} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label w -color pink
		.graph1 element create Element8 -data {1 2 2 3 3 4} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label nw -color brown
		.graph1 element create Element9 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label center -color grey -symbol splus
		.graph1 pen create Pen1 -valueanchor n -valuefont {Arial 12} -symbol splus -showvalues both -color blue
		.graph1 pen create Pen2 -valueanchor ne -valuefont {Arial 12} -symbol splus -showvalues both -color red
		.graph1 pen create Pen3 -valueanchor e -valuefont {Arial 12} -symbol splus -showvalues both -color green
		.graph1 pen create Pen4 -valueanchor se -valuefont {Arial 12} -symbol splus -showvalues both -color purple
		.graph1 pen create Pen5 -valueanchor s -valuefont {Arial 12} -symbol splus -showvalues both -color orange
		.graph1 pen create Pen6 -valueanchor sw -valuefont {Arial 12} -symbol splus -showvalues both -color yellow
		.graph1 pen create Pen7 -valueanchor w -valuefont {Arial 12} -symbol splus -showvalues both -color pink
		.graph1 pen create Pen8 -valueanchor nw -valuefont {Arial 12} -symbol splus -showvalues both -color brown
		.graph1 pen create Pen9 -valueanchor center -valuefont {Arial 12} -symbol splus -showvalues both -color grey
	}
	
	proc RBC.graph.pen.configure.M.13.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
		.graph1 element configure Element2 -pen Pen2
		.graph1 element configure Element3 -pen Pen3
		.graph1 element configure Element4 -pen Pen4
		.graph1 element configure Element5 -pen Pen5
		.graph1 element configure Element6 -pen Pen6
		.graph1 element configure Element7 -pen Pen7
		.graph1 element configure Element8 -pen Pen8
		.graph1 element configure Element9 -pen Pen9
	}
	
	proc RBC.graph.pen.configure.M.13.1.Cleanup {} {
		.graph1 pen delete Pen9
		.graph1 pen delete Pen8
		.graph1 pen delete Pen7
		.graph1 pen delete Pen6
		.graph1 pen delete Pen5
		.graph1 pen delete Pen4
		.graph1 pen delete Pen3
		.graph1 pen delete Pen2
		.graph1 pen delete Pen1
		.graph1 element delete Element9
		.graph1 element delete Element8
		.graph1 element delete Element7
		.graph1 element delete Element6
		.graph1 element delete Element5
		.graph1 element delete Element4
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.14.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.graph1 pen create Pen1 -valuecolor red -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.graph.pen.configure.M.14.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.14.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element value can be rotated.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.15.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.graph1 pen create Pen1 -valuerotate 90 -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.graph.pen.configure.M.15.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.15.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.16.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.graph1 pen create Pen1 -valueshadow red -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.graph.pen.configure.M.16.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.16.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set and the
	# offset of the shadow can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.16.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.graph1 pen create Pen1 -valueshadow {red 5} -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.graph.pen.configure.M.16.2.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.16.2.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the format of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.17.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.graph1 pen create Pen1 -valueformat %f -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.graph.pen.configure.M.17.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.17.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.18.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
		.graph1 pen create Pen1 -valuefont Times -symbol splus -showvalues both
	}
	
	proc RBC.graph.pen.configure.M.18.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.18.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font and font size of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.pen.configure.M.18.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
		.graph1 pen create Pen1 -valuefont {Times 16} -symbol splus -showvalues both
	}
	
	proc RBC.graph.pen.configure.M.18.2.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.pen.configure.M.18.2.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
}
