#
# (C) Copyright IBM Corporation 2011, 2016
#

#
# Print a list of all sensors Amester can read
#

#Connect to POWER7 system
netc arlab046 -addr arlab046.austin.ibm.com

foreach host [find objects -isa host] {
    set ::file [open "${host}_sensors.csv" w]
    set ::allsensors {}
    #Get the first AMEC firmware instance on the host
    #(Assume the same list of sensors is on every interface)
    set ::amec [$host get amec]

    set ::allsensorobjs [$::amec get sensors]
    set allsensornames {}
    foreach s $allsensorobjs {
	lappend allsensornames [$s cget -sensorname]
    }
    set ::my_sensor_list [lsort -ascii $allsensornames]
    set ::allsensors [concat $::allsensors [$::amec get sensorname $::my_sensor_list]]

    puts $::file "Sensor,Units,Sample Rate,Scalefactor"
    foreach s $::allsensors {
	puts $::file "[$s cget -sensorname],[$s cget -u_value],[$s cget -freq],[$s cget -scalefactor]"
    }
    close $::file
}
