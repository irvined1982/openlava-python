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
from openlava.lslib import ls_load,LS_ISUNAVAIL, LS_ISBUSY, LS_ISLOCKED, R1M, INFINIT_LOAD
import sys
hosts = ls_load()
if hosts == None:
	print "Unable to get host load"
	sys.exit(1)
print "%-15.15s %6.6s %6.6s" % ("HOST_NAME", "status", "r1m")

for host in hosts:

	sys.stdout.write( "%-11.11s " % host.hostName )
	if (LS_ISUNAVAIL(host.status)):
		sys.stdout.write("%6.6s " % "unavail")
	elif LS_ISBUSY(host.status):
		sys.stdout.write("%6.6s " % "busy")
	elif LS_ISLOCKED(host.status):
		sys.stdout.write("%6.6s " % "locked")
	else:
		sys.stdout.write("%6.6s " % "ok")

	if host.li[R1M] >= INFINIT_LOAD:
		print "%6.6s " % "-"
	else:
		print "%6.6s " % host.li[R1M]
