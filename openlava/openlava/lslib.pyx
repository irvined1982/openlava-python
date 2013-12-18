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
import cython
cimport openlava_base

LSF_DEFAULT_SOCKS =      15
MAXLINELEN        =      512
MAXLSFNAMELEN     =      128
MAXSRES           =      32
MAXRESDESLEN      =      256
NBUILTINDEX       =      11
MAXTYPES          =      128
MAXMODELS         =      128
MAXTYPES_31       =      25
MAXMODELS_31      =      30
MAXFILENAMELEN    =      256
FIRST_RES_SOCK    =      20

def ls_getclustername():
	return openlava_base.ls_getclustername()

def ls_getmastername():
	return openlava_base.ls_getmastername()

cdef extern from "lsf.h":
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

cdef class ResItem:
	cdef resItem * data
	cdef _load_struct(self, resItem * data):
		self.data=data

	property name:
		def __get__(self):
			return u"%s" % self.data.name

	property des:
		def __get__(self):
			return u"%s" % self.data.des

	property flags:
		def __get__(self):
			return self.data.flags

	property interval:
		def __get__(self):
			return self.data.interval

	property valueType:
		def __get__(self):
			if self.data.valueType==LS_BOOLEAN:
				return "LS_BOOLEAN"
			elif self.data.valueType==LS_NUMERIC:
				return "LS_NUMERIC"
			elif self.data.valueType==LS_STRING:
				return "LS_STRING"
			elif self.data.valueType==LS_EXTERNAL:
				return "LS_EXTERNAL"

	property orderType:
		def __get__(self):
			if self.data.orderType==INCR:
				return "INCR"
			elif self.data.orderType==DECR:
				return "DECR"
			elif self.data.orderType==NA:
				return "NA"

cdef class LsInfo:
	cdef lsInfo * _data
	cdef _load_struct(self, lsInfo * data):
		self._data=data

	property nRes:
		def __get__(self):
			return self._data.nRes

	property resTable:
		def __get__(self):
			t=[]
			for i in range(self.nRes):
				r=ResItem()
				r._load_struct(&self._data.resTable[i])
				t.append(r)
			return t

	property nTypes:
		def __get__(self):
			return self._data.nTypes

	property hostTypes:
		def __get__(self):
			return [u"%s" % self._data.hostTypes[i] for i in range(self.nTypes)]

	property nModels:
		def __get__(self):
			return self._data.nModels

	property hostModels:
		def __get__(self):
			return [u"%s" % self._data.hostModels[i] for i in range(self.nModels)]

	property hostArchs:
		def __get__(self):
			return [u"%s" % self._data.hostArchs[i] for i in range(self.nModels)]

	property modelRefs:
		def __get__(self):
			return [int(self._data.modelRefs[i]) for i in range(self.nModels)]

	property cpuFactor:
		def __get__(self):
			return [float(self._data.cpuFactor[i]) for i in range(self.nModels)]

	property numIndx:
		def __get__(self):
			return self._data.numIndx

	property numUsrIndx:
		def __get__(self):
			return self._data.numUsrIndx


def ls_info():
	cdef lsInfo * l
	l=openlava_base.ls_info()
	if l==NULL:
		return None
	ls=LsInfo()
	ls._load_struct(l)
	return ls




