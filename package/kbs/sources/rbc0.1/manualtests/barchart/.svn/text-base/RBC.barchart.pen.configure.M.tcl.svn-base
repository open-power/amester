# RBC.barchart.pen.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the pen configure 
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.pen

package require rbc
namespace import rbc::*

namespace eval barchart.pen {    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the background configuration works for valid colors
    # ------------------------------------------------------------------------------------ 
    proc RBC.barchart.pen.configure.M.1.1.Setup {} {
        barchart .barchart1
        .barchart1 element create Element1 -x [list 1 2] -y [list 2 4]
        pack .barchart1
    }
    
    proc RBC.barchart.pen.configure.M.1.1.Body {} {
        .barchart1 pen create Pen1 -background red
        .barchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.barchart.pen.configure.M.1.1.Cleanup {} {
        destroy .barchart1
    }    

    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the borderwidth can be set given a valid integer
    # ------------------------------------------------------------------------------------ 
    proc RBC.barchart.pen.configure.M.2.1.Setup {} {
        barchart .barchart1
        .barchart1 element create Element1 -data {1 1 2 2}
        pack .barchart1
    }
    
    proc RBC.barchart.pen.configure.M.2.1.Body {} {
        .barchart1 pen create Pen1 -borderwidth 10
        .barchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.barchart.pen.configure.M.2.1.Cleanup {} {
		.barchart1 pen delete Pen1
        destroy .barchart1
    }
 	
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the foreground configuration works for valid foreground colors
    # ------------------------------------------------------------------------------------     
    proc RBC.barchart.pen.configure.M.3.1.Setup {} {
        barchart .barchart1
        .barchart1 element create Element1 -x [list 1 2] -y [list 2 4]
        pack .barchart1
    }
    
    proc RBC.barchart.pen.configure.M.3.1.Body {} {
        .barchart1 pen create Pen1 -foreground yellow
        .barchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.barchart.pen.configure.M.3.1.Cleanup {} {
        destroy .barchart1
    }      
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the foreground configuration works for no foreground
    # ------------------------------------------------------------------------------------  
    proc RBC.barchart.pen.configure.M.3.2.Setup {} {
        barchart .barchart1
        .barchart1 element create Element1 -x [list 1 2] -y [list 2 4]
        pack .barchart1
    }
    
    proc RBC.barchart.pen.configure.M.3.2.Body {} {
        .barchart1 pen create Pen1 -foreground ""
        .barchart1 element configure Element1 -pen Pen1
    }
    
    proc RBC.barchart.pen.configure.M.3.2.Cleanup {} {
        destroy .barchart1
    }    
    
    # ------------------------------------------------------------------------------------
	# Purpose: Ensure the label relief of the element in the legend can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.4.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2 3 3}
		.barchart1 element create Element2 -data {1 3 2 4 3 5}
	}
	
	proc RBC.barchart.pen.configure.M.4.1.Body {} {
		.barchart1 pen create Pen1 -relief groove
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.4.1.Cleanup {} {
		.barchart1 element delete Element2
		.barchart1 element delete Element1
		destroy .barchart1
	}  
    
    # ------------------------------------------------------------------------------------
    # Purpose: Ensure that the stipple configuration works for valid bitmaps 
    # ------------------------------------------------------------------------------------  
    proc RBC.barchart.pen.configure.M.5.1.Setup {} {
        barchart .barchart1
        .barchart1 pen create Pen1
        .barchart1 element create Element1 -data {1 2 2 4} -pen Pen1
        pack .barchart1
    }
    
    proc RBC.barchart.pen.configure.M.5.1.Body {} {
        .barchart1 pen configure Pen1 -stipple @greenback.xbm
    }
    
    proc RBC.barchart.pen.configure.M.5.1.Cleanup {} {
        destroy .barchart1
    }    
    
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of a pen can be set when the xerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.6.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -xerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarcap 5
	}
	
	proc RBC.barchart.pen.configure.M.6.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
		.barchart1 element configure Element1 -hide yes
		.barchart1 element configure Element1 -hide no
	}
	
	proc RBC.barchart.pen.configure.M.6.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of a pen can be set when the yerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.6.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -yerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarcap 5
	}
	
	proc RBC.barchart.pen.configure.M.6.2.Body {} {
		.barchart1 element configure Element1 -pen Pen1
		.barchart1 element configure Element1 -hide yes
		.barchart1 element configure Element1 -hide no
	}
	
	proc RBC.barchart.pen.configure.M.6.2.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
    # ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of a pen can be set when the xerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.7.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -xerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarcolor red
	}
	
	proc RBC.barchart.pen.configure.M.7.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.7.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of a pen can be set when the yerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.7.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -yerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarcolor red
	}
	
	proc RBC.barchart.pen.configure.M.7.2.Body {} {
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.7.2.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of a pen can be set when the xerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.8.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -xerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarwidth 5
	}
	
	proc RBC.barchart.pen.configure.M.8.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.8.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of a pen can be set when the yerror has been set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.8.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -yerror {1 2} -data {1 1 2 2}
		.barchart1 pen create Pen1 -errorbarwidth 5
	}
	
	proc RBC.barchart.pen.configure.M.8.2.Body {} {
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.8.2.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	} 
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element values can be shown using a pen.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.9.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {2 1} -label x -foreground blue \
			-valuefont {Arial 12}
		.barchart1 element create Element2 -data {3 2} -label y -foreground red \
			-valuefont {Arial 12}
		.barchart1 element create Element3 -data {4 3} -label both -foreground green \
			-valuefont {Arial 12}
		.barchart1 element create Element4 -data {5 4} -label none -foreground black
		.barchart1 pen create Pen1 -showvalues x -foreground blue
		.barchart1 pen create Pen2 -showvalues y -foreground red
		.barchart1 pen create Pen3 -showvalues both -foreground green
		.barchart1 pen create Pen4 -showvalues none -foreground black
	}
	
	proc RBC.barchart.pen.configure.M.9.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
		.barchart1 element configure Element2 -pen Pen2
		.barchart1 element configure Element3 -pen Pen3
		.barchart1 element configure Element4 -pen Pen4
	}
	
	proc RBC.barchart.pen.configure.M.9.1.Cleanup {} {
		.barchart1 pen delete Pen4
		.barchart1 pen delete Pen3
		.barchart1 pen delete Pen2
		.barchart1 pen delete Pen1
		.barchart1 element delete Element4
		.barchart1 element delete Element3
		.barchart1 element delete Element2
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.10.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1} -showvalues both \
			-valuefont {Arial 12} -label n -foreground blue
		.barchart1 element create Element2 -data {2 2} -showvalues both \
			-valuefont {Arial 12} -label ne -foreground red
		.barchart1 element create Element3 -data {3 3} -showvalues both \
			-valuefont {Arial 12} -label e -foreground green
		.barchart1 element create Element4 -data {4 4} -showvalues both \
			-valuefont {Arial 12} -label se -foreground purple
		.barchart1 element create Element5 -data {5 5} -showvalues both \
			-valuefont {Arial 12} -label s -foreground orange
		.barchart1 element create Element6 -data {6 6} -showvalues both \
			-valuefont {Arial 12} -label sw -foreground yellow
		.barchart1 element create Element7 -data {7 7} -showvalues both \
			-valuefont {Arial 12} -label w -foreground pink
		.barchart1 element create Element8 -data {8 8} -showvalues both \
			-valuefont {Arial 12} -label nw -foreground black
		.barchart1 element create Element9 -data {9 9} -showvalues both \
			-valuefont {Arial 12} -label center -foreground grey
		.barchart1 pen create Pen1 -valueanchor n -foreground blue \
			-valuefont {Arial 12} -showvalues both 
		.barchart1 pen create Pen2 -valueanchor ne -foreground red \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen3 -valueanchor e -foreground green \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen4 -valueanchor se -foreground purple \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen5 -valueanchor s -foreground orange \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen6 -valueanchor sw -foreground yellow \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen7 -valueanchor w -foreground pink \
			-valuefont {Arial 12} -showvalues both
		.barchart1 pen create Pen8 -valueanchor nw -foreground black \
			-valuefont {Arial 12} -showvalues both -valuecolor grey
		.barchart1 pen create Pen9 -valueanchor center -foreground grey \
			-valuefont {Arial 12} -showvalues both
	}
	
	proc RBC.barchart.pen.configure.M.10.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
		.barchart1 element configure Element2 -pen Pen2
		.barchart1 element configure Element3 -pen Pen3
		.barchart1 element configure Element4 -pen Pen4
		.barchart1 element configure Element5 -pen Pen5
		.barchart1 element configure Element6 -pen Pen6
		.barchart1 element configure Element7 -pen Pen7
		.barchart1 element configure Element8 -pen Pen8
		.barchart1 element configure Element9 -pen Pen9
	}
	
	proc RBC.barchart.pen.configure.M.10.1.Cleanup {} {
		.barchart1 pen delete Pen9
		.barchart1 pen delete Pen8
		.barchart1 pen delete Pen7
		.barchart1 pen delete Pen6
		.barchart1 pen delete Pen5
		.barchart1 pen delete Pen4
		.barchart1 pen delete Pen3
		.barchart1 pen delete Pen2
		.barchart1 pen delete Pen1
		.barchart1 element delete Element9
		.barchart1 element delete Element8
		.barchart1 element delete Element7
		.barchart1 element delete Element6
		.barchart1 element delete Element5
		.barchart1 element delete Element4
		.barchart1 element delete Element3
		.barchart1 element delete Element2
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.11.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}  \
			-showvalues both -valuefont {Arial 12}
		.barchart1 pen create Pen1 -valuecolor red \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.11.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.barchart.pen.configure.M.11.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element value can be rotated.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.12.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}  \
			-showvalues both -valuefont {Arial 12}
		.barchart1 pen create Pen1 -valuerotate 90 \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.12.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.12.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.13.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}  \
			-showvalues both -valuefont {Arial 12}
		.barchart1 pen create Pen1 -valueshadow red \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.13.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.13.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set and the
	# offset of the shadow can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.13.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}  \
			-showvalues both -valuefont {Arial 12}
		.barchart1 pen create Pen1 -valueshadow {red 5} \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.13.2.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.13.2.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the format of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.14.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2}  \
			-showvalues both -valuefont {Arial 12}
		.barchart1 pen create Pen1 -valueformat %f \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.14.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.14.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.15.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2} -showvalues both
		.barchart1 pen create Pen1 -showvalues both -valuefont Arial
	}
	
	proc RBC.barchart.pen.configure.M.15.1.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.15.1.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.pen.configure.M.15.2.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 element create Element1 -data {1 1 2 2} -showvalues both
		.barchart1 pen create Pen1 -showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.barchart.pen.configure.M.15.2.Body {} {
		.barchart1 element configure Element1 -pen Pen1 
	}
	
	proc RBC.barchart.pen.configure.M.15.2.Cleanup {} {
		.barchart1 pen delete Pen1
		.barchart1 element delete Element1
		destroy .barchart1
	}
}