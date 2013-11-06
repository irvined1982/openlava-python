#cdef extern from "lsf.h":
#	extern int lserrno

cdef extern from "lsbatch.h":
	ctypedef unsigned short u_short
	ctypedef long time_t
	ctypedef long long int LS_LONG_INT
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
#		iint     rLimits[LSF_RLIM_NLIMITS]
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
#		int     counter[NUM_JGRP_COUNTERS]
		u_short port
		int     jobPriority





	extern int lsb_init (char *appName)
	extern char *ls_getclustername()
	extern char *ls_getmastername()
	extern int lsb_openjobinfo (long, char *, char *, char *, char *,int)
	extern jobInfoEnt * lsb_readjobinfo( int * )
	

