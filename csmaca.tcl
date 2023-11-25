# ======================================================================
# Define options
# ======================================================================
set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol 
set val(nn)           4                        ;# number of mobilenodes

#set up values of x and y boundaries for simulation and tracing
set opt(x)            500
set opt(y)            500

#Create new simulation
set ns [new simulator]

#Open a NAM trace file
set tracefile [open out.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all-wireless $namfile $opt(x) $opt(y)

#Set up a topology
set topo [new Topography]
$topo load_flatgrid opt(x) opt(y)

#Setup up god (general operations director)
create-god $val(nn)

#Node configuration (wireless node setup)
$ns node-config
                  -adhocRouting $val(rp) \
                  -llType	   $val(ll) \
                  -macType	   $val(mac) \
                  -propType	   $val(prop) \
                  -ifqType	   $val(ifq) \
                  -ifqLen	   $val(ifqlen) \
                  -phyType	   $val(netif) \
                  -antType	   $val(ant) \
                  -channelType    $val(chan) \
                  -topoInstance   $topo \
                  -agentTrace     ON \
                  -routerTrace    ON \
                  -macTrace       ON \
                  -movementTrace  OFF

#Create nodes
set n0 [$ns node ]
$n0 random-motion 0

set n1 [$ns node ]
$n1 random-motion 0

set n2 [$ns node ]
$n2 random-motion 0

set n3 [$ns node ]
$n3 random-motion 0

#============================================
#Set initial node positions
#============================================
$n0 set X_ 10.0
$n0 set Y_ 15.0
$n0 set Z_ 0.0

$n1 set X_ 42.0
$n1 set Y_ 69.0
$n1 set Z_ 0.0

$n2 set X_ 20.0
$n2 set Y_ 20.0
$n2 set Z_ 0.0

$n3 set X_ 25.0
$n3 set Y_ 75.0
$n3 set Z_ 0.0

#============================================
#Set node movements
#Ex. $n0(Sender) and $n1(Receiver) will move closer and sit around for a little bit.
#Then $n1 will move to a far location.
#============================================
$ns at 2.0 "$n1 setdest 70.0 75.0 20.0"
$ns at 2.0 "$n0 setdest 75.0 70.0 20.0"
$ns at 4.0 "$n1 setdest 490.0 490.0 40.0"

$ns at 6.0 "$n3 setdest 60.0 60.0 20.0"
$ns at 6.0 "$n2 setdest 50.0 50.0 20.0"
$ns at 6.0 "$n3 setdest 485.0 485.0 40.0"

#CBR setup
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize 1000
$cbr0 set interval 0.005

#============================================
#Set up TCP connections with CBR
#Ex. $n0 (sender) will be communicating with $n1 (reciever)
#============================================
set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
set sink0 [new Agent/TCPSink]
$cbr0 attach-agent $tcp0
$ns attach-agent $n0 $tcp0
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 2.0 "$ftp0 start"

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$cbr0 attach-agent $tcp1
$ns attach-agent $n2 $tcp1
$ns attach-agent $n3 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 2.0 "$ftp1 start"

#Tell the nodes when simulation is over
$ns_ at 100.0 "$n0 reset"
$ns_ at 100.0 "$n1 reset"
$ns_ at 100.0 "$n2 reset"
$ns_ at 100.0 "$n3 reset"
$ns_ at 100.0001 "stop"
$ns_ at 100.0002 "puts \ "NS EXITING...\" ; $ns halt"
proc stop {} {
  global ns tracefile namfile
  $ns flush-trace
  close $tracefile
  close $namfile
  exec nam Simulation.nam &
  exit 0
}

#Start the simulation
puts "Starting Simulation..."
$ns_ run
