#cdef extern from "lsf.h":
#	extern int lserrno

cdef extern from "lsbatch.h":

	extern struct jobInfoEnt:
#    LS_LONG_INT jobId;
		char    *user
		int     status
		int     *reasonTb
		int     numReasons
		int     reasons
		int     subreasons
		int     jobPid
#		time_t  submitTime
#		time_t  reserveTime
#		time_t  startTime
#		time_t  predictedStartTime
#		time_t  endTime
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
#		struct  submit submit
		int     exitStatus
		int     execUid
		char    *execHome
		char    *execCwd
		char    *execUsername
#		time_t  jRusageUpdateTime
#		struct  jRusage runRusage
		int     jType
		char    *parentGroup
		char    *jName
#		int     counter[NUM_JGRP_COUNTERS]
#		u_short port
		int     jobPriority


	extern int lsb_init (char *appName)
	extern char *ls_getclustername()
	extern char *ls_getmastername()
	extern int lsb_openjobinfo (long, char *, char *, char *, char *,int)
	extern jobInfoEnt * lsb_readjobinfo( int * )
	

