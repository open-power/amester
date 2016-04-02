#
# (C) Copyright IBM Corporation 2011, 2016
#

#::amesterdebug::set ame 1
::amesterdebug::set parm 1
#::amesterdebug::set object 1

#
#
#
proc doit {} {
    ::amesterdebug::set ipmi 1
    
    set value [myfsp_ame0_test_uint8 read]
    puts "value = $value"
    incr value
    myfsp_ame0_test_uint8 write $value
    set value [myfsp_ame0_test_uint8 read]
    puts "new value = $value"

}


#
# Connect to fsp
#
netc myfsp -addr granolafsp2.austin.ibm.com -passwd FipSdev
#netc myfsp -addr s56a.austin.ibm.com -passwd FipSdev

::amesterdebug::set ipmi 1

foreach p [myfsp_ame0_parm get parmobjs] {
    puts "working with [$p cget -name]"
    set value [$p read]
    puts "  value = $value"
}

#doit

