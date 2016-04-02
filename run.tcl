#!/usr/bin/tclsh
# figure out which platform we are on and run amester

#
# (C) Copyright IBM Corporation 2011, 2016
#

set debug 0

set platform $tcl_platform(platform)
set os $tcl_platform(os)
set osVersion $tcl_platform(osVersion)
set machine $tcl_platform(machine)

if {$debug} {
    puts "platform = $platform
os = $os
osVersion = $osVersion
machine = $machine"
}

if {$platform == "windows"} {
    if {[catch {
	exec package/kit-0.10-win32-MTall.exe vfs/main.tcl $argv >@ stdout 2>@ stderr
    } result]} {
	global errorInfo
	puts stderr $result
	puts stderr $errorInfo
    } else {
	#puts  "result = $result"
    }
    
} elseif {$platform == "unix"} {
    if {[catch {
	exec ./package/kbsmk8.6-bi vfs/main.tcl $argv >@ stdout 2>@ stderr
    } result]} {
	global errorInfo
	puts stderr $result
	puts stderr $errorInfo
    } else {
	#puts  "result = $result"
    }
    
} else {
    puts stderr "Err: don't know how to run amester on platform $platform"
}
