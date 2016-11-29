set CommandName "pen"

proc commandList {} {
	list configure delete
}

source ../BarchartRunAllSupportMethods.tcl

LoadSources [commandList] $CommandName

ExecuteCommandSequenceCommand [commandList] $CommandName