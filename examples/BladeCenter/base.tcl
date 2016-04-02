#
# (C) Copyright IBM Corporation 2011, 2016
#

# Amester example configuration file for IBM BladeCenter

# If you want the ::amesterdebug::debug window, uncomment the next line
#::amesterdebug::window

# To see debugging output from various AMEster subsytems, uncomment some of
# the following lines
#::amesterdebug::set options 1
#::amesterdebug::set network 1
#::amesterdebug::set ame 1
#::amesterdebug::set sensor 1
#::amesterdebug::set gui 1
#::amesterdebug::set budget 1
#::amesterdebug::set power 1
#::amesterdebug::set scope 1
#::amesterdebug::set ta 1
#::amesterdebug::set bc 1
#::amesterdebug::set health 1
#::amesterdebug::set login 1
#::amesterdebug::set histogram 1

#To send ::amesterdebug::debug output to a file, uncomment the following lines.
# set ::thedebugfile [open "mydebugfile" w]
# ::amesterdebug::output $::thedebugfile


# If you want to only use some of the blades in your chassis,
# modify the next line to list the slot numbers that you care about
#set ::slotmask [list 1 2 3 4 5 6 7 8 9 10 11 12 13 14]

# In some cases, you will need to modify the following lines so that AMEster 
# will know the IP address of each blade. Go ahead and do it now. 
# Uncomment each line that corresponds to a slot that has a blade and update the IP address.
# For blades that take 2 or more slots, use the lowest slot number and do not uncomment the other slots.
#set ::ip(1) 10.0.0.1
#set ::ip(2) 10.0.0.2
#set ::ip(3) 10.0.0.3
#set ::ip(4) 10.0.0.4
#set ::ip(5) 10.0.0.5
#set ::ip(6) 10.0.0.6
#set ::ip(7) 10.0.0.7
#set ::ip(8) 10.0.0.8
#set ::ip(9) 10.0.0.9
#set ::ip(10) 10.0.0.10
#set ::ip(11) 10.0.0.11
#set ::ip(12) 10.0.0.12
#set ::ip(13) 10.0.0.13
#set ::ip(14) 10.0.0.14

if {![info exists ::slotmask]} {
    set ::slotmask [array names ip]
}

# Modify the IP address in the next line to be the address of your MM. Also
# change the user ID and password if you actually care about security (this is
# the same account you use to log in to the MM Web interface).
bc mybc -addr 127.0.0.1 -userid USERID -password PASSW0RD -port 6090 -slotmask $slotmask

# Configuration is done; skip to the end of the file

# This code informs AMEster of the IP address for each slot
set bladelist [mybc get blades]
foreach blade $bladelist {
    set slot [$blade cget -slot]
    $blade configure -addr $::ip($slot)
}

# This code chooses which stats to list in main window
#host_window_set_columns {menu name link addr ame_version}

# End of boilerplate code. Add your own Tcl code below to do whatever you want.
