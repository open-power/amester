# RBC.graph.element.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element configure 
# function of the graph BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide graph.element

package require rbc
namespace import rbc::*

namespace eval graph.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the activepen of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.1.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -color blue -data {1 1}
		.graph1 pen create Pen1 -color red
	}
	
	proc RBC.graph.element.configure.M.1.1.Body {} {
		.graph1 element configure Element1 -activepen Pen1
		.graph1 element activate Element1
	}
	
	proc RBC.graph.element.configure.M.1.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the bindtags of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.2.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element bind Binding1 <Double-1> {puts foobar}
	}
	
	proc RBC.graph.element.configure.M.2.1.Body {} {
		.graph1 element configure Element1 -bindtags Binding1
	}
	
	proc RBC.graph.element.configure.M.2.1.Cleanup {} {
		.graph1 element delete Element1
		destroy Binding1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.3.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
	}
	
	proc RBC.graph.element.configure.M.3.1.Body {} {
		.graph1 element configure Element1 -color pink
	}
	
	proc RBC.graph.element.configure.M.3.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.4.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.configure.M.4.1.Body {} {
		.graph1 element configure Element1 -dashes {5 5}
	}
	
	proc RBC.graph.element.configure.M.4.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.4.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2} -dashes {5 5}
	}
	
	proc RBC.graph.element.configure.M.4.2.Body {} {
		.graph1 element configure Element1 -dashes ""
	}
	
	proc RBC.graph.element.configure.M.4.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the data of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.5.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1
	}
	
	proc RBC.graph.element.configure.M.5.1.Body {} {
		.graph1 element configure Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.configure.M.5.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to another color.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.6.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
	}
	
	proc RBC.graph.element.configure.M.6.1.Body {} {
		.graph1 element configure Element1 -fill pink
	}
	
	proc RBC.graph.element.configure.M.6.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to transparent.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.6.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
	}
	
	proc RBC.graph.element.configure.M.6.2.Body {} {
		.graph1 element configure Element1 -fill ""
	}
	
	proc RBC.graph.element.configure.M.6.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to the element color.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.6.3.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element configure Element1 -fill pink
	}
	
	proc RBC.graph.element.configure.M.6.3.Body {} {
		.graph1 element configure Element1 -fill defcolor
	}
	
	proc RBC.graph.element.configure.M.6.3.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.7.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element configure Element1 -hide no
	}
	
	proc RBC.graph.element.configure.M.7.1.Body {} {
		.graph1 element configure Element1 -hide yes
	}
	
	proc RBC.graph.element.configure.M.7.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element can be show if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.7.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element configure Element1 -hide yes
	}
	
	proc RBC.graph.element.configure.M.7.2.Body {} {
		.graph1 element configure Element1 -hide no
	}
	
	proc RBC.graph.element.configure.M.7.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the legend label can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.8.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
	}
	
	proc RBC.graph.element.configure.M.8.1.Body {} {
		.graph1 element configure Element1 -label myLabel
	}
	
	proc RBC.graph.element.configure.M.8.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the legend label can be hidden in legend.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.8.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element create Element2 -data {2 2}
	}
	
	proc RBC.graph.element.configure.M.8.2.Body {} {
		.graph1 element configure Element1 -label ""
	}
	
	proc RBC.graph.element.configure.M.8.2.Cleanup {} {
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the linewidth of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.9.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.graph.element.configure.M.9.1.Body {} {
		.graph1 element configure Element1 -linewidth 10
	}
	
	proc RBC.graph.element.configure.M.9.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the mapx of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.10.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 axis create Axis1 -min 0 -max 4
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.10.1.Body {} {
		.graph1 xaxis use Axis1
		.graph1 element configure Element1 -mapx Axis1
	}
	
	proc RBC.graph.element.configure.M.10.1.Cleanup {} {
		.graph1 axis delete Axis1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the mapy of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.11.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 axis create Axis1 -min 0 -max 4
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.11.1.Body {} {
		.graph1 yaxis use Axis1
		.graph1 element configure Element1 -mapy Axis1
	}
	
	proc RBC.graph.element.configure.M.11.1.Cleanup {} {
		.graph1 axis delete Axis1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the offdash of the element can be changed.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.12.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2} -dashes {5 5}
	}
	
	proc RBC.graph.element.configure.M.12.1.Body {} {
		.graph1 element configure Element1 -offdash red
	}
	
	proc RBC.graph.element.configure.M.12.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the outline color of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.13.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
	}
	
	proc RBC.graph.element.configure.M.13.1.Body {} {
		.graph1 element configure Element1 -outline red
	}
	
	proc RBC.graph.element.configure.M.13.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the pen of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.14.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -color blue -data {1 1}
		.graph1 pen create Pen1 -color red
	}
	
	proc RBC.graph.element.configure.M.14.1.Body {} {
		.graph1 element configure Element1 -pen Pen1
	}
	
	proc RBC.graph.element.configure.M.14.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the outlinewidth of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.15.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element configure Element1 -outline red
	}
	
	proc RBC.graph.element.configure.M.15.1.Body {} {
		.graph1 element configure Element1 -outlinewidth 4
	}
	
	proc RBC.graph.element.configure.M.15.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure symbols on the graph can be scaled with the x- and y-axes.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.16.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1}
		.graph1 element create Element2
	}
	
	proc RBC.graph.element.configure.M.16.1.Body {} {
		.graph1 element configure Element1 -scalesymbols 1
		.graph1 element configure Element2 -data {1.5 1.5}
	}
	
	proc RBC.graph.element.configure.M.16.1.Cleanup {} {
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the connecting line segments can be drawn differently.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.17.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 2 2 1 3 6 4 3} -label linear \
			-color green
		.graph1 element create Element2 -data {1 8 2 7 3 12 4 9} -label step \
			-color blue
		.graph1 element create Element3 -data {1 13 2 12 3 17 4 14} -label natural \
			-color orange
		.graph1 element create Element4 -data {1 16 2 15 3 20 4 17} -label quadratic \
			-color red
		.graph1 element create Element5 -data {1 19 2 18 3 23 4 20} -label cubic \
			-color purple
	}
	
	proc RBC.graph.element.configure.M.17.1.Body {} {
		.graph1 element configure Element1 -smooth linear
		.graph1 element configure Element2 -smooth step
		.graph1 element configure Element3 -smooth natural
		.graph1 element configure Element4 -smooth quadratic
		.graph1 element configure Element5 -smooth cubic
	}
	
	proc RBC.graph.element.configure.M.17.1.Cleanup {} {
		.graph1 element delete Element5
		.graph1 element delete Element4
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure elements can be drawn with a different pen based on their weights.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.18.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -weights {0 1 2}
		.graph1 pen create Pen1 -color red
	}
	
	proc RBC.graph.element.configure.M.18.1.Body {} {
		.graph1 element configure Element1 -styles {{Pen1 0.5 1.5}}
		.graph1 element configure Element1 -hide yes
		.graph1 element configure Element1 -hide no
	}
	
	proc RBC.graph.element.configure.M.18.1.Cleanup {} {
		.graph1 pen delete Pen1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the symbols of the element data points can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.19.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2}
		.graph1 element create Element2 -data {1 3 2 4}
		.graph1 element create Element3 -data {1 5 2 6}
		.graph1 element create Element4 -data {1 7 2 8}
		.graph1 element create Element5 -data {1 9 2 10}
		.graph1 element create Element6 -data {1 11 2 12}
		.graph1 element create Element7 -data {1 13 2 14}
		.graph1 element create Element8 -data {1 15 2 16}
		.graph1 element create Element9 -data {1 17 2 18}
		.graph1 element create Element10 -data {1 19 2 20}
	}
	
	proc RBC.graph.element.configure.M.19.1.Body {} {
		.graph1 element configure Element1 -symbol square
		.graph1 element configure Element2 -symbol circle
		.graph1 element configure Element3 -symbol diamond
		.graph1 element configure Element4 -symbol plus
		.graph1 element configure Element5 -symbol cross
		.graph1 element configure Element6 -symbol splus
		.graph1 element configure Element7 -symbol scross
		.graph1 element configure Element8 -symbol triangle
		.graph1 element configure Element9 -symbol ""
		.graph1 element configure Element10 -symbol warning
	}
	
	proc RBC.graph.element.configure.M.19.1.Cleanup {} {
		.graph1 element delete Element10
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
	# Purpose: Ensure the lines between data points of elements can be drawn correctly.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.20.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {2 2 1 1 3 1}
		.graph1 element create Element2 -data {2 4 1 3 3 3}
		.graph1 element create Element3 -data {2 6 1 5 3 5}
	}
	
	proc RBC.graph.element.configure.M.20.1.Body {} {
		.graph1 element configure Element1 -trace increasing
		.graph1 element configure Element2 -trace decreasing
		.graph1 element configure Element3 -trace both
	}
	
	proc RBC.graph.element.configure.M.20.1.Cleanup {} {
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the xdata and ydata of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.21.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1
	}
	
	proc RBC.graph.element.configure.M.21.1.Body {} {
		.graph1 element configure Element1 -xdata {1 2 3}
		.graph1 element configure Element1 -ydata {1 2 3}
	}
	
	proc RBC.graph.element.configure.M.21.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the x and y of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.22.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1
	}
	
	proc RBC.graph.element.configure.M.22.1.Body {} {
		.graph1 element configure Element1 -x {1 2 3}
		.graph1 element configure Element1 -y {1 2 3}
	}
	
	proc RBC.graph.element.configure.M.22.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the xerror of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.23.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1
	}
	
	proc RBC.graph.element.configure.M.23.1.Body {} {
		.graph1 element configure Element1 -xerror {1 2}
		.graph1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.23.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the yerror of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.24.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1
	}
	
	proc RBC.graph.element.configure.M.24.1.Body {} {
		.graph1 element configure Element1 -yerror {1 2}
		.graph1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.24.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the yhigh and ylow of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.25.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.graph.element.configure.M.25.1.Body {} {
		.graph1 element configure Element1 -yhigh 3 -ylow 2
		.graph1 element configure Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.graph.element.configure.M.25.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the xhigh and xlow of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.26.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.graph.element.configure.M.26.1.Body {} {
		.graph1 element configure Element1 -xhigh 3 -xlow 2
		.graph1 element configure Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.graph.element.configure.M.26.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.27.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.27.1.Body {} {
		.graph1 element configure Element1 -errorbarcolor red
	}
	
	proc RBC.graph.element.configure.M.27.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.27.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.27.2.Body {} {
		.graph1 element configure Element1 -errorbarcolor red
	}
	
	proc RBC.graph.element.configure.M.27.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.28.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.28.1.Body {} {
		.graph1 element configure Element1 -errorbarwidth 5
	}
	
	proc RBC.graph.element.configure.M.28.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.28.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.28.2.Body {} {
		.graph1 element configure Element1 -errorbarwidth 5
	}
	
	proc RBC.graph.element.configure.M.28.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.29.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.29.1.Body {} {
		.graph1 element configure Element1 -errorbarcap 30
		.graph1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.29.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.29.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.29.2.Body {} {
		.graph1 element configure Element1 -errorbarcap 30
		.graph1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.29.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the maximum number of symbols for an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.30.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol square
	}
	
	proc RBC.graph.element.configure.M.30.1.Body {} {
		.graph1 element configure Element1 -maxsymbols 1
	}
	
	proc RBC.graph.element.configure.M.30.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.31.1.Setup {} {
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
			-showvalues both -valuefont {Arial 12} -label nw -color black
		.graph1 element create Element9 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label center -color grey
	}
	
	proc RBC.graph.element.configure.M.31.1.Body {} {
		.graph1 element configure Element1 -valueanchor n
		.graph1 element configure Element2 -valueanchor ne
		.graph1 element configure Element3 -valueanchor e
		.graph1 element configure Element4 -valueanchor se
		.graph1 element configure Element5 -valueanchor s
		.graph1 element configure Element6 -valueanchor sw
		.graph1 element configure Element7 -valueanchor w
		.graph1 element configure Element8 -valueanchor nw
		.graph1 element configure Element9 -valueanchor center
	}
	
	proc RBC.graph.element.configure.M.31.1.Cleanup {} {
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
	proc RBC.graph.element.configure.M.32.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.graph.element.configure.M.32.1.Body {} {
		.graph1 element configure Element1 -valuecolor red
	}
	
	proc RBC.graph.element.configure.M.32.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element value can be rotated.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.33.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.graph.element.configure.M.33.1.Body {} {
		.graph1 element configure Element1 -valuerotate 90
	}
	
	proc RBC.graph.element.configure.M.33.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.34.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.graph.element.configure.M.34.1.Body {} {
		.graph1 element configure Element1 -valueshadow red
	}
	
	proc RBC.graph.element.configure.M.34.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set and the
	# offset of the shadow can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.34.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.graph.element.configure.M.34.2.Body {} {
		.graph1 element configure Element1 -valueshadow {red 5}
	}
	
	proc RBC.graph.element.configure.M.34.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the format of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.35.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.graph.element.configure.M.35.1.Body {} {
		.graph1 element configure Element1 -valueformat %f
	}
	
	proc RBC.graph.element.configure.M.35.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.36.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.graph.element.configure.M.36.1.Body {} {
		.graph1 element configure Element1 -valuefont Times
	}
	
	proc RBC.graph.element.configure.M.36.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font and font size of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.36.2.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.graph.element.configure.M.36.2.Body {} {
		.graph1 element configure Element1 -valuefont {Times 16}
	}
	
	proc RBC.graph.element.configure.M.36.2.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font command works when given a font string as input.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.36.3.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.graph.element.configure.M.36.3.Body {} {
		.graph1 element configure Element1 -valuefont "*-Arial-Bold-R-Normal-*-14-120-*"
	}
	
	proc RBC.graph.element.configure.M.36.3.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the label relief of the element in the legend can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.37.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
		.graph1 element create Element2 -data {1 3 2 4 3 5}
	}
	
	proc RBC.graph.element.configure.M.37.1.Body {} {
		.graph1 element configure Element1 -labelrelief raised
	}
	
	proc RBC.graph.element.configure.M.37.1.Cleanup {} {
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the area foreground of the element can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.38.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.38.1.Body {} {
		.graph1 element configure Element1 -areaforeground red
	}
	
	proc RBC.graph.element.configure.M.38.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the area background of the element can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.39.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.39.1.Body {} {
		.graph1 element configure Element1 -areabackground red
	}
	
	proc RBC.graph.element.configure.M.39.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the state of the element can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.40.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.40.1.Body {} {
		.graph1 element configure Element1 -state active
	}
	
	proc RBC.graph.element.configure.M.40.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element values can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.41.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 4 2 5 3 6} -label x -color blue \
			-valuefont {Arial 12}
		.graph1 element create Element2 -data {1 3 2 4 3 5} -label y -color red \
			-valuefont {Arial 12}
		.graph1 element create Element3 -data {1 2 2 3 3 4} -label both -color green \
			-valuefont {Arial 12}
		.graph1 element create Element4 -data {1 1 2 2 3 3} -label none -color black
	}
	
	proc RBC.graph.element.configure.M.41.1.Body {} {
		.graph1 element configure Element1 -showvalues x
		.graph1 element configure Element2 -showvalues y
		.graph1 element configure Element3 -showvalues both
		.graph1 element configure Element4 -showvalues none
	}
	
	proc RBC.graph.element.configure.M.41.1.Cleanup {} {
		.graph1 element delete Element4
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the error bars of the element can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.42.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 7 2 8 3 9} -xerror 1 -yerror 1 \
			-color blue -label both
		.graph1 element create Element2 -data {1 5 2 6 3 7} -xerror 1 -yerror 1 \
			-color red -label x
		.graph1 element create Element3 -data {1 3 2 4 3 5} -xerror 1 -yerror 1 \
			-color green -label y
		.graph1 element create Element4 -data {1 1 2 2 3 3} -xerror 1 -yerror 1 \
			-color orange -label none
	}
	
	proc RBC.graph.element.configure.M.42.1.Body {} {
		.graph1 element configure Element1 -showerrorbars both
		.graph1 element configure Element2 -showerrorbars x
		.graph1 element configure Element3 -showerrorbars y
		.graph1 element configure Element4 -showerrorbars none
	}
	
	proc RBC.graph.element.configure.M.42.1.Cleanup {} {
		.graph1 element delete Element4
		.graph1 element delete Element3
		.graph1 element delete Element2
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the values of the element can be reduced.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.43.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.43.1.Body {} {
		.graph1 element configure Element1 -reduce 2
	}
	
	proc RBC.graph.element.configure.M.43.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the area tile of the element can be set.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.44.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
		set Image1 [image create photo -data {
						R0lGODlhEAAQAIYAAPwCBHSi1Iyy5Hym3Hym1GSWxJS65Lza/OT2/Pz+/PT+
						/KTK5DxmlJS67PT6/Pz6/Lzm/BRGhHSe1MTe/OTy/Oz2/Mzm/NTq/FSKtJS2
						7PT2/MTi/LTa/AQyVOTu/Lze/LTS/JTC9MTq/Mzi/KzK/KTC/KS+/BQuRJzG
						/KzO/LTO/KS6/Jy2/DRmpAQOHEx+rLTK/Jy+/Iym/Jyq/GSK/GSOrIyCBHSi
						5HyW/DxuxFxqhPT+dPzqbHRCBAQmPBxenBxSjBxanARGfMRyDOymNOTCnPTG
						fIRKDMyGNOzGlISu7GSOzIROBPTGjJSy9EyGvIxODNSORMSWTLxyFDx6tBxe
						lKRiJGQ6BCQWBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
						AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
						AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAAAA
						LAAAAAAQABAAAAesgACCAQIDBAWCiYoABgcICQoJCwyLgg0OCQkPmgoQEYsS
						E5mYFBUWFxiLGZmbGhoWGxMcHYoDChoOFR4fByAcIbSJAyIXIxYgICQkJSbB
						gicovCkqJSssKy0uiy8bIDAxLDIzNDU2lS031TI4OTo7PD2VPj9AQUIuQ0RF
						RvGVi0dIkvATpGSJPwBMkDQxwkSCkyc3DkKJImUKlSdVhBxEaOUKACVVNgrC
						AsBPIAAh/mhDcmVhdGVkIGJ5IEJNUFRvR0lGIFBybyB2ZXJzaW9uIDIuNQ0K
						qSBEZXZlbENvciAxOTk3LDE5OTguIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQpo
						dHRwOi8vd3d3LmRldmVsY29yLmNvbQA7
		    		}]
	}
	
	proc RBC.graph.element.configure.M.44.1.Body {} {
		.graph1 element configure Element1 -areatile image1
	}
	
	proc RBC.graph.element.configure.M.44.1.Cleanup {} {
		destroy Image1
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the area pattern of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.45.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.45.1.Body {} {
		.graph1 element configure Element1 -areapattern warning
	}
	
	proc RBC.graph.element.configure.M.45.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the size of the element symbols can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.graph.element.configure.M.46.1.Setup {} {
		graph .graph1
		pack .graph1
		.graph1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.graph.element.configure.M.46.1.Body {} {
		.graph1 element configure Element1 -pixels 5
	}
	
	proc RBC.graph.element.configure.M.46.1.Cleanup {} {
		.graph1 element delete Element1
		destroy .graph1
	}
}
