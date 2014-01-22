.. Openlava documentation master file, created by
   sphinx-quickstart on Tue Jan 21 10:10:49 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


lslib
=====
.. automodule:: openlava.lslib
    
    
Usage
-----

Import the appropriate functions from each module::

    from openlava.lslib import ls_getclustername, ls_getmastername, ls_info    
    import sys

Get and print the clustername, if ls_getclustername() fails, it will return None::

    cluster = ls_getclustername();
    if cluster==None:
    	print "Unable to get clustername"
    	sys.exit(1)
    print "My cluster name is <%s>" %  cluster

Do the same for the master host name::

    master = ls_getmastername();
    if master==None:
    	print "Unable to get master"
    	sys.exit(1)
    print "Master host is <%s>" % master

Get information about resources on the cluster using ls_info()::

    lsInfo = ls_info()
    if lsInfo==None:
	print "Unable to get LSInfo"
	sys.exit(1)

    print "\n%-15.15s %s" % ("RESOURCE_NAME", "DESCRIPTION")
    for i in range(lsInfo.nRes):
	print "%-15.15s %s" % ( lsInfo.resTable[i].name, lsInfo.resTable[i].des)
        
lsbatch
=======

.. automodule:: openlava.lsblib
   :members:

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

