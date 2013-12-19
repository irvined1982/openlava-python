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


cdef extern from "lsbatch.h":
	extern int lsb_init (char *appName)
	extern struct queueInfoEnt:
		char   *queue
		char   *description
		int    priority
		short  nice
		char   *userList
		char   *hostList
		int    nIdx
		float  *loadSched
		float  *loadStop
		int    userJobLimit
		float  procJobLimit
		char   *windows
		int    rLimits[11]
		char   *hostSpec
		int    qAttrib
		int    qStatus
		int    maxJobs
		int    numJobs
		int    numPEND
		int    numRUN
		int    numSSUSP
		int    numUSUSP
		int    mig
		int    schedDelay
		int    acceptIntvl
		char   *windowsD
		char   *defaultHostSpec
		int    procLimit
		char   *admins
		char   *preCmd
		char   *postCmd
		char   *prepostUsername
		char   *requeueEValues
		int    hostJobLimit
		char   *resReq
		int    numRESERVE
		int    slotHoldTime
		char   *resumeCond
		char   *stopCond
		char   *jobStarter
		char   *suspendActCmd
		char   *resumeActCmd
		char   *terminateActCmd
		int    sigMap[23]
		char   *chkpntDir
		int    chkpntPeriod
		int    defLimits[11]
		int    minProcLimit
		int    defProcLimit

	extern queueInfoEnt *lsb_queueinfo (char **queues, int *numQueues, char *host, char *userName, int options)




cdef extern from "lsf.h":
	extern char * ls_getclustername()
	extern char * ls_getmastername()
	extern lsInfo *ls_info()
	extern hostInfo *ls_gethostinfo(char *resreq, int *numhosts, char **hostlist, int listsize, int options)
	extern char  *ls_gethosttype(char *hostname)
	extern char  *ls_gethostmodel(char *hostname)
	extern float *ls_gethostfactor(char *hostname)
	extern hostLoad *ls_load(char *resreq, int *numhosts, int options, char *fromhost)



	extern enum valueType: LS_BOOLEAN, LS_NUMERIC, LS_STRING, LS_EXTERNAL
	extern enum orderType: INCR, DECR, NA

	extern struct hostLoad:
		char  hostName[64]
		int   *status
		float *li

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


