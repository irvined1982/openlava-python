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
from openlava.lslib import ls_perror, INFINIT_INT
from openlava.lsblib import lsb_init, lsb_hostinfo, HOST_STAT_UNAVAIL, HOST_STAT_UNREACH, HOST_STAT_BUSY, HOST_STAT_WIND ,HOST_STAT_DISABLED, HOST_STAT_LOCKED, HOST_STAT_FULL, HOST_STAT_NO_LIM
import sys

if lsb_init("Hosts") < 0:
		lsb_perror("lsb_init")
		sys.exit(-1)

hosts=lsb_hostinfo()
if hosts==None:
	lsb_perror("lsb_hostinfo");
	sys.exit(-1)

print "HOST_NAME    STATUS    JL/U  NJOBS  RUN  SSUSP USUSP"
for h in hosts:
	if h.hStatus & HOST_STAT_UNAVAIL:
		status="unavail"
	elif h.hStatus & HOST_STAT_UNREACH:
		status="unreach"
	elif h.hStatus & ( HOST_STAT_BUSY | HOST_STAT_WIND | HOST_STAT_DISABLED | HOST_STAT_LOCKED | HOST_STAT_FULL | HOST_STAT_NO_LIM ):
		status="closed"
	else:
		status="ok"
	if h.userJobLimit < INFINIT_INT:
		lim=h.userJobLimit
	else:
		lim="-"

	print "%-18.18s %-9s %-4s %7d  %4d  %4d  %4d" % ( h.host, status, lim, h.numJobs, h.numRUN, h.numSSUSP, h.numUSUSP)
