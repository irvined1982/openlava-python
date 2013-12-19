#!/usr/bin/env python
# Copyright 2013 David Irvine
#
# This file is part of openlava-python
#
# openlava-python is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# openlava-python is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with openlava-python.  If not, see <http://www.gnu.org/licenses/>.
from openlava.lslib import ls_gethostinfo
import sys
hostinfo = ls_gethostinfo()
if hostinfo == None:
	print "Unable to get hostinfo"
	sys.exit(1)

print "%-11.11s %8.8s %6.6s %6.6s %9.9s" % (  "HOST_NAME", "type", "maxMem", "ncpus", "RESOURCES")

for host in hostinfo:
	sys.stdout.write( "%-11.11s %8.8s " % ( host.hostName, host.hostType ) )
	if (host.maxMem > 0):
		sys.stdout.write("%6d " % host.maxMem)
	else:
		sys.stdout.write("%6.6s " % "-")


	if (host.maxCpus > 0):
		sys.stdout.write("%6d " % host.maxCpus)
	else:
		sys.stdout.write("%6.6s" % "-")
	for res in host.resources:
		sys.stdout.write(" %s" % res)
	sys.stdout.write("\n")
