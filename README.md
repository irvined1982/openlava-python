
lslib
*****

This module provides access to the openlava lslib C API.  Lslib
enables applications to contact the LIM and RES daemons.


Usage
=====

Import the appropriate functions from each module:

   from openlava.lslib import ls_getclustername, ls_getmastername, ls_info    
   import sys

Get and print the clustername, if ls_getclustername() fails, it will
return None:

   cluster = ls_getclustername();
   if cluster==None:
       print "Unable to get clustername"
       sys.exit(1)
   print "My cluster name is <%s>" %  cluster

Do the same for the master host name:

   master = ls_getmastername();
   if master==None:
       print "Unable to get master"
       sys.exit(1)
   print "Master host is <%s>" % master

Get information about resources on the cluster using ls_info():

   lsInfo = ls_info()
   if lsInfo==None:
       print "Unable to get LSInfo"
       sys.exit(1)

   print "

%-15.15s %s" % ("RESOURCE_NAME", "DESCRIPTION")
   for i in range(lsInfo.nRes):
      print "%-15.15s %s" % ( lsInfo.resTable[i].name,
      lsInfo.resTable[i].des)


Members
=======

openlava.lslib.LS_ISBUSY(status)

   Returns true if the host is busy

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the host is busy, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISLOCKED(status)

   Returns true if the host is locked for any reason

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the host is locked for any reason, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISLOCKEDM(status)

   Returns true if the host LIM is locked by the master LIM

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the host LIM is locked by the master LIM, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISLOCKEDU(status)

   Returns true if the host has been locked by an administrator

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      if the host has been locked by an administrator, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISLOCKEDW(status)

   Returns true if the host is locked because its run window is closed

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the host is locked because its run window is closed,
      else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISOK(status)

   Returns true if the host is OK

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the host is OK, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISOKNRES(status)

   Returns true as long as the RES and SBD are not down

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True as long as the RES and SBD are not down, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISRESDOWN(status)

   Returns true if the RES is down on the host

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the RES is down on the host, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISSBDDOWN(status)

   Returns true if the SBD is down on the host

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if the SBD is down on the host, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.LS_ISUNAVAIL(status)

   Returns True if the LIM on the host is not available.  For example
   it is not running, or the host is down

   Parameters:
      **status** (*int*) -- status of HostInfo object.

   Returns:
      True if LIM on host is not available, else False

   Return type:
      bool

      >>> from openlava import lslib
      >>> for host in lslib.ls_load():
      ...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
      ...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
      ...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
      ...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
      ...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
      ...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
      ...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
      ...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
      ...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
      ...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
      ... 
      Host: master: LS_ISUNAVAIL: False
      Host: master: LS_ISBUSY: False
      Host: master: LS_ISLOCKEDU: False
      Host: master: LS_ISLOCKEDW: False
      Host: master: LS_ISLOCKEDM: False
      Host: master: LS_ISLOCKED: False
      Host: master: LS_ISRESDOWN: False
      Host: master: LS_ISSBDDOWN: False
      Host: master: LS_ISOK: True
      Host: master: LS_ISOKNRES: True
      Host: comp00: LS_ISUNAVAIL: True
      Host: comp00: LS_ISBUSY: False
      Host: comp00: LS_ISLOCKEDU: False
      Host: comp00: LS_ISLOCKEDW: False
      Host: comp00: LS_ISLOCKEDM: False
      Host: comp00: LS_ISLOCKED: False
      Host: comp00: LS_ISRESDOWN: False
      Host: comp00: LS_ISSBDDOWN: False
      Host: comp00: LS_ISOK: False
      Host: comp00: LS_ISOKNRES: True

openlava.lslib.get_lserrno()

   Returns the lserrno

   Returns:
      LS Errno

   Return type:
      int

      LSE_NO_ERR           =   0
      LSE_BAD_XDR          =   1
      LSE_MSG_SYS          =   2
      LSE_BAD_ARGS         =   3
      LSE_MASTR_UNKNW      =   4
      LSE_LIM_DOWN         =   5
      LSE_PROTOC_LIM       =   6
      LSE_SOCK_SYS         =   7
      LSE_ACCEPT_SYS       =   8
      LSE_BAD_TASKF        =   9
      LSE_NO_HOST          =   10
      LSE_NO_ELHOST        =   11
      LSE_TIME_OUT         =   12
      LSE_NIOS_DOWN        =   13
      LSE_LIM_DENIED       =   14
      LSE_LIM_IGNORE       =   15
      LSE_LIM_BADHOST      =   16
      LSE_LIM_ALOCKED      =   17
      LSE_LIM_NLOCKED      =   18
      LSE_LIM_BADMOD       =   19
      LSE_SIG_SYS          =   20
      LSE_BAD_EXP          =   21
      LSE_NORCHILD         =   22
      LSE_MALLOC           =   23
      LSE_LSFCONF          =   24
      LSE_BAD_ENV          =   25
      LSE_LIM_NREG         =   26
      LSE_RES_NREG         =   27
      LSE_RES_NOMORECONN   =   28
      LSE_BADUSER          =   29
      LSE_RES_ROOTSECURE   =   30
      LSE_RES_DENIED       =   31
      LSE_BAD_OPCODE       =   32
      LSE_PROTOC_RES       =   33
      LSE_RES_CALLBACK     =   34
      LSE_RES_NOMEM        =   35
      LSE_RES_FATAL        =   36
      LSE_RES_PTY          =   37
      LSE_RES_SOCK         =   38
      LSE_RES_FORK         =   39
      LSE_NOMORE_SOCK      =   40
      LSE_WDIR             =   41
      LSE_LOSTCON          =   42
      LSE_RES_INVCHILD     =   43
      LSE_RES_KILL         =   44
      LSE_PTYMODE          =   45
      LSE_BAD_HOST         =   46
      LSE_PROTOC_NIOS      =   47
      LSE_WAIT_SYS         =   48
      LSE_SETPARAM         =   49
      LSE_RPIDLISTLEN      =   50
      LSE_BAD_CLUSTER      =   51
      LSE_RES_VERSION      =   52
      LSE_EXECV_SYS        =   53
      LSE_RES_DIR          =   54
      LSE_RES_DIRW         =   55
      LSE_BAD_SERVID       =   56
      LSE_NLSF_HOST        =   57
      LSE_UNKWN_RESNAME    =   58
      LSE_UNKWN_RESVALUE   =   59
      LSE_TASKEXIST        =   60
      LSE_BAD_TID          =   61
      LSE_TOOMANYTASK      =   62
      LSE_LIMIT_SYS        =   63
      LSE_BAD_NAMELIST     =   64
      LSE_LIM_NOMEM        =   65
      LSE_NIO_INIT         =   66
      LSE_CONF_SYNTAX      =   67
      LSE_FILE_SYS         =   68
      LSE_CONN_SYS         =   69
      LSE_SELECT_SYS       =   70
      LSE_EOF              =   71
      LSE_ACCT_FORMAT      =   72
      LSE_BAD_TIME         =   73
      LSE_FORK             =   74
      LSE_PIPE             =   75
      LSE_ESUB             =   76
      LSE_EAUTH            =   77
      LSE_NO_FILE          =   78
      LSE_NO_CHAN          =   79
      LSE_BAD_CHAN         =   80
      LSE_INTERNAL         =   81
      LSE_PROTOCOL         =   82
      LSE_MISC_SYS         =   83
      LSE_RES_RUSAGE       =   84
      LSE_NO_RESOURCE      =   85
      LSE_BAD_RESOURCE     =   86
      LSE_RES_PARENT       =   87
      LSE_I18N_SETLC       =   88
      LSE_I18N_CATOPEN     =   89
      LSE_I18N_NOMEM       =   90
      LSE_NO_MEM           =   91
      LSE_FILE_CLOSE       =   92
      LSE_MASTER_LIM_DOWN  =   93
      LSE_MLS_INVALID      =   94
      LSE_MLS_CLEARANCE    =   95
      LSE_MLS_RHOST        =   96
      LSE_MLS_DOMINATE     =   97
      LSE_HOST_EXIST       =   98
      LSE_NERR             =   99

      >>> from openlava import lslib
      >>> lslib.get_lserrno()
      81
      >>> lslib.ls_perror("Test:")
      Test:: Internal library error
      >>> lslib.ls_sysmsg()
      u'Internal library error'
      >>> 

openlava.lslib.ls_getclustername()

   Returns the name of the cluster

   Returns:
      Name of the cluster

   Return type:
      str

      >>> from openlava import lslib
      >>> lslib.ls_getclustername()
      u'openlava'

openlava.lslib.ls_gethostfactor(hostname)

   Returns the host factor of the host

   Parameters:
      **hostname** (*str*) -- Name of host to get hostfactor

   Returns:
      hostfactor

   Return type:
      float

      >>> from openlava import lslib
      >>> lslib.ls_gethostfactor("master")
      100.0
      >>> 

openlava.lslib.ls_gethostinfo(resReq="", hostList=[], options=0)

   Returns an array of HostInfo objects that meet the criteria
   specified

   Parameters:
      * **resReq** (*str*) -- Filter on hosts that meet the following
        resource request

      * **hostList** (*array*) -- return from the following list of
        hosts

      * **options** (*int*) -- Options

   Returns:
      array of HostInfo objects or None on error

   Return type:
      array

      >>> from openlava import lslib
      >>> for host in lslib.ls_gethostinfo():
      ...     print host.hostName
      ... 
      master
      comp00
      comp01
      comp02
      comp03
      comp04
      >>> 

openlava.lslib.ls_gethostmodel(hostname)

   Returns the model name of the host

   Parameters:
      **hostname** (*str*) -- Name of host to get host model

   Returns:
      host model

   Return type:
      str

      >>> from openlava import lslib
      >>> lslib.ls_gethostmodel("master")
      u'IntelI5'
      >>> 

openlava.lslib.ls_gethosttype(hostname)

   Returns the type of the host

   Parameters:
      **hostname** (*str*) -- Name of host to get host type

   Returns:
      host type

   Return type:
      str

      >>> from openlava import lslib
      >>> lslib.ls_gethosttype("master")
      u'linux'
      >>> 

openlava.lslib.ls_getmastername()

   Returns the name of the master host

   Returns:
      master host

   Return type:
      str

      >>> from openlava import lslib
      >>> lslib.ls_getmastername()
      u'master'
      >>>

openlava.lslib.ls_info()

   Returns an LsInfo object for the cluster

   Returns:
      LsInfo object for the cluster

   Return type:
      LsInfo

      >>> from openlava import lslib
      >>> info=lslib.ls_info()
      >>> info.hostTypes
      [u'linux']

openlava.lslib.ls_load(resreq=None, numhosts=0, options=0, fromhost=None)

   Returns an array of HostLoad objects for hosts that meet the
   criteria

   Parameters:
      * **resreq** (*str*) -- Resource request that hosts must satisfy

      * **numhosts** (*int*) -- if None, return only one host. if
        zero, return all matching hosts.

      * **options** (*int*) -- flags that affect how the hostlist is
        created

      * **fromhost** (*str*) -- when used with DFT_FROMTYPE option
        sets the default resource requirements to that of jobs
        submitted from fromhost

   Returns:
      Array of HostLoad objects

   Return type:
      array

      #options
      EXACT                =   0x01
      OK_ONLY              =   0x02
      NORMALIZE            =   0x04
      LOCALITY             =   0x08
      IGNORE_RES           =   0x10
      LOCAL_ONLY           =   0x20
      DFT_FROMTYPE         =   0x40
      ALL_CLUSTERS         =   0x80
      EFFECTIVE            =   0x100
      RECV_FROM_CLUSTERS   =   0x200
      NEED_MY_CLUSTER_NAME =   0x400
      >>> from openlava import lslib
      >>> hosts=lslib.ls_load(options=lslib.OK_ONLY)
      >>> for i in hosts:
      ...     print i.hostName
      ... 
      master
      >>> 

openlava.lslib.ls_loadinfo(resreq=None, numhosts=0, options=0, fromhost=None, hostlist=[], indxnamelist=[])

   Returns an array of HostLoad objects for hosts that meet the
   specified criteria

   Parameters:
      * **resreq** (*str*) -- Resource request that hosts must satisfy

      * **numhosts** (*int*) -- if None, return only one host. if
        zero, return all matching hosts.

      * **options** (*int*) -- flags that affect how the hostlist is
        created

      * **fromhost** (*str*) -- when used with DFT_FROMTYPE option
        sets the default resource requirements to that of jobs
        submitted from fromhost

      * **hostlist** (*array*) -- Hostnames to select from

   Returns:
      Array of HostLoad objects

   Return type:
      array

openlava.lslib.ls_perror(message)

   Prints the lslib error message associated with the lserrno prefixed
   by message.

   Parameters:
      **message** (*str*) -- User defined error message

   Returns:
      None

   Return type:
      None

      >>> from openlava import lslib
      >>> lslib.get_lserrno()
      81
      >>> lslib.ls_perror("Test:")
      Test:: Internal library error
      >>> lslib.ls_sysmsg()
      u'Internal library error'
      >>> 

openlava.lslib.ls_sysmsg()

   openlava.lsblib.lsb_sysmsg()

   Get the lslib error message associated with lserrno

   Returns:
      LSLIB error message

   Return type:
      str

      >>> from openlava import lslib
      >>> lslib.get_lserrno()
      81
      >>> lslib.ls_perror("Test:")
      Test:: Internal library error
      >>> lslib.ls_sysmsg()
      u'Internal library error'
      >>>


lsbatch
*******

This module provides access to the openlava lsblib C API.  Lsblib
enables applications to manipulate hosts, users, queues, and jobs.


Usage
=====

Import the appropriate functions from each module:

   from openlava.lslib import ls_perror
   from openlava.lsblib import lsb_init, lsb_hostinfo, 

Initialize the openlava library by calling lsb_init, if lsb_init
fails, print the error message.

   if lsb_init("Hosts") < 0:
           ls_perror("lsb_init")
           sys.exit(-1)

Call the appropriate functions, in this case, get information about
each host. Where the lsblib function would normally return a struct,
or array of structs, openlava.lsblib returns an array of python
objects with attributes set to the data returned within the underlying
C structures.

   hosts=lsb_hostinfo()
   if hosts==None:
           ls_perror("lsb_hostinfo");
           sys.exit(-1)

Function calls are kept as close as possible to the original LSB
functions, generally this means they return -1 or None on failure.
Where &num_x is supplied as an output parameter this is generally
ignored as this is unsupported in python.  Instead use
len(returned_array).

   for h in hosts:
       print "Host: %s has %d jobs" % (h.host, h.numJobs)

Warning: Openlava reuses memory for many of its internal datastructures, this
  behavior is the same in the python bindings.  Attributes and methods
  are lazy, that is to say that data is only copied and returned from
  the underlying struct when accessed by the python code.  As such, be
  careful when creating lists of jobs from readjobinfo() calls.


Members
=======

openlava.lsblib.create_job_id(job_id, array_index)

   Takes a job_id, and array_index, and returns the Openlava JOB id
   specific to that job/array_id combination.

   Parameters:
      * **job_id** (*int*) -- The job id

      * **array_index** (*int*) -- The array index of the job

   Returns:
      full job id

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.create_job_id(1000, 1)
      4294968296

openlava.lsblib.get_array_index(job_id)

   Takes an Openlava job id, and returns the array index

   Parameters:
      **job_id** (*int*) -- full job id as returned from openlava

   Returns:
      The array index of the job

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.get_array_index(4294968296)
      1

openlava.lsblib.get_job_id(job_id)

   Takes an Openlava job id, and returns the Job ID

      >>> from openlava import lsblib
      >>> lsblib.get_job_id(4294968296)
      1000

openlava.lsblib.get_lsberrno()

   Returns the lsberrno

   Returns:
      LSB Errno

   Return type:
      int

      LSBE_NO_ERROR = 00
      LSBE_NO_JOB = 01
      LSBE_NOT_STARTED = 02
      LSBE_JOB_STARTED = 03
      LSBE_JOB_FINISH = 04
      LSBE_STOP_JOB = 05
      LSBE_DEPEND_SYNTAX = 6
      LSBE_EXCLUSIVE = 7
      LSBE_ROOT = 8
      LSBE_MIGRATION = 9
      LSBE_J_UNCHKPNTABLE = 10
      LSBE_NO_OUTPUT = 11
      LSBE_NO_JOBID = 12
      LSBE_ONLY_INTERACTIVE = 13
      LSBE_NO_INTERACTIVE = 14
      LSBE_NO_USER = 15
      LSBE_BAD_USER = 16
      LSBE_PERMISSION = 17
      LSBE_BAD_QUEUE = 18
      LSBE_QUEUE_NAME = 19
      LSBE_QUEUE_CLOSED = 20
      LSBE_QUEUE_WINDOW = 21
      LSBE_QUEUE_USE = 22
      LSBE_BAD_HOST = 23
      LSBE_PROC_NUM = 24
      LSBE_RESERVE1 = 25
      LSBE_RESERVE2 = 26
      LSBE_NO_GROUP = 27
      LSBE_BAD_GROUP = 28
      LSBE_QUEUE_HOST = 29
      LSBE_UJOB_LIMIT = 30
      LSBE_NO_HOST = 31
      LSBE_BAD_CHKLOG = 32
      LSBE_PJOB_LIMIT = 33
      LSBE_NOLSF_HOST = 34
      LSBE_BAD_ARG = 35
      LSBE_BAD_TIME = 36
      LSBE_START_TIME = 37
      LSBE_BAD_LIMIT = 38
      LSBE_OVER_LIMIT = 39
      LSBE_BAD_CMD = 40
      LSBE_BAD_SIGNAL = 41
      LSBE_BAD_JOB = 42
      LSBE_QJOB_LIMIT = 43
      LSBE_UNKNOWN_EVENT = 44
      LSBE_EVENT_FORMAT = 45
      LSBE_EOF = 46
      LSBE_MBATCHD = 47
      LSBE_SBATCHD = 48
      LSBE_LSBLIB = 49
      LSBE_LSLIB = 50
      LSBE_SYS_CALL = 51
      LSBE_NO_MEM = 52
      LSBE_SERVICE = 53
      LSBE_NO_ENV = 54
      LSBE_CHKPNT_CALL = 55
      LSBE_NO_FORK = 56
      LSBE_PROTOCOL = 57
      LSBE_XDR = 58
      LSBE_PORT = 59
      LSBE_TIME_OUT = 60
      LSBE_CONN_TIMEOUT = 61
      LSBE_CONN_REFUSED = 62
      LSBE_CONN_EXIST = 63
      LSBE_CONN_NONEXIST = 64
      LSBE_SBD_UNREACH = 65
      LSBE_OP_RETRY = 66
      LSBE_USER_JLIMIT = 67
      LSBE_JOB_MODIFY = 68
      LSBE_JOB_MODIFY_ONCE = 69
      LSBE_J_UNREPETITIVE = 70
      LSBE_BAD_CLUSTER = 71
      LSBE_JOB_MODIFY_USED = 72
      LSBE_HJOB_LIMIT = 73
      LSBE_NO_JOBMSG = 74
      LSBE_BAD_RESREQ = 75
      LSBE_NO_ENOUGH_HOST = 76
      LSBE_CONF_FATAL = 77
      LSBE_CONF_WARNING = 78
      LSBE_NO_RESOURCE = 79
      LSBE_BAD_RESOURCE = 80
      LSBE_INTERACTIVE_RERUN = 81
      LSBE_PTY_INFILE = 82
      LSBE_BAD_SUBMISSION_HOST = 83
      LSBE_LOCK_JOB = 84
      LSBE_UGROUP_MEMBER = 85
      LSBE_OVER_RUSAGE = 86
      LSBE_BAD_HOST_SPEC = 87
      LSBE_BAD_UGROUP = 88
      LSBE_ESUB_ABORT = 89
      LSBE_EXCEPT_ACTION = 90
      LSBE_JOB_DEP = 91
      LSBE_JGRP_NULL = 92
      LSBE_JGRP_BAD = 93
      LSBE_JOB_ARRAY = 94
      LSBE_JOB_SUSP = 95
      LSBE_JOB_FORW = 96
      LSBE_BAD_IDX = 97
      LSBE_BIG_IDX = 98
      LSBE_ARRAY_NULL = 99
      LSBE_JOB_EXIST = 100
      LSBE_JOB_ELEMENT = 101
      LSBE_BAD_JOBID = 102
      LSBE_MOD_JOB_NAME = 103
      LSBE_PREMATURE = 104
      LSBE_BAD_PROJECT_GROUP = 105
      LSBE_NO_HOST_GROUP = 106
      LSBE_NO_USER_GROUP = 107
      LSBE_INDEX_FORMAT = 108
      LSBE_SP_SRC_NOT_SEEN = 109
      LSBE_SP_FAILED_HOSTS_LIM = 110
      LSBE_SP_COPY_FAILED = 111
      LSBE_SP_FORK_FAILED = 112
      LSBE_SP_CHILD_DIES = 113
      LSBE_SP_CHILD_FAILED = 114
      LSBE_SP_FIND_HOST_FAILED = 115
      LSBE_SP_SPOOLDIR_FAILED = 116
      LSBE_SP_DELETE_FAILED = 117
      LSBE_BAD_USER_PRIORITY = 118
      LSBE_NO_JOB_PRIORITY = 119
      LSBE_JOB_REQUEUED = 120
      LSBE_MULTI_FIRST_HOST = 121
      LSBE_HG_FIRST_HOST = 122
      LSBE_HP_FIRST_HOST = 123
      LSBE_OTHERS_FIRST_HOST = 124
      LSBE_PROC_LESS = 125
      LSBE_MOD_MIX_OPTS = 126
      LSBE_MOD_CPULIMIT = 127
      LSBE_MOD_MEMLIMIT = 128
      LSBE_MOD_ERRFILE = 129
      LSBE_LOCKED_MASTER = 130
      LSBE_DEP_ARRAY_SIZE = 131
      LSBE_NUM_ERR = 131

      >>> from openlava import lsblib, lslib
      >>> lsblib.lsb_init("foo")
      0
      >>> lsblib.lsb_hostcontrol("foo", 2)
      -1
      >>> lsblib.get_lsberrno()
      17
      >>> lsblib.lsb_perror("foo")
      foo: User permission denied
      >>> lsblib.lsb_sysmsg()
      u'User permission denied'
      >>> 

openlava.lsblib.lsb_closejobinfo()

   Closes the connection to the MBD that was opened with
   lsb_openjobinfo()

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("closejobinfo")
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...     job=lsblib.lsb_readjobinfo()
      ...     print job.jobId
      ... 
      4562
      >>> lsblib.lsb_closejobinfo()

openlava.lsblib.lsb_deletejob(job_id, submit_time[, options=0])

   Removes a job from the schedluing system.  If the job is running it
   is killed.

   Parameters:
      * **job_id** (*str*) -- Job ID of the job to kill

      * **submit_time** (*int*) -- epoch time of the job submission

      * **options** (*int*) -- If options == lsblib.LSB_KILL_REQUEUE
        job will be requeued with the same job id, else it is
        completely removed

   Returns:
      0 on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("deletejob")
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...     job=lsblib.lsb_readjobinfo()
      ...     print "Killing job: %d" % job.jobId
      ...     lsblib.lsb_deletejob(job.jobId, job.submitTime)
      ... 
      Killing job: 4562
      -1
      >>> lsblib.lsb_closejobinfo()

openlava.lsblib.lsb_hostcontrol(host, opCode)

   Opens or closes a host, shutsdown or restarts SBD.

   Parameters:
      * **host** (*str*) -- Hostname of host

      * **opCode** (*int*) -- Opcode, one of either HOST_CLOSE,
        HOST_OPEN, HOST_REBOOT, HOST_SHUTDOWN.

   Returns:
      0 on success, -1 on failure.

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("hostcontrol")
      >>> lsblib.lsb_hostcontrol("localhost", lsblib.HOST_OPEN)
      -1

openlava.lsblib.lsb_hostinfo(hosts=[], numHosts=0)

   Returns information about Openlava hosts.

   Parameters:
      * **hosts** (*array*) -- Array of hostnames

      * **numHosts** (*int*) -- Number of hosts, if set to 1 and hosts
        is empty, returns information on the local host

   Returns:
      Array of HostInfoEnt objects

   Return type:
      array

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("host test")
      0
      >>> for host in lsblib.lsb_hostinfo():
      ...     print host.host
      ... 
      master
      comp00
      comp01
      comp02
      comp03
      comp04
      >>> for host in lsblib.lsb_hostinfo(numHosts=1):
      ...     print host.host
      ... 
      master

openlava.lsblib.lsb_init()

   openlava.lsblib.lsb_init(appName)

   Initialize the lsb library

   Parameters:
      **appName** (*str*) -- A name for the calling application

   Returns:
      status - 0 on success, -1 on failure.

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("testing")
      0

openlava.lsblib.lsb_modify()

   openlava.lsblib.lsb_modify(jobSubReq, jobSubReply, jobId)
   Modifies an existing job

   Parameters:
      * **jobSubReq** (*Submit*) -- Submit request

      * **jobSubReply** (*SubmitReply*) -- Submit reply

      * **jobId** (*int*) -- Job ID

   Returns:
      Job ID, -1 on failure.

   Return type:
      int

openlava.lsblib.lsb_openjobinfo(job_id=0, job_name="", user="all", queue="", host="", options=0)

   Get information about jobs that match the specified criteria.

   Note: Only one parameter may be used at any given time.

   Parameters:
      * **job_id** (*int*) -- Return jobs with this job id.

      * **job_name** (*str*) -- Return jobs with this name

      * **user** (*str*) -- Return jobs owned by this user

      * **host** (*str*) -- Return jobs on this host

      * **options** (*int*) -- Return jobs that match the following
        options, where option is a bitwise or of the following
        paramters: ALL_JOB - All jobs; CUR_JOB - All unfinished jobs;
        DONE_JOB - Jobs that have finished or exited; PEND_JOB - Jobs
        that are pending; SUSP_JOB - Jobs that are suspended; LAST_JOB
        - The last submitted job

   Returns:
      Number of jobs that match, -1 on error

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("testing")
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...     job=lsblib.lsb_readjobinfo()
      ...     print job.jobId
      ... 
      4562
      >>> lsblib.lsb_closejobinfo()

openlava.lsblib.lsb_peekjob()

   Get the name of the file where job output is being spooled.

   Parameters:
      **jobId** (*int*) -- The ID of the job

   Returns:
      Path to the file, or None if not available

   Return type:
      str

      >>> from openlava import lsblib
      >>> 
      >>> 
      >>> from openlava import lsblib
      >>> lsblib.lsb_init("peek")
      0
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...     job=lsblib.lsb_readjobinfo()
      ...     print "Job: %s: %s" % (job.jobId, lsblib.lsb_peekjob(job.jobId))
      ... 
      Job: 4562: /home/brian/.lsbatch/1390404552.4562
      >>> 

openlava.lsblib.lsb_pendreason(numReasons, rsTb, jInfoH, ld)

   Get the reason a job is pending

   Parameters:
      * **numReasons** (*int*) -- The length of the reasons array

      * **rsTb** (*list*) -- An array of integer reasons

      * **jInfoH** (*JobInfoHead*) -- Job info header, may be None

      * **ld** (*LoadIndexLog*) -- LoadIndexLog, use to set specific
        names of load indexes.

   Returns:
      Description of job pending reasons

   Return type:
      str

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("Job Test")
      0
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...         job=lsblib.lsb_readjobinfo()
      ...         ld=lsblib.LoadIndexLog()
      ...         if job.status & lsblib.JOB_STAT_PEND != 0:
      ...                 print "Job %d: %s" % (job.jobId, lsblib.lsb_pendreason(job.numReasons, job.reasonTb, None, ld))
      ... 

openlava.lsblib.lsb_perror(message)

   Prints the lsblib error message associated with the lsberrno
   prefixed by message.

   Parameters:
      **message** (*str*) -- User defined error message

   Returns:
      None

   Return type:
      None

      >>> from openlava import lsblib, lslib
      >>> lsblib.lsb_init("foo")
      0
      >>> lsblib.lsb_hostcontrol("foo", 2)
      -1
      >>> lsblib.get_lsberrno()
      17
      >>> lsblib.lsb_perror("foo")
      foo: User permission denied
      >>> lsblib.lsb_sysmsg()
      u'User permission denied'
      >>> 

openlava.lsblib.lsb_queuecontrol(queue, opCode)

   Opens, closes, activates or inactivates a queue.

   Parameters:
      * **queue** (*str*) -- Name of queue to control

      * **opCode** (*int*) -- OpCode to use, one of either:
        lslblib.QUEUE_OPEN - open the queue; lsblib.QUEUE_CLOSED -
        close the queue; QUEUE_ACTIVATE - activate the queue;
        QUEUE_INACTIVATE - inactivate the queue

   Returns:
      0 on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("queuecontrol")
      0
      >>> lsblib.lsb_queuecontrol("normal", lsblib.QUEUE_CLOSED)
      -1

openlava.lsblib.lsb_queueinfo(queues=[], numqueues=0, hostname="", username="", options=0)

   Get information on specified queues.

   Parameters:
      * **queues** (*array*) -- list of queue names to get information
        on

      * **numqueues** (*int*) -- number of queues to get information
        on, if queues is empty, and numqueues=1, gets information on
        the default queue

      * **hostname** (*str*) -- get queues that can execute on
        hostname

      * **username** (*str*) -- get queues that username can submit to

      * **options** (*int*) -- Options

   Returns:
      array of QueueInfoEnt objects, None on error.

   Return type:
      array

   Note: Unlike the C api, numqueues is not set to to the number of queues
     returned as this is not supported in Python. Instead use len on
     the returned array.

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("testing")
      0
      >>> for q in lsblib.lsb_queueinfo():
      ...     print q.queue
      ... 
      normal
      >>> for q in lsblib.lsb_queueinfo(numqueues=1):
      ...     print q.queue
      ... 
      normal
      >>> for q in lsblib.lsb_queueinfo(hostname='master'):
      ...     print q.queue
      ... 
      normal
      >>> 

openlava.lsblib.lsb_readjobinfo()

   Get the next job in the list from the MBD.

   Note: The more parameter is not supported as passing integers as in/out
     parameters is not supported by Python.

   Parameters:
      **options** (*int*) -- Return jobs that match the following
      options, where option is a bitwise or of the following
      paramters: ALL_JOB - All jobs; CUR_JOB - All unfinished jobs;
      DONE_JOB - Jobs that have finished or exited; PEND_JOB - Jobs
      that are pending; SUSP_JOB - Jobs that are suspended; LAST_JOB -
      The last submitted job

   Returns:
      JobInfoEnt object or None on error

   Return type:
      JobInfoEnt

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("testing")
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...     job=lsblib.lsb_readjobinfo()
      ...     print job.jobId
      ... 
      4562
      >>> lsblib.lsb_closejobinfo()

openlava.lsblib.lsb_reconfig(opCode)

   Reloads configuration information for the batch system.

   Parameters:
      **opCode** (*int*) -- Operation to perform: lsblib.MBD_RESTART -
      restart the MBD; lsblib.MBD_RECONFIG - Reconfigure the MBD;
      lsblib.MBD_CKCONFIG - Check the configuration

   Returns:
      0 on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("mbd control")
      0
      >>> lsblib.lsb_reconfig(lsblib.MBD_CKCONFIG)
      -1
      >>>

openlava.lsblib.lsb_requeuejob(rq)

   Requeues a job.

   Parameters:
      **rq** (*JobRequeue*) -- JobRequeue object

   Returns:
      0 on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("requeue")
      0
      >>> rq=lsblib.JobRequeue()
      >>> rq.jobId=lsblib.create_job_id(4563,0)
      >>> rq.status=lsblib.JOB_STAT_PEND
      >>> rq.options=lsblib.REQUEUE_RUN
      >>> lsblib.lsb_requeuejob(rq)
      0

openlava.lsblib.lsb_signaljob(jobId, sigValue)

   Sends the specified signal to the job.

   Parameters:
      * **jobId** (*int*) -- Id of the job

      * **sigValue** (*int*) -- signal to send

   Returns:
      0 on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib 
      >>> lsblib.lsb_init("signaljob")
      0
      >>> lsblib.lsb_signaljob(4563, lsblib.SIGSTOP)
      0
      >>> lsblib.lsb_signaljob(4563, lsblib.SIGCONT)
      0

openlava.lsblib.lsb_submit(jobSubReq, jobSubReply)

   Submits a new job into the scheduling environment.

   Parameters:
      * **jobSubReq** (*Submit*) -- Submit object containing job
        submission information

      * **jobSubReply** (*SubmitReply*) -- SubmitReply object

   Returns:
      job_id on success, -1 on failure

   Return type:
      int

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("submit")
      0
      >>> sr=lsblib.Submit()
      >>> sr.command="hostname"
      >>> sr.numProcessors=1
      >>> sr.maxNumProcessors=1
      >>> srep=lsblib.SubmitReply()
      >>> lsblib.lsb_submit(sr, srep)
      Job <4564> is submitted to default queue <normal>.
      4564
      >>> 

openlava.lsblib.lsb_suspreason(reasons, subreasons, ld)

   Get reasons why a job is suspended

   Parameters:
      * **reasons** (*int*) -- reasons from jobinfoent

      * **subreasons** (*int*) -- subreasons from jobinfoent

      * **ld** (*LoadIndexLog*) -- LoadIndexLog with index names

   Returns:
      Description of why job is pending

   Return type:
      str

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("suspreasons")
      0
      >>> lsblib.lsb_signaljob(4563, lsblib.SIGSTOP)
      0
      >>> for i in range(lsblib.lsb_openjobinfo()):
      ...         job=lsblib.lsb_readjobinfo()
      ...         ld=lsblib.LoadIndexLog()
      ...         if job.status & lsblib.JOB_STAT_USUSP !=0 or job.status & lsblib.JOB_STAT_SSUSP != 0:
      ...                 print "Job %d: %s" % (job.jobId, lsblib.lsb_suspreason(job.reasons, job.subreasons, ld))
      ... 

      Job 4563:  The job was suspended by user;

openlava.lsblib.lsb_sysmsg()

   Get the lsblib error message associated with lsberrno

   Returns:
      LSBLIB error message

   Return type:
      str

      >>> from openlava import lsblib, lslib
      >>> lsblib.lsb_init("foo")
      0
      >>> lsblib.lsb_hostcontrol("foo", 2)
      -1
      >>> lsblib.get_lsberrno()
      17
      >>> lsblib.lsb_perror("foo")
      foo: User permission denied
      >>> lsblib.lsb_sysmsg()
      u'User permission denied'
      >>> 

openlava.lsblib.lsb_userinfo(user_list=[])

   Get information on specified users

   Note: Unlike in the C API, numusers is not set to the size of the
     returned array, as this is not supported in Python.

   Parameters:
      * **user_list** (*array*) -- List of usernames to get
        information on

      * **numusers** (*int*) -- ignored unless user_list is empty, if
        numusers is set to one, then returns information about the
        current user.

   Return type:
      array

   Returns:
      List of UserInfoEnt objects

      >>> from openlava import lsblib
      >>> lsblib.lsb_init("userinfo")
      0
      >>> for user in lsblib.lsb_userinfo():
      ...     print user.user
      ... 
      default
      root
      irvined
      >>> for user in lsblib.lsb_userinfo(user_list=[], numusers=1):
      ...     print user.user
      ... 
      irvined
      >>> 


Indices and tables
******************

* *Index*

* *Module Index*

* *Search Page*
