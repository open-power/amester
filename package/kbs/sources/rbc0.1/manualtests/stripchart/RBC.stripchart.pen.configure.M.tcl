# RBC.stripchart.pen.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the pen configure 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.pen

package require rbc
namespace import rbc::*

namespace eval stripchart.pen {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the color configuration works for valid colors
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.configure.M.1.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.1.1.Body {} {
        .stripchart1 pen create Pen1 -color red
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.1.1.Cleanup {} {
        destroy .stripchart1
    }    

    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the dashes configuration works for valid dashes
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.configure.M.2.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 2]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.2.1.Body {} {
        .stripchart1 pen create Pen1 -dashes {10 2}
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.2.1.Cleanup {} {
        destroy .stripchart1
    }
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the dashes configuration works for no dashes
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.pen.configure.M.2.2.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Pen1 -dashes {10 2}        
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.2.2.Body {} {
        .stripchart1 pen configure Pen1 -dashes ""
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.2.2.Cleanup {} {
        destroy .stripchart1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the fill configuration works for valid fill colors
    # ------------------------------------------------------------------------------------     
    proc RBC.stripchart.pen.configure.M.3.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.3.1.Body {} {
        .stripchart1 pen create Pen1 -fill yellow
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.3.1.Cleanup {} {
        destroy .stripchart1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the fill configuration works for no fill
    # ------------------------------------------------------------------------------------  
    proc RBC.stripchart.pen.configure.M.3.2.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.3.2.Body {} {
        .stripchart1 pen create Pen1 -fill ""
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.3.2.Cleanup {} {
        destroy .stripchart1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the linewidth configuration works for valid linewidths
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.configure.M.4.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.4.1.Body {} {
        .stripchart1 pen create Pen1 -linewidth 10
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.4.1.Cleanup {} {
        destroy .stripchart1
    }     
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the offdash configuration works for valid offdash colors
	# DOES NOT WORK IN 8.4
    # ------------------------------------------------------------------------------------  
    proc RBC.stripchart.pen.configure.M.5.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Pen1 -dashes {10 3}
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.5.1.Body {} {
        .stripchart1 pen configure Pen1 -offdash red
    }
    
    proc RBC.stripchart.pen.configure.M.5.1.Cleanup {} {
        destroy .stripchart1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outline configuration works for valid outline colors
    # ------------------------------------------------------------------------------------    
    proc RBC.stripchart.pen.configure.M.6.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.6.1.Body {} {
        .stripchart1 pen create Pen1 -outline red
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.6.1.Cleanup {} {
        destroy .stripchart1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outline configuration works for defcolor (the same color
    # as the color configuration option)
    # ------------------------------------------------------------------------------------     
    proc RBC.stripchart.pen.configure.M.6.2.Setup {} {
        stripchart .stripchart1       
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.6.2.Body {} {
        .stripchart1 pen create Pen1 -color red         
        .stripchart1 pen configure Pen1 -outline defcolor
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.6.2.Cleanup {} {
        destroy .stripchart1
    }  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outlinewidth configuration works for valid widths
    # ------------------------------------------------------------------------------------
    proc RBC.stripchart.pen.configure.M.7.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Pen1 -outline red        
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.7.1.Body {} {
        .stripchart1 pen configure Pen1 -outlinewidth 5         
    }
    
    proc RBC.stripchart.pen.configure.M.7.1.Cleanup {} {
        destroy .stripchart1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the outlinewidth configuration works for no width
    # ------------------------------------------------------------------------------------  
    proc RBC.stripchart.pen.configure.M.7.2.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Pen1 -outline red        
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4] -pen Pen1
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.7.2.Body {} {
        .stripchart1 pen configure Pen1 -outlinewidth 0         
    }
    
    proc RBC.stripchart.pen.configure.M.7.2.Cleanup {} {
        destroy .stripchart1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the pixels configuration works for valid symbol sizes
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.configure.M.8.1.Setup {} {
        stripchart .stripchart1       
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.8.1.Body {} {
        .stripchart1 pen create Pen1 -pixels 30         
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.8.1.Cleanup {} {
        destroy .stripchart1
    }    
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the pixels configuration works for symbol size zero
    # ------------------------------------------------------------------------------------  
    proc RBC.stripchart.pen.configure.M.8.2.Setup {} {
        stripchart .stripchart1       
        .stripchart1 element create Line1 -x [list 1 2] -y [list 2 4]
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.8.2.Body {} {
        .stripchart1 pen create Pen1 -pixels 0        
        .stripchart1 element configure Line1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.8.2.Cleanup {} {
        destroy .stripchart1
    }       
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the symbol configuration works for all valid symbols
    # ------------------------------------------------------------------------------------ 
    proc RBC.stripchart.pen.configure.M.9.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 pen create Square -symbol square
        .stripchart1 pen create Circle -symbol circle
        .stripchart1 pen create Diamond -symbol diamond
        .stripchart1 pen create Plus -symbol plus
        .stripchart1 pen create Cross -symbol cross
        .stripchart1 pen create Splus -symbol splus
        .stripchart1 pen create Scross -symbol scross
        .stripchart1 pen create Triangle -symbol triangle
        .stripchart1 pen create NoSymbol -symbol none
        .stripchart1 pen create Bitmap -symbol warning -fill ""
        .stripchart1 element create Line1 -x [list 1 2 3] -y [list 1 2 3]
        .stripchart1 element create Line2 -x [list 1 2 3] -y [list 1 3 5]
        .stripchart1 element create Line3 -x [list 1 2 3] -y [list 1 4 7]
        .stripchart1 element create Line4 -x [list 1 2 3] -y [list 1 5 9]
        .stripchart1 element create Line5 -x [list 1 2 3] -y [list 1 6 11]
        .stripchart1 element create Line6 -x [list 1 2 3] -y [list 1 7 13]
        .stripchart1 element create Line7 -x [list 1 2 3] -y [list 1 8 15]
        .stripchart1 element create Line8 -x [list 1 2 3] -y [list 1 9 17]
        .stripchart1 element create Line9 -x [list 1 2 3] -y [list 1 10 19]
        .stripchart1 element create Line10 -x [list 1 2 3] -y [list 1 11 21]        
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.9.1.Body {} {     
        .stripchart1 element configure Line1 -pen Square
        .stripchart1 element configure Line2 -pen Circle
        .stripchart1 element configure Line3 -pen Diamond
        .stripchart1 element configure Line4 -pen Plus
        .stripchart1 element configure Line5 -pen Cross
        .stripchart1 element configure Line6 -pen Splus
        .stripchart1 element configure Line7 -pen Scross
        .stripchart1 element configure Line8 -pen Triangle
        .stripchart1 element configure Line9 -pen NoSymbol
        .stripchart1 element configure Line10 -pen Bitmap     
    }
    
    proc RBC.stripchart.pen.configure.M.9.1.Cleanup {} {
        destroy .stripchart1
    }    
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the xerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.10.1.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Element1 -xerror {1 2} -data {1 1 2 2}
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.10.1.Body {} {
        .stripchart1 pen create Pen1 -errorbarcolor red
        .stripchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.10.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
        destroy .stripchart1
    }
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the yerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.10.2.Setup {} {
        stripchart .stripchart1
        .stripchart1 element create Element1 -yerror {1 2} -data {1 1 2 2}
        pack .stripchart1
    }
    
    proc RBC.stripchart.pen.configure.M.10.2.Body {} {
        .stripchart1 pen create Pen1 -errorbarcolor red
        .stripchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.stripchart.pen.configure.M.10.2.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
        destroy .stripchart1
    }    

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the xerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.11.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -xerror {1 2} -data {1 1 2 2}
	}
	
	proc RBC.stripchart.pen.configure.M.11.1.Body {} {
		.stripchart1 pen create Pen1 -errorbarwidth 5
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.11.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the yerror has been
	# set using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.11.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -yerror {1 2} -data {1 1 2 2}
	}
	
	proc RBC.stripchart.pen.configure.M.11.2.Body {} {
		.stripchart1 pen create Pen1 -errorbarwidth 5
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.11.2.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element values can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.12.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 4 2 5 3 6} -label x -color blue \
			-valuefont {Arial 12}
		.stripchart1 element create Element2 -data {1 3 2 4 3 5} -label y -color red \
			-valuefont {Arial 12}
		.stripchart1 element create Element3 -data {1 2 2 3 3 4} -label both -color green \
			-valuefont {Arial 12}
		.stripchart1 element create Element4 -data {1 1 2 2 3 3} -label none -color orange
	}
	
	proc RBC.stripchart.pen.configure.M.12.1.Body {} {
		.stripchart1 pen create Pen1 -showvalues x -valuefont {Arial 12} -color blue
		.stripchart1 pen create Pen2 -showvalues y -valuefont {Arial 12} -color red
		.stripchart1 pen create Pen3 -showvalues both -valuefont {Arial 12} -color green
		.stripchart1 pen create Pen4 -showvalues none -valuefont {Arial 12} -color orange
		.stripchart1 element configure Element1 -pen Pen1
		.stripchart1 element configure Element2 -pen Pen2
		.stripchart1 element configure Element3 -pen Pen3
		.stripchart1 element configure Element4 -pen Pen4
	}
	
	proc RBC.stripchart.pen.configure.M.12.1.Cleanup {} {
		.stripchart1 pen delete Pen4
		.stripchart1 pen delete Pen3
		.stripchart1 pen delete Pen2
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element4
		.stripchart1 element delete Element3
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.13.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 9 2 10 3 11} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label n -color blue
		.stripchart1 element create Element2 -data {1 8 2 9 3 10} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label ne -color red
		.stripchart1 element create Element3 -data {1 7 2 8 3 9} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label e -color green
		.stripchart1 element create Element4 -data {1 6 2 7 3 8} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label se -color purple
		.stripchart1 element create Element5 -data {1 5 2 6 3 7} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label s -color orange
		.stripchart1 element create Element6 -data {1 4 2 5 3 6} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label sw -color yellow
		.stripchart1 element create Element7 -data {1 3 2 4 3 5} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label w -color pink
		.stripchart1 element create Element8 -data {1 2 2 3 3 4} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label nw -color brown
		.stripchart1 element create Element9 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label center -color grey -symbol splus
		.stripchart1 pen create Pen1 -valueanchor n -valuefont {Arial 12} -symbol splus -showvalues both -color blue
		.stripchart1 pen create Pen2 -valueanchor ne -valuefont {Arial 12} -symbol splus -showvalues both -color red
		.stripchart1 pen create Pen3 -valueanchor e -valuefont {Arial 12} -symbol splus -showvalues both -color green
		.stripchart1 pen create Pen4 -valueanchor se -valuefont {Arial 12} -symbol splus -showvalues both -color purple
		.stripchart1 pen create Pen5 -valueanchor s -valuefont {Arial 12} -symbol splus -showvalues both -color orange
		.stripchart1 pen create Pen6 -valueanchor sw -valuefont {Arial 12} -symbol splus -showvalues both -color yellow
		.stripchart1 pen create Pen7 -valueanchor w -valuefont {Arial 12} -symbol splus -showvalues both -color pink
		.stripchart1 pen create Pen8 -valueanchor nw -valuefont {Arial 12} -symbol splus -showvalues both -color brown
		.stripchart1 pen create Pen9 -valueanchor center -valuefont {Arial 12} -symbol splus -showvalues both -color grey
	}
	
	proc RBC.stripchart.pen.configure.M.13.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
		.stripchart1 element configure Element2 -pen Pen2
		.stripchart1 element configure Element3 -pen Pen3
		.stripchart1 element configure Element4 -pen Pen4
		.stripchart1 element configure Element5 -pen Pen5
		.stripchart1 element configure Element6 -pen Pen6
		.stripchart1 element configure Element7 -pen Pen7
		.stripchart1 element configure Element8 -pen Pen8
		.stripchart1 element configure Element9 -pen Pen9
	}
	
	proc RBC.stripchart.pen.configure.M.13.1.Cleanup {} {
		.stripchart1 pen delete Pen9
		.stripchart1 pen delete Pen8
		.stripchart1 pen delete Pen7
		.stripchart1 pen delete Pen6
		.stripchart1 pen delete Pen5
		.stripchart1 pen delete Pen4
		.stripchart1 pen delete Pen3
		.stripchart1 pen delete Pen2
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element9
		.stripchart1 element delete Element8
		.stripchart1 element delete Element7
		.stripchart1 element delete Element6
		.stripchart1 element delete Element5
		.stripchart1 element delete Element4
		.stripchart1 element delete Element3
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.14.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.stripchart1 pen create Pen1 -valuecolor red -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.stripchart.pen.configure.M.14.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.14.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element value can be rotated.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.15.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.stripchart1 pen create Pen1 -valuerotate 90 -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.stripchart.pen.configure.M.15.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.15.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.16.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.stripchart1 pen create Pen1 -valueshadow red -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.stripchart.pen.configure.M.16.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.16.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set and the
	# offset of the shadow can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.16.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.stripchart1 pen create Pen1 -valueshadow {red 5} -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.stripchart.pen.configure.M.16.2.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.16.2.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the format of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.17.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
		.stripchart1 pen create Pen1 -valueformat %f -valuefont {Arial 12} -showvalues both -symbol splus
	}
	
	proc RBC.stripchart.pen.configure.M.17.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.17.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.18.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
		.stripchart1 pen create Pen1 -valuefont Times -symbol splus -showvalues both
	}
	
	proc RBC.stripchart.pen.configure.M.18.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.18.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font and font size of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.pen.configure.M.18.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
		.stripchart1 pen create Pen1 -valuefont {Times 16} -symbol splus -showvalues both
	}
	
	proc RBC.stripchart.pen.configure.M.18.2.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.pen.configure.M.18.2.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
}
