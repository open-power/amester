# RBC.barchart.postscript.output.M.tcl --
#
###Abstract
# This file contains the manual tests that test the postscript output
# function of the barchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide barchart.postscript

package require rbc
namespace import rbc::*

namespace eval barchart.postscript {

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that correct postscript output is returned
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.postscript.output.M.1.1.Setup {} {
	    global FileName
	    global Channel
	    
	    set FileName "RBC.barchart.postscript.output.M.1.1.ps"
	    set Channel [open $FileName w]
	    
	    barchart .barchart1
	    pack .barchart1
	}
	
	proc RBC.barchart.postscript.output.M.1.1.Body {} {
	    global Channel
	    set TestPs [.barchart1 postscript output]
	    puts $Channel $TestPs
	    close $Channel
	}
	
	proc RBC.barchart.postscript.output.M.1.1.Cleanup {} {
	    global Channel
	    global FileName
	    
	    unset Channel
	    
	    if {[file exists $FileName]} {
	        file delete $FileName
	    }
	    
	    destroy .barchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure that correct postscript output is written to file
	# ------------------------------------------------------------------------------------
	proc RBC.barchart.postscript.output.M.1.2.Setup {} {
	    global FileName    
	    set FileName "RBC.barchart.postscript.output.M.1.2.ps"
	    
	    barchart .barchart1
	    pack .barchart1
	}
	
	proc RBC.barchart.postscript.output.M.1.2.Body {} {
	    global FileName
	    .barchart1 postscript output $FileName
	}
	
	proc RBC.barchart.postscript.output.M.1.2.Cleanup {} {
	    global FileName
	    
	    if {[file exists $FileName]} {
	        file delete $FileName
	    }
	    unset FileName    
	    
	    destroy .barchart1
	}

}
