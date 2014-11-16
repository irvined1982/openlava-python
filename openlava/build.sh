#!/bin/bash
sudo rm -rf /usr/local/lib/python2.7/dist-packages/openlava*; 
sudo rm -rf build/; 
rm -rf openlava.c ;
rm -rf openlava/lslib.c ; 
rm -rf openlava/lsblib.c ; 
sudo python setup.py install
if [[ $? -ne 0 ]]; then
	echo "BUILD FAILED"
	exit 1
fi
cd tests/ 
./test.py
if [[ $? -ne 0 ]]; then
	echo "TESTS FAILED"
	exit 1
fi
cd ..

( cd examples/; ./cluster_info.py&& ./host_info.py&& ./host_load.py&&./queues.py&&./hosts.py&&bsub sleep 10 &&./jobs.py&&./users.py )


