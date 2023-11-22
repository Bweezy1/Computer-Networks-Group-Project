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
set val(nn)           2                        ;# number of mobilenodes

#Create new simulation
set ns [new simulator]

#Open a NAM trace file
set tracefile [open .out.nam w]
$ns nametrace-all $tracefile

#Set up a topology
set topo [new Topography]
$topo load_flatgrid 500 500

#Setup up god (general operations director)
create-god $val(nn)

#Node configuration (wireless node setup)
$ns_ node-config
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
                  -macTrace       OFF \
                  -movementTrace  OFF

#Create two nodes
set node_($0) [$ns_ node ]
$node_($0) random-motion 0

set node_($1) [$ns_ node ]
$node_($1) random-motion 0

#Set initial node positions
$node_(0) set X_ 10.0
$node_(0) set Y_ 15.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 420.0
$node_(1) set Y_ 69.0
$node_(1) set Z_ 0.0

#Set node movements
$ns_ at 15.0 "$node_(1) setdest 50.0 25.0 10.0"
$ns_ at 10.0 "$node_(0) setdest 69.0 42.0 25.0"

$ns at 25.0 "$node_(1) set dest 485.0 490.0 100.0

#Set up TCP connections
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 10.0 "$ftp start"

#Tell the nodes when simulation is over
$ns_ at 100.0 "$node_($0) reset"
$ns_ at 100.0 "$node_($1) reset"
$ns_ at 100.0001 "stop"
$ns_ at 100.0002 "puts \ "NS EXITING...\" ; $ns_ halt"
proc stop {} {
  global ns_ tracefile
  close $tracefile
}

#Command to start the simulation
puts "Starting SImulaion..."
$ns_ run
