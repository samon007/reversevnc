#!/usr/bin/expect -f 
#exp_internal 1
set mode [lindex $argv 0]
set clip [lindex $argv 1]

if { $mode == "" }  {
  puts "No mode specified, using default 'win'. possible values: win|screen \n"
}

proc rand_range { min max } { return [expr int(rand() * ($max - $min)) + $min] }

set local_port [rand_range 5555 9999 ]
set remote_port [rand_range 5555 9999 ]

while { ![catch {exec /bin/netstat -4tnl | grep $local_port}] } {
  puts stderr "local port $local_port already used"
  set local_port [rand_range 5555 9999 ]

}
puts "using local port $local_port"

spawn ssh -C -c arcfour,blowfish-cbc -o StrictHostKeyChecking=no -o AddressFamily=inet -t display@display.local /bin/dash

exp_send -- "xwininfo -display :0 -root | grep geometry | cut -d \\  -f4 | cut -d + -f1 \r"
expect "*"
set resolution $expect_out(buffer)

expect "$ "
exp_send -- "netstat -4tln\r"
expect "*LISTEN*"
set output $expect_out(buffer)

while { [string match "*$remote_port*" $output ]} {
  set remote_port [rand_range 5555 9999 ]
}

puts "using remote port $remote_port"

exp_send -- "echo\r"
expect "$ "

exp_send -- "~C\r"
expect "ssh> "
exp_send -- "-L:$local_port:localhost:$remote_port\r"
expect "$ "

exp_send "DISPLAY=:0 vncviewer -listen $remote_port -FullScreen=1 \r"
expect "port $remote_port"

if { $mode == "screen" } {
  if {  $clip == "" }  {
    puts "no clip specified, using default '1920x1200+1920+0'\n"
    set clip "1920x1200+1920+0"
  }
  puts [exec x11vnc -coe localhost:$local_port -nolookup -rfbport 0 -noclipboard -nosetclipboard -repeat -timeout 5 -clip $clip -scale $resolution] 
} else {
  set wid [exec xdotool selectwindow 2> /dev/null]
  puts [exec x11vnc -coe localhost:$local_port -nolookup -rfbport 0 -noclipboard -nosetclipboard -repeat -timeout 5 -id $wid] 
}

exit 0
