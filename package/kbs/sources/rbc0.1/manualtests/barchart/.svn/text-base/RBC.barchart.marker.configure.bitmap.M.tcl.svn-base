# RBC.barchart.marker.configure.bitmap.M.test --
#
###Abstract
# This file contains the manual tests that test the bitmap marker configure
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.marker

package require rbc
namespace import rbc::*

namespace eval barchart.marker {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring background changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.1.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.1.1.Body {} {
		.barchart1 marker configure marker1 -background red
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.1.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring bitmap changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.2.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.2.1.Body {} {
		.barchart1 marker configure marker1 -bitmap @greenback.xbm
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.2.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring fill changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.3.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.3.1.Body {} {
		.barchart1 marker configure marker1 -fill red
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.3.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring foreground changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.4.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.4.1.Body {} {
		.barchart1 marker configure marker1 -foreground red
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.4.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring outline changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.5.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.5.1.Body {} {
		.barchart1 marker configure marker1 -outline red
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.5.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring rotate changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.6.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.6.1.Body {} {
		.barchart1 marker configure marker1 -rotate 30
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.6.1.Cleanup {} {
		destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure configuring anchor changes on screen
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.marker.configure.bitmap.M.7.1.Setup {} {
		barchart .barchart1
		pack .barchart1
		.barchart1 marker create bitmap -name marker1 -bitmap @greenback.xbm -coords {0 0}
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.7.1.Body {} {
		.barchart1 marker configure marker1 -anchor n
	}
	
	proc RBC.barchart.marker.configure.bitmap.M.7.1.Cleanup {} {
		destroy .barchart1
	}
}
