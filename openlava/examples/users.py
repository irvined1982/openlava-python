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
from openlava.lsblib import lsb_userinfo, lsb_init
import sys

if lsb_init("users") < 0:
	ls_perror("lsb_init")
	sys.exit(-1)

users=lsb_userinfo()
if users==None:
	ls_perror("lsb_userinfo")
print "User Information:"
for u in users:
	print "User: %s, Pend: %s, Running: %s, Suspended: %s" % (u.user, u.numPEND, u.numRUN, u.numSSUSP+u.numUSUSP)
