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



cdef extern from "lsf.h":
	extern char * ls_getclustername()
	extern char * ls_getmastername()
	extern lsInfo *ls_info()

	extern enum valueType: LS_BOOLEAN, LS_NUMERIC, LS_STRING, LS_EXTERNAL
	extern enum orderType: INCR, DECR, NA

	extern struct resItem:
		char name[128]
		char des[256]
		valueType valueType
		orderType orderType
		int  flags
		int  interval

	extern struct lsInfo:
		int    nRes
		resItem *resTable
		int    nTypes
		char   hostTypes[128][128]
		int    nModels
		char   hostModels[128][128]
		char   hostArchs[128][128]
		int    modelRefs[128]
		float  cpuFactor[128]
		int    numIndx
		int    numUsrIndx
