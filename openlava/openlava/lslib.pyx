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
"""

This module provides access to the openlava lslib C API.  Lslib enables applications to contact the LIM and RES daemons.

Usage
-----

Import the appropriate functions from each module::

    from openlava.lslib import ls_getclustername, ls_getmastername, ls_info    
    import sys


Get and print the clustername, if ls_getclustername() fails, it will return None::

    cluster = ls_getclustername();
    if cluster==None:
    	print "Unable to get clustername"
    	sys.exit(1)
    print "My cluster name is <%s>" %  cluster


Do the same for the master host name::

    master = ls_getmastername();
    if master==None:
    	print "Unable to get master"
    	sys.exit(1)
    print "Master host is <%s>" % master


Get information about resources on the cluster using ls_info()::

    lsInfo = ls_info()
    if lsInfo==None:
        print "Unable to get LSInfo"
        sys.exit(1)

    print "\n%-15.15s %s" % ("RESOURCE_NAME", "DESCRIPTION")
    for i in range(lsInfo.nRes):
        print "%-15.15s %s" % ( lsInfo.resTable[i].name, lsInfo.resTable[i].des)


Members
-------

"""

import cython
from libc.stdlib cimport malloc, free
from libc.string cimport strcmp, memset
from cpython.string cimport PyString_AsString

cimport openlava_base


cdef extern from "lsf.h":
	extern enum valueType: LS_BOOLEAN, LS_NUMERIC, LS_STRING, LS_EXTERNAL
	extern enum orderType: INCR, DECR, NA
	extern int lserrno
	extern struct clusterInfo:
		char  clusterName[128]
		int   status
		char  masterName[64]
		char  managerName[128]
		int   managerId
		int   numServers
		int   numClients
		int   nRes
		char  **resources
		int    nTypes
		char **hostTypes
		int    nModels
		char **hostModels
		int    nAdmins
		int  *adminIds
		char **admins
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

CLUST_STAT_OK      =         0x01
CLUST_STAT_UNAVAIL =         0x02


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

LSE_NO_ERR           =   0
LSE_BAD_XDR          =   1
LSE_MSG_SYS          =   2
LSE_BAD_ARGS         =   3
LSE_MASTR_UNKNW      =   4
LSE_LIM_DOWN         =   5
LSE_PROTOC_LIM       =   6
LSE_SOCK_SYS         =   7
LSE_ACCEPT_SYS       =   8
LSE_BAD_TASKF        =   9
LSE_NO_HOST          =   10
LSE_NO_ELHOST        =   11
LSE_TIME_OUT         =   12
LSE_NIOS_DOWN        =   13
LSE_LIM_DENIED       =   14
LSE_LIM_IGNORE       =   15
LSE_LIM_BADHOST      =   16
LSE_LIM_ALOCKED      =   17
LSE_LIM_NLOCKED      =   18
LSE_LIM_BADMOD       =   19
LSE_SIG_SYS          =   20
LSE_BAD_EXP          =   21
LSE_NORCHILD         =   22
LSE_MALLOC           =   23
LSE_LSFCONF          =   24
LSE_BAD_ENV          =   25
LSE_LIM_NREG         =   26
LSE_RES_NREG         =   27
LSE_RES_NOMORECONN   =   28
LSE_BADUSER          =   29
LSE_RES_ROOTSECURE   =   30
LSE_RES_DENIED       =   31
LSE_BAD_OPCODE       =   32
LSE_PROTOC_RES       =   33
LSE_RES_CALLBACK     =   34
LSE_RES_NOMEM        =   35
LSE_RES_FATAL        =   36
LSE_RES_PTY          =   37
LSE_RES_SOCK         =   38
LSE_RES_FORK         =   39
LSE_NOMORE_SOCK      =   40
LSE_WDIR             =   41
LSE_LOSTCON          =   42
LSE_RES_INVCHILD     =   43
LSE_RES_KILL         =   44
LSE_PTYMODE          =   45
LSE_BAD_HOST         =   46
LSE_PROTOC_NIOS      =   47
LSE_WAIT_SYS         =   48
LSE_SETPARAM         =   49
LSE_RPIDLISTLEN      =   50
LSE_BAD_CLUSTER      =   51
LSE_RES_VERSION      =   52
LSE_EXECV_SYS        =   53
LSE_RES_DIR          =   54
LSE_RES_DIRW         =   55
LSE_BAD_SERVID       =   56
LSE_NLSF_HOST        =   57
LSE_UNKWN_RESNAME    =   58
LSE_UNKWN_RESVALUE   =   59
LSE_TASKEXIST        =   60
LSE_BAD_TID          =   61
LSE_TOOMANYTASK      =   62
LSE_LIMIT_SYS        =   63
LSE_BAD_NAMELIST     =   64
LSE_LIM_NOMEM        =   65
LSE_NIO_INIT         =   66
LSE_CONF_SYNTAX      =   67
LSE_FILE_SYS         =   68
LSE_CONN_SYS         =   69
LSE_SELECT_SYS       =   70
LSE_EOF              =   71
LSE_ACCT_FORMAT      =   72
LSE_BAD_TIME         =   73
LSE_FORK             =   74
LSE_PIPE             =   75
LSE_ESUB             =   76
LSE_EAUTH            =   77
LSE_NO_FILE          =   78
LSE_NO_CHAN          =   79
LSE_BAD_CHAN         =   80
LSE_INTERNAL         =   81
LSE_PROTOCOL         =   82
LSE_MISC_SYS         =   83
LSE_RES_RUSAGE       =   84
LSE_NO_RESOURCE      =   85
LSE_BAD_RESOURCE     =   86
LSE_RES_PARENT       =   87
LSE_I18N_SETLC       =   88
LSE_I18N_CATOPEN     =   89
LSE_I18N_NOMEM       =   90
LSE_NO_MEM           =   91
LSE_FILE_CLOSE       =   92
LSE_MASTER_LIM_DOWN  =   93
LSE_MLS_INVALID      =   94
LSE_MLS_CLEARANCE    =   95
LSE_MLS_RHOST        =   96
LSE_MLS_DOMINATE     =   97
LSE_HOST_EXIST       =   98
LSE_NERR             =   99


def LS_ISUNAVAIL(status):
	"""openlava.lslib.LS_ISUNAVAIL(status)
	
Returns True if the LIM on the host is not available.  For example it is not running, or the host is down

:param int status: status of HostInfo object.
:return: True if LIM on host is not available, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_UNAVAIL) != 0

def LS_ISBUSY(status):
	"""openlava.lslib.LS_ISBUSY(status)
	
Returns true if the host is busy

:param int status: status of HostInfo object.
:return: True if the host is busy, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_BUSY) != 0

def LS_ISLOCKEDU(status):
	"""openlava.lslib.LS_ISLOCKEDU(status)
	
Returns true if the host has been locked by an administrator

:param int status: status of HostInfo object.
:return: if the host has been locked by an administrator, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True

"""

	return (status[0] & LIM_LOCKEDU) != 0

def LS_ISLOCKEDW(status):
	"""openlava.lslib.LS_ISLOCKEDW(status)
	
Returns true if the host is locked because its run window is closed

:param int status: status of HostInfo object.
:return: True if the host is locked because its run window is closed, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_LOCKEDW) != 0

def LS_ISLOCKEDM(status):
	"""openlava.lslib.LS_ISLOCKEDM(status)
	
Returns true if the host LIM is locked by the master LIM

:param int status: status of HostInfo object.
:return: True if the host LIM is locked by the master LIM, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_LOCKEDM) != 0

def LS_ISLOCKED(status):
	"""openlava.lslib.LS_ISLOCKED(status)
	
Returns true if the host is locked for any reason

:param int status: status of HostInfo object.
:return: True if the host is locked for any reason, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & (LIM_LOCKEDU | LIM_LOCKEDW | LIM_LOCKEDM)) != 0

def LS_ISRESDOWN(status):
	"""openlava.lslib.LS_ISRESDOWN(status)
	
Returns true if the RES is down on the host

:param int status: status of HostInfo object.
:return: True if the RES is down on the host, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True

"""

	return (status[0] & LIM_RESDOWN) != 0

def LS_ISSBDDOWN(status):
	"""openlava.lslib.LS_ISSBDDOWN(status)
	
Returns true if the SBD is down on the host

:param int status: status of HostInfo object.
:return: True if the SBD is down on the host, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_SBDDOWN) != 0


def LS_ISOK(status):
	"""openlava.lslib.LS_ISOK(status)
	
Returns true if the host is OK

:param int status: status of HostInfo object.
:return: True if the host is OK, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return (status[0] & LIM_OK_MASK) == 0

def LS_ISOKNRES(status):
	"""openlava.lslib.LS_ISOKNRES(status)
	
Returns true as long as the RES and SBD are not down

:param int status: status of HostInfo object.
:return: True as long as the RES and SBD are not down, else False
:rtype: bool

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_load():
	...     print "Host: %s: LS_ISUNAVAIL: %s" % (host.hostName, lslib.LS_ISUNAVAIL(host.status))
	...     print "Host: %s: LS_ISBUSY: %s" % (host.hostName, lslib.LS_ISBUSY(host.status))
	...     print "Host: %s: LS_ISLOCKEDU: %s" % (host.hostName, lslib.LS_ISLOCKEDU(host.status))
	...     print "Host: %s: LS_ISLOCKEDW: %s" % (host.hostName, lslib.LS_ISLOCKEDW(host.status))
	...     print "Host: %s: LS_ISLOCKEDM: %s" % (host.hostName, lslib.LS_ISLOCKEDM(host.status))
	...     print "Host: %s: LS_ISLOCKED: %s" % (host.hostName, lslib.LS_ISLOCKED(host.status))
	...     print "Host: %s: LS_ISRESDOWN: %s" % (host.hostName, lslib.LS_ISRESDOWN(host.status))
	...     print "Host: %s: LS_ISSBDDOWN: %s" % (host.hostName, lslib.LS_ISSBDDOWN(host.status))
	...     print "Host: %s: LS_ISOK: %s" % (host.hostName, lslib.LS_ISOK(host.status))
	...     print "Host: %s: LS_ISOKNRES: %s" % (host.hostName, lslib.LS_ISOKNRES(host.status))
	... 
	Host: master: LS_ISUNAVAIL: False
	Host: master: LS_ISBUSY: False
	Host: master: LS_ISLOCKEDU: False
	Host: master: LS_ISLOCKEDW: False
	Host: master: LS_ISLOCKEDM: False
	Host: master: LS_ISLOCKED: False
	Host: master: LS_ISRESDOWN: False
	Host: master: LS_ISSBDDOWN: False
	Host: master: LS_ISOK: True
	Host: master: LS_ISOKNRES: True
	Host: comp00: LS_ISUNAVAIL: True
	Host: comp00: LS_ISBUSY: False
	Host: comp00: LS_ISLOCKEDU: False
	Host: comp00: LS_ISLOCKEDW: False
	Host: comp00: LS_ISLOCKEDM: False
	Host: comp00: LS_ISLOCKED: False
	Host: comp00: LS_ISRESDOWN: False
	Host: comp00: LS_ISSBDDOWN: False
	Host: comp00: LS_ISOK: False
	Host: comp00: LS_ISOKNRES: True


"""

	return ((status[0]) & (LIM_RESDOWN | LIM_SBDDOWN)) == 0

cdef char ** to_cstring_array(list_str):
	cdef char **ret = <char **>malloc(len(list_str) * sizeof(char *))
	for i in xrange(len(list_str)):
		ret[i] = PyString_AsString(list_str[i])
	return ret


def ls_clusterinfo(resReq="", numclusters=0, clusterList=[], listsize=0, options=0):
	"""openlava.lslib.ls_clusterinfo(resReq="", numclusters=0, clusterList=[], listsize=0, options=0)
Returns an array of ClusterInfo objects.

:param str resReq: select clusters that can satisfy the resources requested
:param int numclusters: Ignored
:param array clusterList: Array of cluster names, will return only clusters that match
:param int listsize: ignored
:param int options: ignored
:returns: Array of ClusterInfo objects, or None on error
:rtype: Array or None
"""
	cdef int nClusters
	nClusters=0
	cdef clusterInfo * cinfo
	cdef char * resreq
	resreq=NULL
	if (resReq > 0):
		resreq=resReq
	cdef int listSize
	listSize=len(clusterList)
	cdef char ** clusterlist
	clusterlist=NULL
	if listSize > 0:
		clusterlist=to_cstring_array(clusterList)
	cinfo=openlava_base.ls_clusterinfo(resreq, &nClusters, clusterlist, listSize, options)
	if cinfo==NULL:
		return None
	# iterate and populat
	ci=[]
	for i in xrange(nClusters):
		c=ClusterInfo()
		c._load_struct(&cinfo[i])
		ci.append(c)
	return ci


def get_lserrno():
	"""openlava.lslib.get_lserrno()

Returns the lserrno

:return: LS Errno
:rtype: int

::

	LSE_NO_ERR           =   0
	LSE_BAD_XDR          =   1
	LSE_MSG_SYS          =   2
	LSE_BAD_ARGS         =   3
	LSE_MASTR_UNKNW      =   4
	LSE_LIM_DOWN         =   5
	LSE_PROTOC_LIM       =   6
	LSE_SOCK_SYS         =   7
	LSE_ACCEPT_SYS       =   8
	LSE_BAD_TASKF        =   9
	LSE_NO_HOST          =   10
	LSE_NO_ELHOST        =   11
	LSE_TIME_OUT         =   12
	LSE_NIOS_DOWN        =   13
	LSE_LIM_DENIED       =   14
	LSE_LIM_IGNORE       =   15
	LSE_LIM_BADHOST      =   16
	LSE_LIM_ALOCKED      =   17
	LSE_LIM_NLOCKED      =   18
	LSE_LIM_BADMOD       =   19
	LSE_SIG_SYS          =   20
	LSE_BAD_EXP          =   21
	LSE_NORCHILD         =   22
	LSE_MALLOC           =   23
	LSE_LSFCONF          =   24
	LSE_BAD_ENV          =   25
	LSE_LIM_NREG         =   26
	LSE_RES_NREG         =   27
	LSE_RES_NOMORECONN   =   28
	LSE_BADUSER          =   29
	LSE_RES_ROOTSECURE   =   30
	LSE_RES_DENIED       =   31
	LSE_BAD_OPCODE       =   32
	LSE_PROTOC_RES       =   33
	LSE_RES_CALLBACK     =   34
	LSE_RES_NOMEM        =   35
	LSE_RES_FATAL        =   36
	LSE_RES_PTY          =   37
	LSE_RES_SOCK         =   38
	LSE_RES_FORK         =   39
	LSE_NOMORE_SOCK      =   40
	LSE_WDIR             =   41
	LSE_LOSTCON          =   42
	LSE_RES_INVCHILD     =   43
	LSE_RES_KILL         =   44
	LSE_PTYMODE          =   45
	LSE_BAD_HOST         =   46
	LSE_PROTOC_NIOS      =   47
	LSE_WAIT_SYS         =   48
	LSE_SETPARAM         =   49
	LSE_RPIDLISTLEN      =   50
	LSE_BAD_CLUSTER      =   51
	LSE_RES_VERSION      =   52
	LSE_EXECV_SYS        =   53
	LSE_RES_DIR          =   54
	LSE_RES_DIRW         =   55
	LSE_BAD_SERVID       =   56
	LSE_NLSF_HOST        =   57
	LSE_UNKWN_RESNAME    =   58
	LSE_UNKWN_RESVALUE   =   59
	LSE_TASKEXIST        =   60
	LSE_BAD_TID          =   61
	LSE_TOOMANYTASK      =   62
	LSE_LIMIT_SYS        =   63
	LSE_BAD_NAMELIST     =   64
	LSE_LIM_NOMEM        =   65
	LSE_NIO_INIT         =   66
	LSE_CONF_SYNTAX      =   67
	LSE_FILE_SYS         =   68
	LSE_CONN_SYS         =   69
	LSE_SELECT_SYS       =   70
	LSE_EOF              =   71
	LSE_ACCT_FORMAT      =   72
	LSE_BAD_TIME         =   73
	LSE_FORK             =   74
	LSE_PIPE             =   75
	LSE_ESUB             =   76
	LSE_EAUTH            =   77
	LSE_NO_FILE          =   78
	LSE_NO_CHAN          =   79
	LSE_BAD_CHAN         =   80
	LSE_INTERNAL         =   81
	LSE_PROTOCOL         =   82
	LSE_MISC_SYS         =   83
	LSE_RES_RUSAGE       =   84
	LSE_NO_RESOURCE      =   85
	LSE_BAD_RESOURCE     =   86
	LSE_RES_PARENT       =   87
	LSE_I18N_SETLC       =   88
	LSE_I18N_CATOPEN     =   89
	LSE_I18N_NOMEM       =   90
	LSE_NO_MEM           =   91
	LSE_FILE_CLOSE       =   92
	LSE_MASTER_LIM_DOWN  =   93
	LSE_MLS_INVALID      =   94
	LSE_MLS_CLEARANCE    =   95
	LSE_MLS_RHOST        =   96
	LSE_MLS_DOMINATE     =   97
	LSE_HOST_EXIST       =   98
	LSE_NERR             =   99
	
	>>> from openlava import lslib
	>>> lslib.get_lserrno()
	81
	>>> lslib.ls_perror("Test:")
	Test:: Internal library error
	>>> lslib.ls_sysmsg()
	u'Internal library error'
	>>> 


"""

	return lserrno

def ls_getclustername():
	"""openlava.lslib.ls_getclustername()

Returns the name of the cluster

:return: Name of the cluster
:rtype: str

::

	>>> from openlava import lslib
	>>> lslib.ls_getclustername()
	u'openlava'

"""
	return u"%s" % openlava_base.ls_getclustername()

def ls_gethostfactor(hostname):
	"""openlava.lslib.ls_gethostfactor(hostname)

Returns the host factor of the host

:param str hostname: Name of host to get hostfactor
:return: hostfactor
:rtype: float

::

	>>> from openlava import lslib
	>>> lslib.ls_gethostfactor("master")
	100.0
	>>> 


"""
	cdef float *factor
	factor = openlava_base.ls_gethostfactor(hostname)
	return factor[0]

def ls_gethostinfo(resReq="", hostList=[], options=0):
	"""openlava.lslib.ls_gethostinfo(resReq="", hostList=[], options=0)

Returns an array of HostInfo objects that meet the criteria specified

:param str resReq: Filter on hosts that meet the following resource request
:param array hostList: return from the following list of hosts
:param int options: Options
:return: array of HostInfo objects or None on error
:rtype: array

::

	>>> from openlava import lslib
	>>> for host in lslib.ls_gethostinfo():
	...     print host.hostName
	... 
	master
	comp00
	comp01
	comp02
	comp03
	comp04
	>>> 

"""
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
	"""openlava.lslib.ls_gethostmodel(hostname)

Returns the model name of the host

:param str hostname: Name of host to get host model
:return: host model
:rtype: str

::

	>>> from openlava import lslib
	>>> lslib.ls_gethostmodel("master")
	u'IntelI5'
	>>> 


"""

	cdef char * model=openlava_base.ls_gethostmodel(hostname)
	if model==NULL:
		return None
	return unicode(model)

def ls_gethosttype(hostname):
	"""openlava.lslib.ls_gethosttype(hostname)

Returns the type of the host

:param str hostname: Name of host to get host type
:return: host type
:rtype: str

::

	>>> from openlava import lslib
	>>> lslib.ls_gethosttype("master")
	u'linux'
	>>> 


"""

	cdef char * hosttype=openlava_base.ls_gethosttype(hostname)
	if hosttype==NULL:
		return None
	return unicode(hosttype)

def ls_getmastername():
	"""openlava.lslib.ls_getmastername()

Returns the name of the master host

:return: master host
:rtype: str

::

	>>> from openlava import lslib
	>>> lslib.ls_getmastername()
	u'master'
	>>>


"""
	return u"%s" % openlava_base.ls_getmastername()

def ls_info():
	"""openlava.lslib.ls_info()

Returns an LsInfo object for the cluster

:return: LsInfo object for the cluster
:rtype: LsInfo

::

	>>> from openlava import lslib
	>>> info=lslib.ls_info()
	>>> info.hostTypes
	[u'linux']


"""

	cdef lsInfo * l
	l=openlava_base.ls_info()
	if l==NULL:
		return None
	ls=LsInfo()
	ls._load_struct(l)
	return ls

def ls_load(resreq=None, numhosts=0, options=0, fromhost=None):
	"""openlava.lslib.ls_load(resreq=None, numhosts=0, options=0, fromhost=None)
	
Returns an array of HostLoad objects for hosts that meet the criteria

:param str resreq: Resource request that hosts must satisfy
:param int numhosts: if None, return only one host. if zero, return all matching hosts.
:param int options: flags that affect how the hostlist is created
:param str fromhost: when used with DFT_FROMTYPE option sets the default resource requirements to that of jobs submitted from fromhost
:return: Array of HostLoad objects
:rtype: array

::

	#options
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
	>>> from openlava import lslib
	>>> hosts=lslib.ls_load(options=lslib.OK_ONLY)
	>>> for i in hosts:
	...     print i.hostName
	... 
	master
	>>> 


"""
	cdef hostLoad *hosts
	cdef char *resReq
	resReq=NULL
	if resreq:
		resreq=str(resreq)
		resReq=resreq
	cdef int numHosts
	options=int(options)
	cdef char * fromHost
	fromHost=NULL
	if fromhost:
		fromhost=str(fromhost)
		fromHost=fromhost

	if numhosts==None:
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

def ls_loadinfo(resreq=None, numhosts=0, options=0, fromhost=None, hostlist=[], indxnamelist=[]):
	"""openlava.lslib.ls_loadinfo(resreq=None, numhosts=0, options=0, fromhost=None, hostlist=[], indxnamelist=[])

Returns an array of HostLoad objects for hosts that meet the specified criteria

:param str resreq: Resource request that hosts must satisfy
:param int numhosts: if None, return only one host. if zero, return all matching hosts.
:param int options: flags that affect how the hostlist is created
:param str fromhost: when used with DFT_FROMTYPE option sets the default resource requirements to that of jobs submitted from fromhost
:param array hostlist: Hostnames to select from
:param array indxnamelist: When empty returns all load indexes, else returns loadindexes specified in indxnamelist
:return: Array of HostLoad objects
:rtype: array

::

	#options
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
	>>> from openlava import lslib
	>>> hosts=lslib.ls_loadinfo(hostlist=['master'])
	>>> print hosts[0].hostName
	master
	>>> 

"""
	cdef hostLoad *hosts
	cdef char *resReq
	resReq=NULL
	if resreq:
		resreq=str(resreq)
		resReq=resreq
	cdef int numHosts
	options=int(options)
	cdef char * fromHost
	fromHost=NULL
	if fromhost:
		fromhost=str(fromhost)
		fromHost=fromhost
	cdef char **hostList
	hostList=NULL
	if len(hostlist)>0:
		hostList=to_cstring_array(hostlist)
	cdef int listsize
	listsize=len(hostlist)
	cdef char ** IndexList
	IndexList=NULL
	if len(indxnamelist)>0:
		IndexList=to_cstring_array(indxnamelist)
	
	if numhosts==None:
		hosts = openlava_base.ls_loadinfo(resReq, NULL, options, fromHost, hostList, listsize, &IndexList)
		numHosts=1
	else:
		numHosts=int(numhosts)
		hosts = openlava_base.ls_loadinfo(resReq, &numHosts, options, fromHost, hostList, listsize, &IndexList)
	free(hostList)
	if hosts==NULL:
		return None
	hlist=[]
	for i in range(numHosts):
		h=HostLoad()
		h._load_struct(&hosts[i])
		hlist.append(h)
	return hlist	
	
def ls_perror(message):
	"""openlava.lslib.ls_perror(message)

Prints the lslib error message associated with the lserrno prefixed by message.

:param str message: User defined error message
:return: None
:rtype: None

::

	>>> from openlava import lslib
	>>> lslib.get_lserrno()
	81
	>>> lslib.ls_perror("Test:")
	Test:: Internal library error
	>>> lslib.ls_sysmsg()
	u'Internal library error'
	>>> 

"""

	cdef char * m
	message=str(message)
	m=message
	openlava_base.ls_perror(m)

def ls_sysmsg():
	"""openlava.lsblib.lsb_sysmsg()

Get the lslib error message associated with lserrno

:return: LSLIB error message
:rtype: str

::

	>>> from openlava import lslib
	>>> lslib.get_lserrno()
	81
	>>> lslib.ls_perror("Test:")
	Test:: Internal library error
	>>> lslib.ls_sysmsg()
	u'Internal library error'
	>>>
	
"""

	cdef char * msg
	msg=openlava_base.ls_sysmsg()
	if msg==NULL:
		return u""
	else:
		return u"%s" % msg
	

cdef class ClusterInfo:
	cdef clusterInfo * _data
	cdef _load_struct(self, clusterInfo * data):
		self._data=data

	property clusterName:
		def __get__(self):
			return u"%s" % self._data.clusterName

	property status:
		def __get__(self):
			return self._data.status

	property masterName:
		def __get__(self):
			return u"%s" % self._data.masterName

	property managerName:
		def __get__(self):
			return u"%s" % self._data.managerName

	property managerId:
		def __get__(self):
			return self._data.managerId

	property numServers:
		def __get__(self):
			return self._data.numServers

	property numClients:
		def __get__(self):
			return self._data.numClients

	property nRes:
		def __get__(self):
			return self._data.nRes

	property resources:
		def __get__(self):
			return [u"%s" % self._data.resources[i] for i in range(self.nRes)]

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

	property nAdmins:
		def __get__(self):
			return self._data.nAdmins
	property adminIds:
		def __get__(self):
			return [self._data.adminIds[i] for i in range(self.nAdmins)]
	property admins:
		def __get__(self):
			return [u"%s" % self._data.admins[i] for i in range(self.nAdmins)]
	

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



