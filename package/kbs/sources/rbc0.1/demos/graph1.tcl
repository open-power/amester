#!/bin/sh

# --------------------------------------------------------------------------
#  RBC Demo graph1.tcl
#
#  This demo displays a graph with active legends and zoom.
# --------------------------------------------------------------------------
# restart using tclsh \
exec tclsh "$0" "$@"

package require rbc
namespace import rbc::*

if { [winfo screenvisual .] != "staticgray" } {
    option add *print.background yellow
    option add *quit.background red
    set image [image create photo -file ./images/rain.gif]
    option add *Graph.Tile $image
    option add *Label.Tile $image
    option add *Frame.Tile $image
    option add *Htext.Tile $image
    option add *TileOffset 0
}

set graph [graph .g]

text .header -wrap word -width 0 -height 5
.header insert end {
This is an example of the graph widget.  It displays two-variable data 
with assorted line attributes and symbols.  To create a postscript file 
    "xy.ps", press the }
.header window create end -create {
    button .header.print -text print -command {
        puts stderr [time {
	   #rbc::busy hold .
	   update
	   .g postscript output demo1.eps 
	   update
	   #rbc::busy release .
	   update
        }]
    } 
}
.header insert end { button.}
.header configure -state disabled

source scripts/graph1.tcl

text .footer -wrap word -width 0 -height 5
.footer insert end {Hit the }
.footer window create end -create {
    button .footer.quit -text quit -command { exit } 
}
.footer insert end { button when you've seen enough.  }
.footer configure -state disabled

# this was in original demo, but needs BLT bitmap
#.footer window create end -create {
#    label .footer.logo -bitmap BLT
#}

proc MultiplexView { args } { 
    eval .g axis view y $args
    eval .g axis view y2 $args
}

scrollbar .xbar \
    -command { .g axis view x } \
    -orient horizontal -relief flat \
    -highlightthickness 0 -elementborderwidth 2 -bd 0
scrollbar .ybar \
    -command MultiplexView \
    -orient vertical -relief flat  -highlightthickness 0 -elementborderwidth 2

grid .header -columnspan 2 -sticky ew
grid .g .ybar -sticky news
grid .xbar -sticky ew
grid .footer -columnspan 2 -sticky ew

grid .ybar -sticky ns

grid columnconfigure . 0 -weight 1
grid    rowconfigure . 1 -weight 1



.g postscript configure \
    -center yes \
    -maxpect yes \
    -landscape no \
    -preview yes

.g axis configure x \
    -scrollcommand { .xbar set } \
    -scrollmax 10 \
    -scrollmin 2 

.g axis configure y \
    -scrollcommand { .ybar set }

.g axis configure y2 \
    -scrollmin 0.0 -scrollmax 1.0 \
    -hide no \
    -title "Y2" 

.g legend configure \
    -activerelief flat \
    -activeborderwidth 1  \
    -position top -anchor ne

.g pen configure "activeLine" \
    -showvalues y
.g element bind all <Enter> {
    %W legend activate [%W element get current]
}
.g configure -plotpady { 1i 0 } 
.g element bind all <Leave> {
    %W legend deactivate [%W element get current]
}
.g axis bind all <Enter> {
    set axis [%W axis get current]
    %W axis configure $axis -background lightblue2
}
.g axis bind all <Leave> {
    set axis [%W axis get current]
    %W axis configure $axis -background "" 
}
.g configure -leftvariable left 
trace variable left w "UpdateTable .g"
proc UpdateTable { graph p1 p2 how } {
    table configure . c0 -width [$graph extents leftmargin]
    table configure . c2 -width [$graph extents rightmargin]
    table configure . r1 -height [$graph extents topmargin]
    table configure . r3 -height [$graph extents bottommargin]
}

set image2 [image create photo -file images/blt98.gif]
.g element configure line2 -areapattern @bitmaps/sharky.xbm \

#	-areaforeground blue -areabackground ""
.g element configure line3 -areatile $image2
.g configure -title [pwd]
