sudo rm -rf /usr/local/lib/python2.7/dist-packages/openlava*; 
sudo rm -rf build/; 
rm -rf openlava.c ;
rm -rf openlava/lslib.c ; 
sudo python-dbg setup.py install
if [[ $? -ne 0 ]]; then
	echo "BUILD FAILED"
	exit 1
fi
cd tests/ 
cygdb -- --args python-dbg mainscript.py
cd ..



