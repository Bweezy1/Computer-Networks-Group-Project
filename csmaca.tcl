#Define options
set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(ant)	Antenna/OmniAntenna
set val(ll)	LL
set val(ifq)	Queue/DropTail/PriQueue
set val(ifqlen)	50
set val(netif)	Phy/WirelessPhy
set val(mac)	Mac/802_11
set val(rp)	DSDV
set val(nn)	30

set opt(x)	500
set opt(y)	500

#Create new simulation
set ns [new Simulator]

#Create Trace and NAM Trace files
set tracefile [open Simulation.tr w]
$ns trace-all $tracefile
set namfile [open Simulation.nam w]
$ns namtrace-all-wireless $namfile $opt(x) $opt(y)

#Set up a topology
set topo [new Topography]
$topo load_flatgrid $opt(x) $opt(y)

#Setup up god (general operations director)
create-god $val(nn)

#Node configuration (wireless node setup)
$ns node-config -adhocRouting	$val(rp) \
		-llType		$val(ll) \
		-macType	$val(mac) \
		-propType	$val(prop) \
		-ifqType	$val(ifq) \
		-ifqLen		$val(ifqlen) \
		-phyType	$val(netif) \
		-antType	$val(ant) \
		-channelType	$val(chan) \
		-topoInstance	$topo \
		-agentTrace	ON \
		-routerTrace	ON \
		-macTrace	ON \
		-movementTrace	OFF

#Create nodes
for {set i 0} {$i < $val(nn) } {incr i} {
	set node_($i) [$ns node]
	$node_($i) random-motion 0
}

#Set initial node positions
for {set j 0} {$j < $val(nn) } {incr j} {
	$ns initial_node_pos $node_($j) 20
}

#Create node movements
$ns at 2.0 "$node_(1) setdest 30.0 25.0 20.0"
$ns at 2.0 "$node_(0) setdest 45.0 30.0 20.0"
$ns at 4.0 "$node_(1) setdest 450.0 450.0 40.0"

$ns at 4.0 "$node_(3) setdest 10.0 25.0 20.0"
$ns at 4.0 "$node_(2) setdest 15.0 30.0 20.0"
$ns at 6.0 "$node_(3) setdest 490.0 490.0 40.0"

$ns at 6.0 "$node_(5) setdest 175.0 325.0 35.0"
$ns at 6.0 "$node_(4) setdest 200.0 300.0 40.0"
$ns at 8.0 "$node_(5) setdest 475.0 475.0 50.0"

$ns at 8.0 "$node_(7) setdest 69.0 42.0 10.0"
$ns at 8.0 "$node_(6) setdest 42.0 69.0 10.0"
$ns at 10.0 "$node_(7) setdest 475.0 475.0 50.0"

$ns at 10.0 "$node_(9) setdest 490.0 490.0 400.0"
$ns at 10.0 "$node_(8) setdest 480.0 480.0 400.0"
$ns at 12.0 "$node_(9) setdest 150.0 10.0 100.0"

$ns at 12.0 "$node_(11) setdest 400.0 400.0 400.0"
$ns at 12.0 "$node_(10) setdest 420.0 420.0 400.0"
$ns at 14.0 "$node_(11) setdest 100.0 10.0 100.0"

$ns at 14.0 "$node_(13) setdest 290.0 290.0 300.0"
$ns at 14.0 "$node_(12) setdest 280.0 280.0 300.0"
$ns at 16.0 "$node_(13) setdest 10.0 100.0 100.0"

$ns at 16.0 "$node_(15) setdest 190.0 190.0 500.0"
$ns at 16.0 "$node_(14) setdest 180.0 180.0 500.0"
$ns at 18.0 "$node_(15) setdest 400.0 490.0 200.0"

$ns at 18.0 "$node_(17) setdest 440.0 450.0 500.0"
$ns at 18.0 "$node_(16) setdest 400.0 440.0 500.0"
$ns at 20.0 "$node_(17) setdest 10.0 100.0 100.0"

$ns at 20.0 "$node_(19) setdest 140.0 490.0 500.0"
$ns at 20.0 "$node_(18) setdest 180.0 280.0 500.0"
$ns at 22.0 "$node_(19) setdest 498.0 498.0 100.0"

$ns at 22.0 "$node_(21) setdest 40.0 90.0 50.0"
$ns at 22.0 "$node_(20) setdest 80.0 120.0 50.0"
$ns at 24.0 "$node_(21) setdest 430.0 499.0 100.0"

$ns at 24.0 "$node_(23) setdest 390.0 290.0 500.0"
$ns at 24.0 "$node_(22) setdest 350.0 410.0 500.0"
$ns at 26.0 "$node_(23) setdest 10.0 10.0 100.0"

$ns at 26.0 "$node_(25) setdest 240.0 490.0 500.0"
$ns at 26.0 "$node_(24) setdest 255.0 480.0 500.0"
$ns at 28.0 "$node_(25) setdest 1.0 1.0 100.0"

$ns at 28.0 "$node_(27) setdest 133.0 69.0 40.0"
$ns at 28.0 "$node_(26) setdest 100.0 25.0 40.0"
$ns at 30.0 "$node_(27) setdest 300.0 300.0 100.0"

$ns at 10.0 "$node_(29) setdest 10.0 30.0 10.0"
$ns at 10.0 "$node_(28) setdest 50.0 20.0 10.0"
$ns at 12.0 "$node_(28) setdest 420.0 487. 200.0"

#CBR setup
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize 1000
$cbr0 set interval 0.005

#Set up TCP connections with CBR
set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
set sink0 [new Agent/TCPSink]
$cbr0 attach-agent $tcp0
$ns attach-agent $node_(0) $tcp0
$ns attach-agent $node_(1) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 2.0 "$ftp0 start"

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$cbr0 attach-agent $tcp1
$ns attach-agent $node_(2) $tcp1
$ns attach-agent $node_(3) $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 4.0 "$ftp1 start"

set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
set sink2 [new Agent/TCPSink]
$cbr0 attach-agent $tcp2
$ns attach-agent $node_(4) $tcp2
$ns attach-agent $node_(5) $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 6.0 "$ftp2 start"

set tcp3 [new Agent/TCP]
$tcp3 set class_ 2
set sink3 [new Agent/TCPSink]
$cbr0 attach-agent $tcp3
$ns attach-agent $node_(6) $tcp3
$ns attach-agent $node_(7) $sink3
$ns connect $tcp3 $sink3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns at 8.0 "$ftp3 start"

set tcp4 [new Agent/TCP]
$tcp4 set class_ 2
set sink4 [new Agent/TCPSink]
$cbr0 attach-agent $tcp4
$ns attach-agent $node_(8) $tcp4
$ns attach-agent $node_(9) $sink4
$ns connect $tcp4 $sink4
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns at 10.0 "$ftp4 start"

set tcp5 [new Agent/TCP]
$tcp5 set class_ 2
set sink5 [new Agent/TCPSink]
$cbr0 attach-agent $tcp5
$ns attach-agent $node_(10) $tcp5
$ns attach-agent $node_(11) $sink5
$ns connect $tcp5 $sink5
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5
$ns at 2.0 "$ftp5 start"

set tcp6 [new Agent/TCP]
$tcp6 set class_ 2
set sink6 [new Agent/TCPSink]
$cbr0 attach-agent $tcp6
$ns attach-agent $node_(12) $tcp6
$ns attach-agent $node_(13) $sink6
$ns connect $tcp6 $sink6
set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp6
$ns at 2.0 "$ftp6 start"

set tcp7 [new Agent/TCP]
$tcp7 set class_ 2
set sink7 [new Agent/TCPSink]
$cbr0 attach-agent $tcp7
$ns attach-agent $node_(14) $tcp7
$ns attach-agent $node_(15) $sink7
$ns connect $tcp7 $sink7
set ftp7 [new Application/FTP]
$ftp7 attach-agent $tcp7
$ns at 2.0 "$ftp7 start"

set tcp8 [new Agent/TCP]
$tcp8 set class_ 2
set sink8 [new Agent/TCPSink]
$cbr0 attach-agent $tcp8
$ns attach-agent $node_(16) $tcp8
$ns attach-agent $node_(17) $sink8
$ns connect $tcp8 $sink8
set ftp8 [new Application/FTP]
$ftp8 attach-agent $tcp8
$ns at 2.0 "$ftp8 start"

set tcp9 [new Agent/TCP]
$tcp9 set class_ 2
set sink9 [new Agent/TCPSink]
$cbr0 attach-agent $tcp9
$ns attach-agent $node_(18) $tcp9
$ns attach-agent $node_(19) $sink9
$ns connect $tcp9 $sink9
set ftp9 [new Application/FTP]
$ftp9 attach-agent $tcp9
$ns at 2.0 "$ftp9 start"

set tcp10 [new Agent/TCP]
$tcp0 set class_ 2
set sink10 [new Agent/TCPSink]
$cbr0 attach-agent $tcp10
$ns attach-agent $node_(20) $tcp10
$ns attach-agent $node_(21) $sink10
$ns connect $tcp10 $sink10
set ftp10 [new Application/FTP]
$ftp10 attach-agent $tcp10
$ns at 2.0 "$ftp10 start"

set tcp11 [new Agent/TCP]
$tcp11 set class_ 2
set sink11 [new Agent/TCPSink]
$cbr0 attach-agent $tcp11
$ns attach-agent $node_(22) $tcp11
$ns attach-agent $node_(23) $sink11
$ns connect $tcp11 $sink11
set ftp11 [new Application/FTP]
$ftp11 attach-agent $tcp11
$ns at 2.0 "$ftp11 start"

set tcp12 [new Agent/TCP]
$tcp12 set class_ 2
set sink12 [new Agent/TCPSink]
$cbr0 attach-agent $tcp12
$ns attach-agent $node_(24) $tcp12
$ns attach-agent $node_(25) $sink12
$ns connect $tcp12 $sink12
set ftp12 [new Application/FTP]
$ftp12 attach-agent $tcp12
$ns at 2.0 "$ftp12 start"

set tcp13 [new Agent/TCP]
$tcp13 set class_ 2
set sink13 [new Agent/TCPSink]
$cbr0 attach-agent $tcp13
$ns attach-agent $node_(26) $tcp13
$ns attach-agent $node_(27) $sink13
$ns connect $tcp13 $sink13
set ftp13 [new Application/FTP]
$ftp13 attach-agent $tcp13
$ns at 2.0 "$ftp13 start"

set tcp14 [new Agent/TCP]
$tcp14 set class_ 2
set sink14 [new Agent/TCPSink]
$cbr0 attach-agent $tcp14
$ns attach-agent $node_(28) $tcp14
$ns attach-agent $node_(29) $sink14
$ns connect $tcp14 $sink14
set ftp14 [new Application/FTP]
$ftp14 attach-agent $tcp14
$ns at 2.0 "$ftp14 start"

#Tell the nodes when simulation is over
for {set k 0} {$k < $val(nn) } {incr k} {
	$ns at 100.0 "$node_($k) reset";
}
$ns at 100.001 "stop"
$ns at 100.0015 "puts \"NS EXITING...\" ; $ns halt"
proc stop {} {
	global ns tracefile namfile
	$ns flush-trace
	close $namfile
	close $tracefile
	exec nam Simulation.nam &
	exit 0
}

#Run simulation
puts "Starting Simulation..."
$ns run
