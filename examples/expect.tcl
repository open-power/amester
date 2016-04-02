#
# (C) Copyright IBM Corporation 2011, 2016
#

# Example of using Expect library within Amester.
# This example connects to the POWER7 FSP and
# sends a command to the Linux shell.

#
# Required Libraries
#
package require Expect

#
# Important globals
#

set ::fsp_address arlz181.austin.ibm.com
::amesterdebug::set expect 1


#
# Initialize some globals
#
set ::sid 0

proc connect {} {
    spawn telnet $::fsp_address 
    ::amesterdebug::debug expect "connect with $spawn_id"
    set ::sid $spawn_id
    expect -i $::sid "login:"
    exp_send -i $::sid "root\r"
    expect -i $::sid "Password:"
    exp_send -i $::sid "FipSroot\r"
    expect -i $::sid "$ "
}

proc disconnect {} {
    ::amesterdebug::debug expect "disconnect $::sid"
    puts "$this disconnect $::sid"
    if {$::sid != 0} {
	set result ""
	catch {exp_close -i $::sid} result
	if {$result ne ""} {::amesterdebug::debug expect "error closing $::sid: $result"}
	set ::sid 0
    }
}

proc reconnect {} {
    catch {disconnect}
    catch {connect}
}

#
# Issue a command to FSP and return first line of response
#
proc cmd_response {thecmd} {
    log_user 1
    exp_send -i $::sid $thecmd
    #parse the echo'd command
    expect -i $::sid -re "\r\n"
    #wait for first line of response
    expect -i $::sid -re "\r\n"
    #grab first line of response
    set line $expect_out(buffer)
    #remove \r from line
    set line [string trim $line]
    
    #let rest of response pass through expect
    expect -i $::sid "$ "
    log_user 0

    return $line
}

#
# Issue a command to FSP and get response in a list -- one list element per line of response
#
# This is the most powerful command and should be used instead of "cmd" or "cmd_response"
#
proc cmd_list {thecmd} {
    log_user 1
    set response ""
    exp_send -i $::sid $thecmd
    #parse the echo'd command
    expect -i $::sid -re "\r\n"
    #wait for first line of response

    while {1} {
	expect {
	    -i $::sid 
	    -re "\r\n" {
		set w [string trim $expect_out(buffer)]
		lappend response $w
	    }
	    "$ " {
		break
	    }
	    timeout {
		break
	    }
	    eof {
		break
	    }
	}
    }
    puts "done with cmd_list"
    return $response
	
}

#
# Issue a command to the FSP and ignore response
#
proc cmd {thecmd} {
    log_user 1
    exp_send -i $::sid $thecmd
    expect -i $::sid "$ "
    log_user 0
}

proc stuff {} {
    reconnect  
    #Get firmware version
    cmd "cupdmfg -b\r"
}

netc myfsp -addr $::fsp_address -passwd FipSdev
connect

set response [cmd_list "getscom pu 60013 -all\r"]
foreach r $response {
    puts "got line: $r"
}
