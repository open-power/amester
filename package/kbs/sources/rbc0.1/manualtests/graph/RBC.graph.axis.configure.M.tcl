# RBC.graph.axis.configure.M.test --
#
###Abstract
# This file manually tests the configure options for the axis component
# of the graph component of BLT.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.axis

package require rbc
namespace import rbc::*

namespace eval graph.axis {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis color is changed on a graph.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.1.1.Setup {} {
		graph .graph1
		pack .graph1	
	}
	
	proc RBC.graph.axis.configure.M.1.1.Body {} {
		.graph1 axis configure x -color salmon
		.graph1 axis configure y -color salmon
	}
	
	proc RBC.graph.axis.configure.M.1.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.2.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.2.1.Body {} {
		.graph1 axis configure x -hide 1
	}
	
	proc RBC.graph.axis.configure.M.2.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis can be changed to be descending order.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.3.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.3.1.Body {} {
		.graph1 axis configure x -descending 1
	}
	
	proc RBC.graph.axis.configure.M.3.1.Cleanup {} {
		destroy .graph1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis can be justified. NOTE:  Title must be two lines.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.4.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "X-Axis\nTest"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.4.1.Body {} {
		.graph1 axis configure x -justify "right"
	}
	
	proc RBC.graph.axis.configure.M.4.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis limitsformat functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.5.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.5.1.Body {} {
		.graph1 axis configure x -limitsformat "top bottom"
	}
	
	proc RBC.graph.axis.configure.M.5.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis limitsshadow functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.6.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -limitsformat "Minimum Maximum"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.6.1.Body {} {
		.graph1 axis configure x -limitsshadow "red"
	}
	
	proc RBC.graph.axis.configure.M.6.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis limitscolor functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.7.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -limitsformat "Minimum Maximum"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.7.1.Body {} {
		.graph1 axis configure x -limitscolor "red"
	}
	
	proc RBC.graph.axis.configure.M.7.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis limitsfont functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.8.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -limitsformat "Minimum Maximum"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.8.1.Body {} {
		.graph1 axis configure x -limitsfont "*-Helvetica-Bold-R-Normal-*-14-140-*"
	}
	
	proc RBC.graph.axis.configure.M.8.1.Cleanup {} {
		destroy .graph1
	}		

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis linewidth functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.9.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.9.1.Body {} {
		.graph1 axis configure x -linewidth 5
	}
	
	proc RBC.graph.axis.configure.M.9.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis logscale functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.10.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.10.1.Body {} {
		.graph1 axis configure x -logscale 1
	}
	
	proc RBC.graph.axis.configure.M.10.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis loose functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.11.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.11.1.Body {} {
		.graph1 axis configure x -loose 1
	}
	
	proc RBC.graph.axis.configure.M.11.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis majorticks functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.12.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -max 11
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.12.1.Body {} {
		.graph1 axis configure x -majorticks "1 3 5 7 9 11"
	}
	
	proc RBC.graph.axis.configure.M.12.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis max functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.13.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.13.1.Body {} {
		.graph1 axis configure x -max 5
	}
	
	proc RBC.graph.axis.configure.M.13.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis min functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.14.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.14.1.Body {} {
		.graph1 axis configure x -min -5
	}
	
	proc RBC.graph.axis.configure.M.14.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis minorticks functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.15.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -max 4
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.15.1.Body {} {
		.graph1 axis configure x -minorticks "0.2 0.4 0.6 0.8"
	}
	
	proc RBC.graph.axis.configure.M.15.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis rotate functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.16.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.16.1.Body {} {
		.graph1 axis configure x -rotate 90.0
	}
	
	proc RBC.graph.axis.configure.M.16.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis showticks functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.17.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.17.1.Body {} {
		.graph1 axis configure x -showticks 0
	}
	
	proc RBC.graph.axis.configure.M.17.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis stepsize functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.18.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.18.1.Body {} {
		.graph1 axis configure x -stepsize 0.5
	}
	
	proc RBC.graph.axis.configure.M.18.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis subdivisions functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.19.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.19.1.Body {} {
		.graph1 axis configure x -subdivisions 10
	}
	
	proc RBC.graph.axis.configure.M.19.1.Cleanup {} {
		destroy .graph1
	}	
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis tickfont functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.20.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.20.1.Body {} {
		.graph1 axis configure x -tickfont "*-Helvetica-Bold-R-Normal-*-14-140-*"
	}
	
	proc RBC.graph.axis.configure.M.20.1.Cleanup {} {
		destroy .graph1
	}		
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis ticklength functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.21.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.21.1.Body {} {
		.graph1 axis configure x -ticklength 20
	}
	
	proc RBC.graph.axis.configure.M.21.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis title functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.22.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.22.1.Body {} {
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
	}
	
	proc RBC.graph.axis.configure.M.22.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis titlealternate functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.23.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.23.1.Body {} {
		.graph1 axis configure x -titlealternate true 
	}
	
	proc RBC.graph.axis.configure.M.23.1.Cleanup {} {
		destroy .graph1
	}		
	
# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis titlecolor functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.24.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.24.1.Body {} {
		.graph1 axis configure x -titlecolor "red" 
	}
	
	proc RBC.graph.axis.configure.M.24.1.Cleanup {} {
		destroy .graph1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis titlefont functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.25.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.25.1.Body {} {
		.graph1 axis configure x -tickfont "*-Helvetica-Bold-R-Normal-*-14-140-*"
	}
	
	proc RBC.graph.axis.configure.M.25.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis autorange functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.26.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.26.1.Body {} {
		.graph1 axis configure x -autorange 13.0
	}
	
	proc RBC.graph.axis.configure.M.26.1.Cleanup {} {
		destroy .graph1
	}

	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis shiftby functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.27.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.27.1.Body {} {
		.graph1 axis configure x -shiftby 13.0
	}
	
	proc RBC.graph.axis.configure.M.27.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis relief functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.28.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		.graph1 axis configure x -borderwidth 12
		.graph1 axis configure x -ticklength 20
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.28.1.Body {} {
		.graph1 axis configure x -relief sunken
	}
	
	proc RBC.graph.axis.configure.M.28.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis background functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.29.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.29.1.Body {} {
		.graph1 axis configure x -background red
	}
	
	proc RBC.graph.axis.configure.M.29.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis tickdivider functions correctly. (NOTE: This doesn't seem to work.)
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.30.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.30.1.Body {} {
		.graph1 axis configure x -tickdivider 1.5
	}
	
	proc RBC.graph.axis.configure.M.30.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis bind functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.31.1.Setup {} {
		graph .graph1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.31.1.Body {} {
		.graph1 axis bind x <Double-1> {puts TEST!}
	}
	
	proc RBC.graph.axis.configure.M.31.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis bind functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.31.2.Setup {} {
		graph .graph1
		.graph1 axis bind x <Double-1> {puts TEST!}
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.31.2.Body {} {
		.graph1 axis bind x <Double-1> {+puts "\n\tTEST!"}
	}
	
	proc RBC.graph.axis.configure.M.31.2.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis bind functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.31.3.Setup {} {
		graph .graph1
		.graph1 axis bind x <Double-1> {puts TEST!}
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.31.3.Body {} {
		.graph1 axis bind x <Double-1> {puts TEST2!}
	}
	
	proc RBC.graph.axis.configure.M.31.3.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis borderwidth functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.32.1.Setup {} {
		graph .graph1
		.graph1 axis configure x -title "This is the x-axis\n of the graph"
		.graph1 axis configure x -background red
		.graph1 axis configure x -borderwidth 0
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.32.1.Body {} {
		.graph1 axis configure x -borderwidth 30
	}
	
	proc RBC.graph.axis.configure.M.32.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis scrollmin functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.33.1.Setup {} {
		graph .graph1
		.graph1 axis create Axis1
		.graph1 axis configure Axis1 -scrollmin -5
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.33.1.Body {} {
		.graph1 axis configure Axis1 -scrollmin -10
	}
	
	proc RBC.graph.axis.configure.M.33.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis scrollmax functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.34.1.Setup {} {
		graph .graph1
		.graph1 axis create Axis1
		.graph1 axis configure Axis1 -scrollmax 5
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.34.1.Body {} {
		.graph1 axis configure Axis1 -scrollmax 20
	}
	proc RBC.graph.axis.configure.M.34.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis scrollcommand functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.35.1.Setup {} {
		graph .graph1
		.graph1 axis create Axis1
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.35.1.Body {} {
		.graph1 axis configure Axis1 -scrollcommand {puts foo}
	}
	
	proc RBC.graph.axis.configure.M.35.1.Cleanup {} {
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the axis scrollincrement functions correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.axis.configure.M.36.1.Setup {} {
		graph .graph1
		.graph1 axis create Axis1
		.graph1 axis configure Axis1 -scrollincrement 2
		pack .graph1
	}
	
	proc RBC.graph.axis.configure.M.36.1.Body {} {
		.graph1 axis configure Axis1 -scrollincrement 10
	}
	
	proc RBC.graph.axis.configure.M.36.1.Cleanup {} {
		destroy .graph1
	}	
		
}