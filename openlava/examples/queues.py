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
from openlava.lsblib import lsb_init, lsb_queueinfo

if lsb_init("queue info")<0:
	lsb_perror("lsb_init() failed")
	sys.exit(-1)


qlist=lsb_queueinfo()
if qlist==None:
	lsb_perror("lsb_queueinfo() failed")
	sys.exit(-1)

for q in qlist:
	max_slots="unlimited"
	if q.maxJobs<INFINIT_INT:
		max_slots=q.maxJobs

	print "Information about %s queue:" % q.queue
	print " Description: %s" % q.description
	print " Priority: %d         Nice: %d:" % (q.priority, q.nice)
	print " Max Job Slots: %s" % max_slots
	print " Job slot statistics: PEND(%d) RUN(%d) SUSP(%d) TOTAL(%d)." % ( q.numPEND, q.numRUN, q.numSSUSP+q.numUSUSP, q.numJobs)
