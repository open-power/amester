#
# (C) Copyright IBM Corporation 2011, 2016
#

puts "::argv is"
set c 0
foreach a $::argv {
    puts "$c --> $a"
    incr c
}
puts "--- end"


puts "::script_argv is"
set c 0
foreach a $::script_argv {
    puts "$c --> $a"
    incr c
}
puts "--- end"
exit
