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
from openlava.lslib import ls_perror
from openlava.lsblib import lsb_openjobinfo, lsb_readjobinfo, lsb_closejobinfo, lsb_init
import sys


if lsb_init("jobs") < 0:
	ls_perror("lsb_init")
	sys.exit(-1)

numJobs=lsb_openjobinfo()
if numJobs < 0:
        ls_perror("lsb_openjobinfo")
        sys.exit(-1)

print "All jobs submitted by all users:"
for i in range(numJobs):
	job = lsb_readjobinfo()
	if job == None:
		ls_perror("lsb_readjobinfo")
		sys.exit(-1)
	print "Job ID: %s User: %s Submit Host: %s" % (job.jobId, job.user, job.fromHost)
lsb_closejobinfo()
