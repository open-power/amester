# RBC.winop.image.subsample.M.tcl --
#
###Abstract
# This file contains the manual tests that test the image subsample 
# function of the winop BLT component.
#
###Copyright
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
###Revision String
# SVN: $Id$

###Package Definition
package provide winop.image

package require rbc
namespace import rbc::*

namespace eval winop.image {
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the subsample function of the winop component works correctly when
	# given a single filter. 
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.subsample.M.1.1.Setup {} {
		set src [image create photo -file ./rain.gif]
		
		button .button1 -image $src
		button .button2 -image $src
		button .button3 -image $src
		button .button4 -image $src
		button .button5 -image $src
		button .button6 -image $src
		button .button7 -image $src
		button .button8 -image $src
		button .button9 -image $src
		button .button10 -image $src
		button .button11 -image $src
		button .button12 -image $src
		button .button13 -image $src
		button .button14 -image $src
		button .button15 -image $src
		
		grid .button1 -column 1 -row 1
		grid .button2 -column 1 -row 2
		grid .button3 -column 1 -row 3
		grid .button4 -column 2 -row 1
		grid .button5 -column 2 -row 2
		grid .button6 -column 2 -row 3
		grid .button7 -column 3 -row 1
		grid .button8 -column 3 -row 2
		grid .button9 -column 3 -row 3
		grid .button10 -column 4 -row 1
		grid .button11 -column 4 -row 2
		grid .button12 -column 4 -row 3
		grid .button13 -column 5 -row 1
		grid .button14 -column 5 -row 2
		grid .button15 -column 5 -row 3
	}
	
	proc RBC.winop.image.subsample.M.1.1.Body {} {
		set src [image create photo -file ./rain.gif]
		set dest1 [image create photo -height 100 -width 100]
		set dest2 [image create photo -height 100 -width 100]
		set dest3 [image create photo -height 100 -width 100]
		set dest4 [image create photo -height 100 -width 100]
		set dest5 [image create photo -height 100 -width 100]
		set dest6 [image create photo -height 100 -width 100]
		set dest7 [image create photo -height 100 -width 100]
		set dest8 [image create photo -height 100 -width 100]
		set dest9 [image create photo -height 100 -width 100]
		set dest10 [image create photo -height 100 -width 100]
		set dest11 [image create photo -height 100 -width 100]
		set dest12 [image create photo -height 100 -width 100]
		set dest13 [image create photo -height 100 -width 100]
		set dest14 [image create photo -height 100 -width 100]
		set dest15 [image create photo -height 100 -width 100]
		
		winop image subsample $src $dest1 0 0 30 30 bell
		winop image subsample $src $dest2 0 0 30 30 bessel
		winop image subsample $src $dest3 0 0 30 30 box
		winop image subsample $src $dest4 0 0 30 30 bspline
		winop image subsample $src $dest5 0 0 30 30 catrom
		winop image subsample $src $dest6 0 0 30 30 default
		winop image subsample $src $dest7 0 0 30 30 dummy
		winop image subsample $src $dest8 0 0 30 30 gauss8
		winop image subsample $src $dest9 0 0 30 30 gaussian
		winop image subsample $src $dest10 0 0 30 30 gi
		winop image subsample $src $dest11 0 0 30 30 lanczos3
		winop image subsample $src $dest12 0 0 30 30 mitchell
		winop image subsample $src $dest13 0 0 30 30 none
		winop image subsample $src $dest14 0 0 30 30 sinc
		winop image subsample $src $dest15 0 0 30 30 triangle
		
		.button1 configure -image $dest1
		.button2 configure -image $dest2
		.button3 configure -image $dest3
		.button4 configure -image $dest4
		.button5 configure -image $dest5
		.button6 configure -image $dest6
		.button7 configure -image $dest7
		.button8 configure -image $dest8
		.button9 configure -image $dest9
		.button10 configure -image $dest10
		.button11 configure -image $dest11
		.button12 configure -image $dest12
		.button13 configure -image $dest13
		.button14 configure -image $dest14
		.button15 configure -image $dest15
	}
	
	proc RBC.winop.image.subsample.M.1.1.Cleanup {} {
		destroy .button1 .button2 .button3 .button4 .button5 .button6 .button7 .button8 .button9 .button10 .button11 .button12 .button13 .button14 .button15
	}
	
	# ------------------------------------------------------------------------------------
	# Purpose: Ensure the subsample function of the winop component works correctly when
	# given both a horizontal and vertical filter.
	# ------------------------------------------------------------------------------------
	proc RBC.winop.image.subsample.M.2.1.Setup {} {
		set src [image create photo -file ./rain.gif]
		
		button .button1 -image $src
		button .button2 -image $src
		button .button3 -image $src
		button .button4 -image $src
		button .button5 -image $src
		button .button6 -image $src
		button .button7 -image $src
		button .button8 -image $src
		button .button9 -image $src
		button .button10 -image $src
		button .button11 -image $src
		button .button12 -image $src
		button .button13 -image $src
		button .button14 -image $src
		button .button15 -image $src
		
		grid .button1 -column 1 -row 1
		grid .button2 -column 1 -row 2
		grid .button3 -column 1 -row 3
		grid .button4 -column 2 -row 1
		grid .button5 -column 2 -row 2
		grid .button6 -column 2 -row 3
		grid .button7 -column 3 -row 1
		grid .button8 -column 3 -row 2
		grid .button9 -column 3 -row 3
		grid .button10 -column 4 -row 1
		grid .button11 -column 4 -row 2
		grid .button12 -column 4 -row 3
		grid .button13 -column 5 -row 1
		grid .button14 -column 5 -row 2
		grid .button15 -column 5 -row 3
	}
	
	proc RBC.winop.image.subsample.M.2.1.Body {} {
		set src [image create photo -file ./rain.gif]
		set dest1 [image create photo -height 100 -width 100]
		set dest2 [image create photo -height 100 -width 100]
		set dest3 [image create photo -height 100 -width 100]
		set dest4 [image create photo -height 100 -width 100]
		set dest5 [image create photo -height 100 -width 100]
		set dest6 [image create photo -height 100 -width 100]
		set dest7 [image create photo -height 100 -width 100]
		set dest8 [image create photo -height 100 -width 100]
		set dest9 [image create photo -height 100 -width 100]
		set dest10 [image create photo -height 100 -width 100]
		set dest11 [image create photo -height 100 -width 100]
		set dest12 [image create photo -height 100 -width 100]
		set dest13 [image create photo -height 100 -width 100]
		set dest14 [image create photo -height 100 -width 100]
		set dest15 [image create photo -height 100 -width 100]
		
		winop image subsample $src $dest1 0 0 30 30 bell bessel
		winop image subsample $src $dest2 0 0 30 30 bessel box
		winop image subsample $src $dest3 0 0 30 30 box bspline
		winop image subsample $src $dest4 0 0 30 30 bspline catrom
		winop image subsample $src $dest5 0 0 30 30 catrom default
		winop image subsample $src $dest6 0 0 30 30 default dummy
		winop image subsample $src $dest7 0 0 30 30 dummy gauss8
		winop image subsample $src $dest8 0 0 30 30 gauss8 gaussian
		winop image subsample $src $dest9 0 0 30 30 gaussian gi
		winop image subsample $src $dest10 0 0 30 30 gi lanczos3
		winop image subsample $src $dest11 0 0 30 30 lanczos3 mitchell
		winop image subsample $src $dest12 0 0 30 30 mitchell none
		winop image subsample $src $dest13 0 0 30 30 none since
		winop image subsample $src $dest14 0 0 30 30 sinc triangle
		winop image subsample $src $dest15 0 0 30 30 triangle bell
		
		.button1 configure -image $dest1
		.button2 configure -image $dest2
		.button3 configure -image $dest3
		.button4 configure -image $dest4
		.button5 configure -image $dest5
		.button6 configure -image $dest6
		.button7 configure -image $dest7
		.button8 configure -image $dest8
		.button9 configure -image $dest9
		.button10 configure -image $dest10
		.button11 configure -image $dest11
		.button12 configure -image $dest12
		.button13 configure -image $dest13
		.button14 configure -image $dest14
		.button15 configure -image $dest15
	}
	
	proc RBC.winop.image.subsample.M.2.1.Cleanup {} {
		destroy .button1 .button2 .button3 .button4 .button5 .button6 .button7 .button8 .button9 .button10 .button11 .button12 .button13 .button14 .button15
	}
}

 