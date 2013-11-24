from libc.stdio cimport *

cdef extern from "Python.h":
	ctypedef struct FILE
	FILE* PyFile_AsFile(object)
	void  fprintf(FILE* f, char* s, char* s)

cdef extern from "fileobject.h":
	ctypedef class __builtin__.file [object PyFileObject]:
		pass


cdef extern from "lsbatch.h":
	ctypedef unsigned short u_short
	ctypedef long time_t
	ctypedef long long int LS_LONG_INT
	ctypedef unsigned long long LS_UNS_LONG_INT
	extern int lsberrno

	extern struct  lsfRusage:
		double ru_utime
		double ru_stime
		double  ru_maxrss
		double  ru_ixrss
		double  ru_ismrss
		double  ru_idrss
		double  ru_isrss
		double  ru_minflt
		double  ru_majflt
		double  ru_nswap
		double  ru_inblock
		double  ru_oublock
		double  ru_ioch
		double  ru_msgsnd
		double  ru_msgrcv
		double  ru_nsignals
		double  ru_nvcsw
		double  ru_nivcsw
		double  ru_exutime

	extern struct logSwitchLog:
		int lastJobId

	extern struct jobNewLog:
		int    jobId
		int    userId
		char   userName[60]
		int    options
		int    options2
		int    numProcessors
		time_t submitTime
		time_t beginTime
		time_t termTime
		int    sigValue
		int    chkpntPeriod
		int    restartPid
		int    rLimits[11]
		char   hostSpec[64]
		float  hostFactor
		int    umask
		char   queue[60]
		char   *resReq
		char   fromHost[64]
		char   cwd[265]
		char   chkpntDir[265]
		char   inFile[265]
		char   outFile[265]
		char   errFile[265]
		char   inFileSpool[265]
		char   commandSpool[265]
		char   jobSpoolDir[4096]
		char   subHomeDir[265]
		char   jobFile[265]
		int    numAskedHosts
		char   **askedHosts
		char   *dependCond
		char   jobName[512]
		char   command[512]
		int    nxf
		xFile *xf
		char   *preExecCmd
		char   *mailUser
		char   *projectName
		int    niosPort
		int    maxNumProcessors
		char   *schedHostType
		char   *loginShell
		int    idx
		int    userPriority

	extern struct jobModLog:
		char    *jobIdStr
		int     options
		int     options2
		int     delOptions
		int     delOptions2
		int     userId
		char    *userName
		int     submitTime
		int     umask
		int     numProcessors
		int     beginTime
		int     termTime
		int     sigValue
		int     restartPid
		char    *jobName
		char    *queue
		int     numAskedHosts
		char    **askedHosts
		char    *resReq
		int     rLimits[11]
		char    *hostSpec
		char    *dependCond
		char    *subHomeDir
		char    *inFile
		char    *outFile
		char    *errFile
		char    *command
		char    *inFileSpool
		char    *commandSpool
		int     chkpntPeriod
		char    *chkpntDir
		int     nxf
		xFile *xf
		char    *jobFile
		char    *fromHost
		char    *cwd
		char    *preExecCmd
		char    *mailUser
		char    *projectName
		int     niosPort
		int     maxNumProcessors
		char    *loginShell
		char    *schedHostType
		int     userPriority

	extern struct jobStartLog:
		int jobId
		int    jStatus
		int    jobPid
		int    jobPGid
		float  hostFactor
		int    numExHosts
		char   **execHosts
		char   *queuePreCmd
		char   *queuePostCmd
		int    jFlags
		int    idx

	extern struct jobStartAcceptLog:
		int    jobId
		int    jobPid
		int    jobPGid
		int    idx

	extern struct jobExecuteLog:
		int    jobId
		int    execUid
		char   *execHome
		char   *execCwd
		int    jobPGid
		char   *execUsername
		int    jobPid
		int    idx

	extern struct jobStatusLog:
		int    jobId
		int    jStatus
		int    reason
		int    subreasons
		float  cpuTime
		time_t endTime
		int    ru
		lsfRusage lsfRusage
		int   jFlags
		int   exitStatus
		int    idx

	extern struct sbdJobStatusLog:
		int    jobId
		int    jStatus
		int    reasons
		int    subreasons
		int    actPid
		int    actValue
		time_t actPeriod
		int    actFlags
		int    actStatus
		int    actReasons
		int    actSubReasons
		int    idx

	extern struct jobSwitchLog:
		int    userId
		int jobId
		char   queue[60]
		int    idx
		char   userName[60]

	extern struct jobMoveLog:
		int    userId
		int    jobId
		int    position
		int    base
		int    idx
		char   userName[60]

	extern struct chkpntLog:
		int jobId
		time_t period
		int pid
		int ok
		int flags
		int    idx

	extern struct jobRequeueLog:
		int jobId
		int    idx

	extern struct jobCleanLog:
		int jobId
		int    idx

	extern struct sigactLog:
		int jobId
		time_t period
		int pid
		int jStatus
		int reasons
		int flags
		char *signalSymbol
		int actStatus
		int    idx

	extern struct migLog:
		int jobId
		int numAskedHosts
		char **askedHosts
		int userId
		int    idx
		char userName[60]

	extern struct signalLog:
		int userId
		int jobId
		char *signalSymbol
		int runCount
		int    idx
		char userName[60]

	extern struct queueCtrlLog:
		int    opCode
		char   queue[60]
		int    userId
		char   userName[60]

	extern struct newDebugLog:
		int opCode
		int level
		int logclass
		int turnOff
		char logFileName[128]
		int userId

	extern struct hostCtrlLog:
		int    opCode
		char   host[64]
		int    userId
		char   userName[60]

	extern struct mbdStartLog:
		char   master[64]
		char   cluster[128]
		int    numHosts
		int    numQueues

	extern struct mbdDieLog:
		char   master[64]
		int    numRemoveJobs
		int    exitCode

	extern struct unfulfillLog:
		int    jobId
		int    notSwitched
		int    sig
		int    sig1
		int    sig1Flags
		time_t chkPeriod
		int    notModified
		int    idx

	extern struct jobFinishLog:
		int    jobId
		int    userId
		char   userName[60]
		int    options
		int    numProcessors
		int    jStatus
		time_t submitTime
		time_t beginTime
		time_t termTime
		time_t startTime
		time_t endTime
		char   queue[60]
		char   *resReq
		char   fromHost[64]
		char   cwd[4096]
		char   inFile[265]
		char   outFile[265]
		char   errFile[265]
		char   inFileSpool[265]
		char   commandSpool[265]
		char   jobFile[265]
		int    numAskedHosts
		char   **askedHosts
		float  hostFactor
		int    numExHosts
		char   **execHosts
		float  cpuTime
		char   jobName[512]
		char   command[512]
		lsfRusage lsfRusage
		char   *dependCond
		char   *preExecCmd
		char   *mailUser
		char   *projectName
		int    exitStatus
		int    maxNumProcessors
		char   *loginShell
		int    idx
		int    maxRMem
		int    maxRSwap

	extern struct loadIndexLog:
		int nIdx
		char **name

	extern struct jobMsgLog:
		int usrId
		int jobId
		int msgId
		int type
		char *src
		char *dest
		char *msg
		int    idx

	extern struct jobMsgAckLog:
		int usrId
		int jobId
		int msgId
		int type
		char *src
		char *dest
		char *msg
		int    idx

	extern struct jobForceRequestLog:
		int     userId
		int     numExecHosts
		char**  execHosts
		int     jobId
		int     idx
		int     options
		char    userName[60]


	extern struct jobAttrSetLog:
		int       jobId
		int       idx 
		int       uid 
		int       port
		char      *hostname

	extern union  eventLog:
		jobNewLog jobNewLog
		jobStartLog jobStartLog
		jobStatusLog jobStatusLog
		sbdJobStatusLog sbdJobStatusLog
		jobSwitchLog jobSwitchLog
		jobMoveLog jobMoveLog
		queueCtrlLog queueCtrlLog
		newDebugLog  newDebugLog
		hostCtrlLog hostCtrlLog
		mbdStartLog mbdStartLog
		mbdDieLog mbdDieLog
		unfulfillLog unfulfillLog
		jobFinishLog jobFinishLog
		loadIndexLog loadIndexLog
		migLog migLog
		signalLog signalLog
		jobExecuteLog jobExecuteLog
		jobMsgLog jobMsgLog
		jobMsgAckLog jobMsgAckLog
		jobRequeueLog jobRequeueLog
		chkpntLog chkpntLog
		sigactLog sigactLog
		jobStartAcceptLog jobStartAcceptLog
		jobCleanLog jobCleanLog
		jobForceRequestLog jobForceRequestLog
		logSwitchLog logSwitchLog
		jobModLog jobModLog
		jobAttrSetLog jobAttrSetLog



	extern struct eventRec:
		char   version[12]
		int    type
		time_t eventTime
		eventLog eventLog

	extern struct xFile:
		char subFn[256]
		char execFn[256]
		int options

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

	extern int lsb_init (char *appName)
	extern char *ls_getclustername()
	extern char *ls_getmastername()
	extern int lsb_openjobinfo (long, char *, char *, char *, char *,int)
	extern jobInfoEnt * lsb_readjobinfo( int * )
	extern void lsb_closejobinfo()
	extern queueInfoEnt *lsb_queueinfo(char **queues, int *numQueues, char *hosts, char *users, int options)
	extern hostInfoEnt *lsb_hostinfo(char **hosts, int *numHosts)
	extern userInfoEnt *lsb_userinfo(char **users, int *numUsers)
	extern eventRec *lsb_geteventrec(FILE* log_fp,int * lineNum)

