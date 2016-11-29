set CommandName "element"

proc commandList {} {
	list activate bind closest configure create deactivate delete show
}

source ../BarchartRunAllSupportMethods.tcl

LoadSources [commandList] $CommandName

ExecuteCommandSequenceCommand [commandList] $CommandName