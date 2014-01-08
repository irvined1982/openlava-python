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
from libc.stdlib cimport malloc, free
from libc.string cimport strcmp, memset
from cpython.string cimport PyString_AsString

cimport openlava_base

cdef extern from "lsf.h":
	extern int lserrno
	extern enum valueType: LS_BOOLEAN, LS_NUMERIC, LS_STRING, LS_EXTERNAL
	extern enum orderType: INCR, DECR, NA
	
	extern struct hostInfo:
		char  hostName[64]
		char  *hostType
		char  *hostModel
		float cpuFactor
		int   maxCpus
		int   maxMem
		int   maxSwap
		int   maxTmp
		int   nDisks
		int   nRes
		char  **resources
		char  *windows
		int   numIndx
		float *busyThreshold
		char  isServer
		int   rexPriority

	extern struct hostLoad:
		char  hostName[64]
		int   *status
		float *li

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

	extern struct resItem:
		char name[128]
		char des[256]
		valueType valueType
		orderType orderType
		int  flags
		int  interval

FIRST_RES_SOCK    =      20
INFINIT_LOAD      = float(0x7fffffff)
INFINIT_FLOAT     = float(0x7fffffff)
INFINIT_INT       = int(0x7fffffff)
INFINIT_LONG_INT  = int(0x7fffffff)
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

LSF_DEFAULT_SOCKS =      15
MAXFILENAMELEN    =      256
MAXHOSTNAMELEN    =      64
MAXLINELEN        =      512
MAXLSFNAMELEN     =      128
MAXMODELS         =      128
MAXMODELS_31      =      30
MAXSRES           =      32
MAXRESDESLEN      =      256
MAXTYPES          =      128
MAXTYPES_31       =      25

NBUILTINDEX       =      11

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

LSF_RLIM_NLIMITS=11
DEFAULT_RLIMIT=-1

R15S                 =  0
R1M                  =  1
R15M                 =  2
UT                   =  3
PG                   =  4
IO                   =  5
LS                   =  6
IT                   =  7
TMP                  =  8
SWP                  =  9
MEM                  =  10
USR1                 =  11
USR2                 =  12

LIM_UNAVAIL          =  0x00010000
LIM_LOCKEDU          =  0x00020000
LIM_LOCKEDW          =  0x00040000
LIM_BUSY             =  0x00080000
LIM_RESDOWN          =  0x00100000
LIM_LOCKEDM          =  0x00200000
LIM_OK_MASK          =  0x00bf0000
LIM_SBDDOWN          =  0x00400000

def LS_ISUNAVAIL(status):
	return (status[0] & LIM_UNAVAIL) != 0

def LS_ISBUSY(status):
	return (status[0] & LIM_BUSY) != 0

def LS_ISLOCKEDU(status):
	return (status[0] & LIM_LOCKEDU) != 0

def LS_ISLOCKEDW(status):
	return (status[0] & LIM_LOCKEDW) != 0

def LS_ISLOCKEDM(status):
	return (status[0] & LIM_LOCKEDM) != 0

def LS_ISLOCKED(status):
	return (status[0] & (LIM_LOCKEDU | LIM_LOCKEDW | LIM_LOCKEDM)) != 0

def LS_ISRESDOWN(status):
	return (status[0] & LIM_RESDOWN) != 0

def LS_ISSBDDOWN(status):
	return (status[0] & LIM_SBDDOWN) != 0
 
def LS_ISOK(status):
	return (status[0] & LIM_OK_MASK) == 0

def LS_ISOKNRES(status):
	return ((status[0]) & (LIM_RESDOWN | LIM_SBDDOWN)) == 0

cdef char ** to_cstring_array(list_str):
	cdef char **ret = <char **>malloc(len(list_str) * sizeof(char *))
	for i in xrange(len(list_str)):
		ret[i] = PyString_AsString(list_str[i])
	return ret

def get_lserrno():
	return lserrno

def ls_getclustername():
	return openlava_base.ls_getclustername()

def ls_gethostfactor(hostname):
	return 0.0
#	cdef float *factor
#	factor= openlava_base.ls_gethostfactor(hostname)
#	cdef float f
#	f=<float> factor

def ls_gethostinfo(resReq="", hostList=[], options=0):
	host_list=[]
	cdef hostInfo * h
	cdef int numHosts
	cdef char **hosts
	cdef char * resourceRequest
	resourceRequest=resReq
	numHosts=0
	hosts=NULL
	if len(hostList)>0:
		hosts=to_cstring_array(hostList)

	h=openlava_base.ls_gethostinfo(resourceRequest, &numHosts, hosts, len(hostList), options)
	if h==NULL:
		return None

	for a in range(numHosts):
		i=HostInfo()
		i._load_struct(&h[a])
		host_list.append(i)
	return host_list

def ls_gethostmodel(hostname):
	return unicode(openlava_base.ls_gethostmodel(hostname))

def ls_gethosttype(hostname):
	return unicode(openlava_base.ls_gethosttype(hostname))

def ls_getmastername():
	return openlava_base.ls_getmastername()

def ls_info():
	cdef lsInfo * l
	l=openlava_base.ls_info()
	if l==NULL:
		return None
	ls=LsInfo()
	ls._load_struct(l)
	return ls

def ls_load(resreq="", numhosts=0, options=0, fromhost=None):
	cdef hostLoad *hosts
	cdef char *resReq
	resreq=str(resreq)
	resReq=resreq
	cdef int numHosts
	options=int(options)
	cdef char * fromHost
	fromHost=NULL
	if fromhost:
		fromhost=str(fromhost)
		fromHost=fromhost

	if numHosts==None:
		hosts = openlava_base.ls_load(resReq, NULL, options, fromHost)
		numHosts=1
	else:
		numHosts=int(numhosts)
		hosts = openlava_base.ls_load(resReq, &numHosts, options, fromHost);
	if hosts==NULL:
		return None

	hlist=[]
	for i in range(numHosts):
		h=HostLoad()
		h._load_struct(&hosts[i])
		hlist.append(h)
	return hlist

def ls_perror(message):
	cdef char * m
	message=str(message)
	m=message
	openlava_base.ls_perror(m)

def ls_sysmsg():
	return openlava_base.ls_sysmsg()


cdef class HostInfo:
	cdef hostInfo * _data
	cdef _load_struct(self, hostInfo * data):
		self._data=data

	property hostName:
		def __get__(self):
			return u"%s" % self._data.hostName

	property hostType:
		def __get__(self):
			return u"%s" % self._data.hostType

	property hostModel:
		def __get__(self):
			return u"%s" % self._data.hostModel

	property cpuFactor:
		def __get__(self):
			return float(self._data.cpuFactor)

	property maxCpus:
		def __get__(self):
			return int(self._data.maxCpus)

	property maxMem:
		def __get__(self):
			return int(self._data.maxMem)

	property maxSwap:
		def __get__(self):
			return int(self._data.maxSwap)

	property maxTmp:
		def __get__(self):
			return int(self._data.maxTmp)

	property nDisks:
		def __get__(self):
			return int(self._data.nDisks)

	property nRes:
		def __get__(self):
			return int(self._data.nRes)

	property resources:
		def __get__(self):
			return [u"%s" % self._data.resources[i] for i in range(self.nRes)]

	property windows:
		def __get__(self):
			return u"%s" % self._data.windows

	property numIndx:
		def __get__(self):
			return int(self._data.numIndx)

	property busyThreshold:
		def __get__(self):
			return [float(self._data.busyThreshold[i]) for i in range(self.numIndx)]

	property isServer:
		def __get__(self):
			if self._data.isServer>0:
				return True
			else:
				return False

	property rexPriority:
		def __get__(self):
			return int(self._data.rexPriority)

cdef class HostLoad:
	cdef hostLoad * _data
	cdef _load_struct(self, hostLoad * data):
		self._data=data

	property hostName:
		def __get__(self):
			return u"%s" % self._data.hostName

	property status:
		def __get__(self):
			return [ 
					int(self._data.status[0]),
					int(self._data.status[1]),
					]

	property li:
		def __get__(self):
			return [self._data.li[i] for i in range(12)]

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
			return int(self.data.flags)

	property interval:
		def __get__(self):
			return int(self.data.interval)

	property valueType:
		def __get__(self):
			if self.data.valueType==LS_BOOLEAN:
				return u"LS_BOOLEAN"
			elif self.data.valueType==LS_NUMERIC:
				return u"LS_NUMERIC"
			elif self.data.valueType==LS_STRING:
				return u"LS_STRING"
			elif self.data.valueType==LS_EXTERNAL:
				return u"LS_EXTERNAL"

	property orderType:
		def __get__(self):
			if self.data.orderType==INCR:
				return u"INCR"
			elif self.data.orderType==DECR:
				return u"DECR"
			elif self.data.orderType==NA:
				return u"NA"



