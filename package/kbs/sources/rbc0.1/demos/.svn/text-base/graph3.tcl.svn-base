#!/bin/sh

# --------------------------------------------------------------------------
#  RBC Demo graph3.tcl
#
#  This demo displays a graph with a bitmap marker.
# --------------------------------------------------------------------------
# restart using tclsh \
exec tclsh "$0" "$@"

package require rbc
namespace import rbc::*

set visual [winfo screenvisual .]
if { $visual != "staticgray" && $visual != "grayscale" } {
    option add *Button.Background		red
    option add *TextMarker.Foreground	black
    option add *TextMarker.Background	yellow
    option add *LineMarker.Foreground	black
    option add *LineMarker.Background	yellow
    option add *PolyMarker.Fill		yellow2
    option add *PolyMarker.Outline	""
    option add *PolyMarker.Stipple	fdiagonal1
    option add *activeLine.Color	red4
    option add *activeLine.Fill		red2
    option add *Element.Color		purple
}

image create photo bgTexture \
    -file ./images/chalk.gif

option add *Tile		bgTexture
option add *Button.Tile		""
option add *Text.font			-*-times*-bold-r-*-*-18-*-*
option add *header.font			-*-times*-medium-r-*-*-18-*-*
option add *footer.font			-*-times*-medium-r-*-*-18-*-*
option add *HighlightThickness		0

set graph [graph .g]
source scripts/graph3.tcl



text .header -wrap word -width 0 -height 3

set text {
This is an example of a bitmap marker.  Try zooming in on 
a region by clicking the left button, moving the pointer, 
and clicking again.  Notice that the bitmap scales too. 
To restore the last view, click on the right button.  
}
regsub -all "\n" $text "" text
.header insert end "$text\n"
.header configure -state disabled

text .footer -wrap word -width 0 -height 3
.footer insert end {Hit the }
set im [image create photo -file ./images/stopsign.gif]
.footer window create end -create {
    button .footer.quit -image $im -command { exit }
}
.footer insert end { button when you've seen enough.}
.footer configure -state disabled


grid .header -sticky ew -padx 4 -pady 4
grid $graph -sticky news
grid .footer -sticky ew -padx 4 -pady 4
grid columnconfigure . 0 -weight 1
grid    rowconfigure . 1 -weight 1


source scripts/ps.tcl

bind $graph <Shift-ButtonPress-1> { 
    MakePsLayout $graph
}



