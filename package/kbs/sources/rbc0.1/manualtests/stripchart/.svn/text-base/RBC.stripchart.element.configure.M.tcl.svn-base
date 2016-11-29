# RBC.stripchart.element.configure.M.tcl --
#
###Abstract
# This file contains the manual tests that test the element configure 
# function of the stripchart BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide stripchart.element

package require rbc
namespace import rbc::*

namespace eval stripchart.element {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the activepen of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.1.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -color blue -data {1 1}
		.stripchart1 pen create Pen1 -color red
	}
	
	proc RBC.stripchart.element.configure.M.1.1.Body {} {
		.stripchart1 element configure Element1 -activepen Pen1
		.stripchart1 element activate Element1
	}
	
	proc RBC.stripchart.element.configure.M.1.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the bindtags of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.2.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element bind Binding1 <Double-1> {puts foobar}
	}
	
	proc RBC.stripchart.element.configure.M.2.1.Body {} {
		.stripchart1 element configure Element1 -bindtags Binding1
	}
	
	proc RBC.stripchart.element.configure.M.2.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy Binding1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.3.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
	}
	
	proc RBC.stripchart.element.configure.M.3.1.Body {} {
		.stripchart1 element configure Element1 -color pink
	}
	
	proc RBC.stripchart.element.configure.M.3.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.4.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.stripchart.element.configure.M.4.1.Body {} {
		.stripchart1 element configure Element1 -dashes {5 5}
	}
	
	proc RBC.stripchart.element.configure.M.4.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the dash style of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.4.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2} -dashes {5 5}
	}
	
	proc RBC.stripchart.element.configure.M.4.2.Body {} {
		.stripchart1 element configure Element1 -dashes ""
	}
	
	proc RBC.stripchart.element.configure.M.4.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the data of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.5.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1
	}
	
	proc RBC.stripchart.element.configure.M.5.1.Body {} {
		.stripchart1 element configure Element1 -data {1 1 2 2}
	}
	
	proc RBC.stripchart.element.configure.M.5.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to another color.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.6.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
	}
	
	proc RBC.stripchart.element.configure.M.6.1.Body {} {
		.stripchart1 element configure Element1 -fill pink
	}
	
	proc RBC.stripchart.element.configure.M.6.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to transparent.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.6.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
	}
	
	proc RBC.stripchart.element.configure.M.6.2.Body {} {
		.stripchart1 element configure Element1 -fill ""
	}
	
	proc RBC.stripchart.element.configure.M.6.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the fill color of the element can be changed to the element color.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.6.3.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element configure Element1 -fill pink
	}
	
	proc RBC.stripchart.element.configure.M.6.3.Body {} {
		.stripchart1 element configure Element1 -fill defcolor
	}
	
	proc RBC.stripchart.element.configure.M.6.3.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element can be hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.7.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element configure Element1 -hide no
	}
	
	proc RBC.stripchart.element.configure.M.7.1.Body {} {
		.stripchart1 element configure Element1 -hide yes
	}
	
	proc RBC.stripchart.element.configure.M.7.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element can be show if hidden.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.7.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element configure Element1 -hide yes
	}
	
	proc RBC.stripchart.element.configure.M.7.2.Body {} {
		.stripchart1 element configure Element1 -hide no
	}
	
	proc RBC.stripchart.element.configure.M.7.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the legend label can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.8.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
	}
	
	proc RBC.stripchart.element.configure.M.8.1.Body {} {
		.stripchart1 element configure Element1 -label myLabel
	}
	
	proc RBC.stripchart.element.configure.M.8.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the legend label can be hidden in legend.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.8.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element create Element2 -data {2 2}
	}
	
	proc RBC.stripchart.element.configure.M.8.2.Body {} {
		.stripchart1 element configure Element1 -label ""
	}
	
	proc RBC.stripchart.element.configure.M.8.2.Cleanup {} {
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the linewidth of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.9.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2}
	}
	
	proc RBC.stripchart.element.configure.M.9.1.Body {} {
		.stripchart1 element configure Element1 -linewidth 10
	}
	
	proc RBC.stripchart.element.configure.M.9.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the mapx of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.10.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 axis create Axis1 -min 0 -max 4
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.10.1.Body {} {
		.stripchart1 xaxis use Axis1
		.stripchart1 element configure Element1 -mapx Axis1
	}
	
	proc RBC.stripchart.element.configure.M.10.1.Cleanup {} {
		.stripchart1 axis delete Axis1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the mapy of the element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.11.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 axis create Axis1 -min 0 -max 4
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.11.1.Body {} {
		.stripchart1 yaxis use Axis1
		.stripchart1 element configure Element1 -mapy Axis1
	}
	
	proc RBC.stripchart.element.configure.M.11.1.Cleanup {} {
		.stripchart1 axis delete Axis1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the offdash of the element can be changed.
	# DOES NOT WORK
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.12.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2} -dashes {5 5}
	}
	
	proc RBC.stripchart.element.configure.M.12.1.Body {} {
		.stripchart1 element configure Element1 -offdash red
	}
	
	proc RBC.stripchart.element.configure.M.12.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the outline color of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.13.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
	}
	
	proc RBC.stripchart.element.configure.M.13.1.Body {} {
		.stripchart1 element configure Element1 -outline red
	}
	
	proc RBC.stripchart.element.configure.M.13.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the pen of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.14.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -color blue -data {1 1}
		.stripchart1 pen create Pen1 -color red
	}
	
	proc RBC.stripchart.element.configure.M.14.1.Body {} {
		.stripchart1 element configure Element1 -pen Pen1
	}
	
	proc RBC.stripchart.element.configure.M.14.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the outlinewidth of the element can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.15.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element configure Element1 -outline red
	}
	
	proc RBC.stripchart.element.configure.M.15.1.Body {} {
		.stripchart1 element configure Element1 -outlinewidth 4
	}
	
	proc RBC.stripchart.element.configure.M.15.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure symbols on the stripchart can be scaled with the x- and y-axes.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.16.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1}
		.stripchart1 element create Element2
	}
	
	proc RBC.stripchart.element.configure.M.16.1.Body {} {
		.stripchart1 element configure Element1 -scalesymbols 1
		.stripchart1 element configure Element2 -data {1.5 1.5}
	}
	
	proc RBC.stripchart.element.configure.M.16.1.Cleanup {} {
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the connecting line segments can be drawn differently.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.17.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 2 2 1 3 6 4 3} -label linear \
			-color green
		.stripchart1 element create Element2 -data {1 8 2 7 3 12 4 9} -label step \
			-color blue
		.stripchart1 element create Element3 -data {1 13 2 12 3 17 4 14} -label natural \
			-color orange
		.stripchart1 element create Element4 -data {1 16 2 15 3 20 4 17} -label quadratic \
			-color red
		.stripchart1 element create Element5 -data {1 19 2 18 3 23 4 20} -label cubic \
			-color purple
	}
	
	proc RBC.stripchart.element.configure.M.17.1.Body {} {
		.stripchart1 element configure Element1 -smooth linear
		.stripchart1 element configure Element2 -smooth step
		.stripchart1 element configure Element3 -smooth natural
		.stripchart1 element configure Element4 -smooth quadratic
		.stripchart1 element configure Element5 -smooth cubic
	}
	
	proc RBC.stripchart.element.configure.M.17.1.Cleanup {} {
		.stripchart1 element delete Element5
		.stripchart1 element delete Element4
		.stripchart1 element delete Element3
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure elements can be drawn with a different pen based on their weights.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.18.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -weights {0 1 2}
		.stripchart1 pen create Pen1 -color red
	}
	
	proc RBC.stripchart.element.configure.M.18.1.Body {} {
		.stripchart1 element configure Element1 -styles {{Pen1 0.5 1.5}}
		.stripchart1 element configure Element1 -hide yes
		.stripchart1 element configure Element1 -hide no
	}
	
	proc RBC.stripchart.element.configure.M.18.1.Cleanup {} {
		.stripchart1 pen delete Pen1
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the symbols of the element data points can be changed.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.19.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2}
		.stripchart1 element create Element2 -data {1 3 2 4}
		.stripchart1 element create Element3 -data {1 5 2 6}
		.stripchart1 element create Element4 -data {1 7 2 8}
		.stripchart1 element create Element5 -data {1 9 2 10}
		.stripchart1 element create Element6 -data {1 11 2 12}
		.stripchart1 element create Element7 -data {1 13 2 14}
		.stripchart1 element create Element8 -data {1 15 2 16}
		.stripchart1 element create Element9 -data {1 17 2 18}
		.stripchart1 element create Element10 -data {1 19 2 20}
	}
	
	proc RBC.stripchart.element.configure.M.19.1.Body {} {
		.stripchart1 element configure Element1 -symbol square
		.stripchart1 element configure Element2 -symbol circle
		.stripchart1 element configure Element3 -symbol diamond
		.stripchart1 element configure Element4 -symbol plus
		.stripchart1 element configure Element5 -symbol cross
		.stripchart1 element configure Element6 -symbol splus
		.stripchart1 element configure Element7 -symbol scross
		.stripchart1 element configure Element8 -symbol triangle
		.stripchart1 element configure Element9 -symbol ""
		.stripchart1 element configure Element10 -symbol warning
	}
	
	proc RBC.stripchart.element.configure.M.19.1.Cleanup {} {
		.stripchart1 element delete Element10
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
	# Purpose: Ensure the xdata and ydata of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.20.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1
	}
	
	proc RBC.stripchart.element.configure.M.20.1.Body {} {
		.stripchart1 element configure Element1 -xdata {1 2 3}
		.stripchart1 element configure Element1 -ydata {1 2 3}
	}
	
	proc RBC.stripchart.element.configure.M.20.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the x and y of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.21.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1
	}
	
	proc RBC.stripchart.element.configure.M.21.1.Body {} {
		.stripchart1 element configure Element1 -x {1 2 3}
		.stripchart1 element configure Element1 -y {1 2 3}
	}
	
	proc RBC.stripchart.element.configure.M.21.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the xerror of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.22.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1
	}
	
	proc RBC.stripchart.element.configure.M.22.1.Body {} {
		.stripchart1 element configure Element1 -xerror {1 2}
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.22.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the yerror of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.23.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1
	}
	
	proc RBC.stripchart.element.configure.M.23.1.Body {} {
		.stripchart1 element configure Element1 -yerror {1 2}
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.23.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the yhigh and ylow of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.24.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.stripchart.element.configure.M.24.1.Body {} {
		.stripchart1 element configure Element1 -yhigh 3 -ylow 2
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.stripchart.element.configure.M.24.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the xhigh and xlow of an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.25.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.stripchart.element.configure.M.25.1.Body {} {
		.stripchart1 element configure Element1 -xhigh 3 -xlow 2
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3 4 4}
	}
	
	proc RBC.stripchart.element.configure.M.25.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.26.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.26.1.Body {} {
		.stripchart1 element configure Element1 -errorbarcolor red
	}
	
	proc RBC.stripchart.element.configure.M.26.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcolor of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.26.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.26.2.Body {} {
		.stripchart1 element configure Element1 -errorbarcolor red
	}
	
	proc RBC.stripchart.element.configure.M.26.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.27.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.27.1.Body {} {
		.stripchart1 element configure Element1 -errorbarwidth 5
	}
	
	proc RBC.stripchart.element.configure.M.27.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarwidth of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.27.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.27.2.Body {} {
		.stripchart1 element configure Element1 -errorbarwidth 5
	}
	
	proc RBC.stripchart.element.configure.M.27.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of an element can be set when the xerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.28.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -xerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.28.1.Body {} {
		.stripchart1 element configure Element1 -errorbarcap 30
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.28.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the errorbarcap of an element can be set when the yerror has been
	# set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.28.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -yerror {1 2} -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.28.2.Body {} {
		.stripchart1 element configure Element1 -errorbarcap 30
		.stripchart1 element configure Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.28.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the maximum number of symbols for an element can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.29.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol square
	}
	
	proc RBC.stripchart.element.configure.M.29.1.Body {} {
		.stripchart1 element configure Element1 -maxsymbols 1
	}
	
	proc RBC.stripchart.element.configure.M.29.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the anchor of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.30.1.Setup {} {
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
			-showvalues both -valuefont {Arial 12} -label nw -color black
		.stripchart1 element create Element9 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12} -label center -color grey
	}
	
	proc RBC.stripchart.element.configure.M.30.1.Body {} {
		.stripchart1 element configure Element1 -valueanchor n
		.stripchart1 element configure Element2 -valueanchor ne
		.stripchart1 element configure Element3 -valueanchor e
		.stripchart1 element configure Element4 -valueanchor se
		.stripchart1 element configure Element5 -valueanchor s
		.stripchart1 element configure Element6 -valueanchor sw
		.stripchart1 element configure Element7 -valueanchor w
		.stripchart1 element configure Element8 -valueanchor nw
		.stripchart1 element configure Element9 -valueanchor center
	}
	
	proc RBC.stripchart.element.configure.M.30.1.Cleanup {} {
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
	proc RBC.stripchart.element.configure.M.31.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.stripchart.element.configure.M.31.1.Body {} {
		.stripchart1 element configure Element1 -valuecolor red
	}
	
	proc RBC.stripchart.element.configure.M.31.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element value can be rotated.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.32.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.stripchart.element.configure.M.32.1.Body {} {
		.stripchart1 element configure Element1 -valuerotate 90
	}
	
	proc RBC.stripchart.element.configure.M.32.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.33.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.stripchart.element.configure.M.33.1.Body {} {
		.stripchart1 element configure Element1 -valueshadow red
	}
	
	proc RBC.stripchart.element.configure.M.33.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the color of the shadow of the element value can be set and the
	# offset of the shadow can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.33.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.stripchart.element.configure.M.33.2.Body {} {
		.stripchart1 element configure Element1 -valueshadow {red 5}
	}
	
	proc RBC.stripchart.element.configure.M.33.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the format of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.34.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus \
			-showvalues both -valuefont {Arial 12}
	}
	
	proc RBC.stripchart.element.configure.M.34.1.Body {} {
		.stripchart1 element configure Element1 -valueformat %f
	}
	
	proc RBC.stripchart.element.configure.M.34.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.35.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.stripchart.element.configure.M.35.1.Body {} {
		.stripchart1 element configure Element1 -valuefont Times
	}
	
	proc RBC.stripchart.element.configure.M.35.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font and font size of the element value can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.35.2.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.stripchart.element.configure.M.35.2.Body {} {
		.stripchart1 element configure Element1 -valuefont {Times 16}
	}
	
	proc RBC.stripchart.element.configure.M.35.2.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the font command works when given a  font string as input.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.35.3.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3} -symbol splus -showvalues both
	}
	
	proc RBC.stripchart.element.configure.M.35.3.Body {} {
		.stripchart1 element configure Element1 -valuefont "*-Arial-Bold-R-Normal-*-14-120-*"
	}
	
	proc RBC.stripchart.element.configure.M.35.3.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the label relief of the element in the legend can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.36.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
		.stripchart1 element create Element2 -data {1 3 2 4 3 5}
	}
	
	proc RBC.stripchart.element.configure.M.36.1.Body {} {
		.stripchart1 element configure Element1 -labelrelief raised
	}
	
	proc RBC.stripchart.element.configure.M.36.1.Cleanup {} {
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the element values can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.37.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 4 2 5 3 6} -label x -color blue \
			-valuefont {Arial 12}
		.stripchart1 element create Element2 -data {1 3 2 4 3 5} -label y -color red \
			-valuefont {Arial 12}
		.stripchart1 element create Element3 -data {1 2 2 3 3 4} -label both -color green \
			-valuefont {Arial 12}
		.stripchart1 element create Element4 -data {1 1 2 2 3 3} -label none -color black
	}
	
	proc RBC.stripchart.element.configure.M.37.1.Body {} {
		.stripchart1 element configure Element1 -showvalues x
		.stripchart1 element configure Element2 -showvalues y
		.stripchart1 element configure Element3 -showvalues both
		.stripchart1 element configure Element4 -showvalues none
	}
	
	proc RBC.stripchart.element.configure.M.37.1.Cleanup {} {
		.stripchart1 element delete Element4
		.stripchart1 element delete Element3
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the error bars of the element can be shown.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.38.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 7 2 8 3 9} -xerror 1 -yerror 1 \
			-color blue -label both
		.stripchart1 element create Element2 -data {1 5 2 6 3 7} -xerror 1 -yerror 1 \
			-color red -label x
		.stripchart1 element create Element3 -data {1 3 2 4 3 5} -xerror 1 -yerror 1 \
			-color green -label y
		.stripchart1 element create Element4 -data {1 1 2 2 3 3} -xerror 1 -yerror 1 \
			-color orange -label none
	}
	
	proc RBC.stripchart.element.configure.M.38.1.Body {} {
		.stripchart1 element configure Element1 -showerrorbars both
		.stripchart1 element configure Element2 -showerrorbars x
		.stripchart1 element configure Element3 -showerrorbars y
		.stripchart1 element configure Element4 -showerrorbars none
	}
	
	proc RBC.stripchart.element.configure.M.38.1.Cleanup {} {
		.stripchart1 element delete Element4
		.stripchart1 element delete Element3
		.stripchart1 element delete Element2
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
		
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the size of the element symbols can be set.
	# ------------------------------------------------------------------------------------
	proc RBC.stripchart.element.configure.M.39.1.Setup {} {
		stripchart .stripchart1
		pack .stripchart1
		.stripchart1 element create Element1 -data {1 1 2 2 3 3}
	}
	
	proc RBC.stripchart.element.configure.M.39.1.Body {} {
		.stripchart1 element configure Element1 -pixels 5
	}
	
	proc RBC.stripchart.element.configure.M.39.1.Cleanup {} {
		.stripchart1 element delete Element1
		destroy .stripchart1
	}
}
