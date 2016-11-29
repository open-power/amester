set CommandName "pen"

proc commandList {} {
	list configure delete
}

source ../StripchartRunAllSupportMethods.tcl

LoadSources [commandList] $CommandName

ExecuteCommandSequenceCommand [commandList] $CommandName