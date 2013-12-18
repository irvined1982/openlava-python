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
from openlava.lslib import ls_getclustername, ls_getmastername, ls_info
import sys
cluster = ls_getclustername();
if cluster==None:
	print "Unable to get clustername"
	sys.exit(1)
print "My cluster name is <%s>" %  cluster
master = ls_getmastername();
if master==None:
	print "Unable to get master"
	sys.exit(1)
print "Master host is <%s>" % master
lsInfo = ls_info()
if lsInfo==None:
	print "Unable to get LSInfo"
	sys.exit(1)

print "\n%-15.15s %s" % ("RESOURCE_NAME", "DESCRIPTION")
for i in range(lsInfo.nRes):
	print "%-15.15s %s" % ( lsInfo.resTable[i].name, lsInfo.resTable[i].des)
