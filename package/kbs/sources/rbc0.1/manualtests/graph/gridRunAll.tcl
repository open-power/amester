set CommandName "grid"

proc commandList {} {
	list configure off on toggle
}

source ../GraphRunAllSupportMethods.tcl

LoadSources [commandList] $CommandName

ExecuteCommandSequenceCommand [commandList] $CommandName