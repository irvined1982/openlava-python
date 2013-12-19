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
	ctypedef long time_t
	ctypedef long long int LS_LONG_INT
	ctypedef unsigned short u_short

	extern int lsb_init (char *appName)
	extern int lsb_openjobinfo (long, char *, char *, char *, char *,int)
	extern jobInfoEnt * lsb_readjobinfo( int * )
	extern void lsb_closejobinfo()
	extern int lsb_deletejob (LS_LONG_INT jobId, int times, int options)
	extern int lsb_signaljob (LS_LONG_INT jobId, int sigValue)
	extern int lsb_requeuejob(jobrequeue * reqPtr)
	extern LS_LONG_INT lsb_submit ( submit * subPtr, submitReply * repPtr)
	extern LS_LONG_INT lsb_modify (submit *, submitReply *, LS_LONG_INT)
	extern struct submitReply:
		char    *queue
		LS_LONG_INT  badJobId
		char    *badJobName
		int     badReqIndx


	extern struct jobrequeue:
		LS_LONG_INT      jobId
		int              status
		int              options


	extern struct userInfoEnt:
		char   *user
		float  procJobLimit
		int    maxJobs
		int    numStartJobs
		int    numJobs
		int    numPEND
		int    numRUN
		int    numSSUSP
		int    numUSUSP
		int    numRESERVE

	extern userInfoEnt *lsb_userinfo(char **users, int *numUsers)


	extern struct xFile:
		char subFn[256]
		char execFn[256]
		int options

	extern struct submit:
		int     options
		int     options2
		char    *jobName
		char    *queue
		int     numAskedHosts
		char    **askedHosts
		char    *resReq
		int     rLimits[11]
		char    *hostSpec
		int     numProcessors
		char    *dependCond
		time_t  beginTime
		time_t  termTime
		int     sigValue
		char    *inFile
		char    *outFile
		char    *errFile
		char    *command
		char    *newCommand
		time_t  chkpntPeriod
		char    *chkpntDir
		int     nxf
		xFile *xf
		char    *preExecCmd
		char    *mailUser
		int    delOptions
		int    delOptions2
		char   *projectName
		int    maxNumProcessors
		char   *loginShell
		int    userPriority
	extern struct pidInfo:
		int pid
		int ppid
		int pgid
		int jobid

	extern struct jRusage:
		int mem
		int swap
		int utime
		int stime
		int npids
		pidInfo *pidInfo
		int npgids
		int *pgid


	extern struct jobInfoEnt:
		LS_LONG_INT jobId
		char    *user
		int     status
		int     *reasonTb
		int     numReasons
		int     reasons
		int     subreasons
		int     jobPid
		time_t  submitTime
		time_t  reserveTime
		time_t  startTime
		time_t  predictedStartTime
		time_t  endTime
		float   cpuTime
		int     umask
		char    *cwd
		char    *subHomeDir
		char    *fromHost
		char    **exHosts
		int     numExHosts
		float   cpuFactor
		int     nIdx
		float   *loadSched
		float   *loadStop
		submit submit
		int     exitStatus
		int     execUid
		char    *execHome
		char    *execCwd
		char    *execUsername
		time_t  jRusageUpdateTime
		jRusage runRusage
		int     jType
		char    *parentGroup
		char    *jName
		int     counter[8]
		u_short port
		int     jobPriority


	extern struct hostInfoEnt:
		char   *host
		int    hStatus
		int    *busySched
		int    *busyStop
		float  cpuFactor
		int    nIdx
		float *load
		float  *loadSched
		float  *loadStop
		char   *windows
		int    userJobLimit
		int    maxJobs
		int    numJobs
		int    numRUN
		int    numSSUSP
		int    numUSUSP
		int    mig
		int    attr
		float *realLoad
		int   numRESERVE
		int   chkSig

	extern hostInfoEnt *lsb_hostinfo(char **hosts, int *numHosts)


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
	extern void    ls_perror(char *usrMsg)
	extern char    *ls_sysmsg()




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


