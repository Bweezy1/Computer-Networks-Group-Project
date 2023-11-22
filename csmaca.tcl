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

#create new simulation
set ns [new simulator]

#open a NAM trace file
set tracefile [open .out.nam w]
$ns nametrace-all $tracefile

#set up a topology
set topo [new Topography]
$topo load_flatgrid 500 500

#setup up god (general operations director)
create-god $val(nn)

#node configuration
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

#create two nodes
set node_($0) [$ns_ node ]
$node_($0) random-motion 0

set node_($1) [$ns_ node ]
$node_($1) random-motion 0

#set initial node positions
$node_(0) set X_ 10.0
$node_(0) set Y_ 15.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 420.0
$node_(1) set Y_ 69.0
$node_(1) set Z_ 0.0

#set node movements
$ns_ at 15.0 "$node_(1) setdest 50.0 25.0 10.0"
$ns_ at 10.0 "$node_(0) setdest 69.0 42.0 25.0"

$ns at 25.0 "$node_(1) set dest 485.0 490.0 100.0
