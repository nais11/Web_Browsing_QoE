#!/usr/local/bin/bash
ssh -i ../.ssh/id_rsa server@10.0.1.1 ./stop_traffic_capture.sh
ssh -i ../.ssh/id_rsa client@192.168.0.101 ./stop_traffic_capture_client.sh 
