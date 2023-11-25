##Formula for throughput##
#Throughput = received_data*8/DataTransmissionPeriod

BEGIN {
recv=0;
gotime = 100;
time = 0;
packet_size = 1000;
time_interval=2;
}

#body
{
	event = $1
	time = $2
	node_id = $3
	level = $4
	pktType = $7
	packet_size = $8

if(time>gotime){
  print gotime, (packet_size * recv * 8.0)/1000; #results in kbps
  gotime+= time_interval;
  recv=0;
}

#calculate throughput
if((event == "r") && (pktType == "tcp") && (level == "AGT"))
    {
	    recv++;
    }
}#end of body

END {
;
}
