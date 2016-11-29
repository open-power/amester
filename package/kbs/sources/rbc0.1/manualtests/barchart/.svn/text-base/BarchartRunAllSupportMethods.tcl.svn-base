proc uniqkey { } {
	set key   [ expr { pow(2,31) + [ clock clicks ] } ]
    set key   [ string range $key end-8 end-3 ]
    set key   [ clock seconds ]$key
    return $key
}

proc sleep { ms } {
    set uniq [ uniqkey ]
    set ::__sleep__tmp__$uniq 0
    after $ms set ::__sleep__tmp__$uniq 1
    vwait ::__sleep__tmp__$uniq
    unset ::__sleep__tmp__$uniq
}

proc LoadSources {CommandList CommandName} {
	foreach command $CommandList {
		source "RBC.barchart.$CommandName.$command.M.tcl"
	}
}

proc ProcNameGenCommand {commandName command major minor} {
	return "barchart.$commandName\::RBC.barchart.$commandName.$command.M.$major.$minor"
}

proc ProcNameGenNoCommand {commandName major minor} {
	return "barchart.$commandName\::RBC.barchart.$commandName.M.$major.$minor"
}

proc ExecuteCommandSequenceCommand {CommandList CommandName} {
	foreach command $CommandList {
		set minor 1
		set major 1
		set delay 1500
		while {1 == 1} {
			if {[info commands [ProcNameGenCommand $CommandName $command $major $minor].Setup] != ""} {
				[ProcNameGenCommand $CommandName $command $major $minor].Setup
				sleep $delay
				[ProcNameGenCommand $CommandName $command $major $minor].Body
				sleep $delay
				[ProcNameGenCommand $CommandName $command $major $minor].Cleanup
				sleep $delay
				incr minor
			} else {
				incr minor
				if {[info commands [ProcNameGenCommand $CommandName $command $major $minor].Setup] == ""} {
					incr major
					set minor 1
					if {[info commands [ProcNameGenCommand $CommandName $command $major $minor].Setup] == ""} {
						break;
					}
				}
			}
		}
	}
	puts "Finished"
}

proc ExecuteCommandSequenceNoCommand {CommandName} {
	set minor 1
	set major 1
	set delay 1500
	while {1 == 1} {
		if {[info commands [ProcNameGenNoCommand $CommandName $major $minor].Setup] != ""} {
			[ProcNameGenNoCommand $CommandName $major $minor].Setup
			sleep $delay
			[ProcNameGenNoCommand $CommandName $major $minor].Body
			sleep $delay
			[ProcNameGenNoCommand $CommandName $major $minor].Cleanup
			sleep $delay
			incr minor
		} else {
			incr minor
			if {[info commands [ProcNameGenNoCommand $CommandName $major $minor].Setup] == ""} {
				incr major
				set minor 1
				if {[info commands [ProcNameGenNoCommand $CommandName $major $minor].Setup] == ""} {
					break;
				}
			}
		}
	}
}
