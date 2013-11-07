class StateNumeric:
	def __init__(self,status):
		self._status=status
	def __unicode__(self):
		try:
			return u'%s' % self.states[self._status]['name']
		except KeyError:
			return u'UNKNOWN'
	def __str__(self):
		try:
			return '%s' % self.states[self._status]['name']
		except KeyError:
			return 'UNKNOWN'
	def __int__(self):
		return self._status
	@property
	def name(self):
		return self.__unicode__()
	@property
	def description(self):
		try:
			return u'%s' % self.states[self._status]['description']
		except KeyError:
			return "Unknown Code."
	@property
	def status(self):
		return self._status

class SuspReason(StateNumeric):
	states={
		0x00000000:{
				'name':'SUSP_USER_REASON',
				'description': "Virtual code.  Not a reason  ",
				},
			0x00000001:{
				'name':'SUSP_USER_RESUME',
				'description': "The job is waiting to be re-scheduled after being resumed by the user.  ",
				},
			0x00000002:{
				'name':'SUSP_USER_STOP',
				'description': "The user suspended the job.  ",
				},
			0x00000004:{
				'name':'SUSP_QUEUE_REASON',
				'description': "Virtual code.  Not a reason  ",
				},
			0x00000008:{
				'name':'SUSP_QUEUE_WINDOW',
				'description': "The run window of the queue is closed.  ",
				},
			0x00000010:{
				'name':'SUSP_RESCHED_PREEMPT',
				'description': "Suspended after preemption.  The system needs to re-allocate CPU utilization by job priority.  ",
				},
			0x00000020:{
				'name':'SUSP_HOST_LOCK',
				'description': "The LSF administrator has locked the execution host.  ",
				},
			0x00000040:{
				'name':'SUSP_LOAD_REASON',
				'description': "A load index exceeds its threshold.  The subreasons field indicates which indices.  ",
				},
			0x00000080:{
				'name':'SUSP_MBD_PREEMPT',
				'description': "The job was preempted by mbatchd because of a higher priorty job.  ",
				},
			0x00000100:{
				'name':'SUSP_SBD_PREEMPT',
				'description': "Preempted by sbatchd.  The job limit of the host/user has been reached.  ",
				},
			0x00000200:{
				'name':'SUSP_QUE_STOP_COND',
				'description': "The suspend conditions of the queue, as specified by the STOP_COND parameter in lsb.queues, are true.  ",
				},
			0x00000400:{
				'name':'SUSP_QUE_RESUME_COND',
				'description': "The resume conditions of the queue, as specified by the RESUME_COND parameter in lsb.queues, are false.  ",
				},
			0x00000800:{
				'name':'SUSP_PG_IT',
				'description': "The job was suspended due to the paging rate and the host is not idle yet.  ",
				},
			0x00001000:{
				'name':'SUSP_REASON_RESET',
				'description': "Resets the previous reason.  ",
				},
			0x00002000:{
				'name':'SUSP_LOAD_UNAVAIL',
				'description': "Load information on the execution hosts is unavailable.  ",
				},
			0x00004000:{
				'name':'SUSP_ADMIN_STOP',
				'description': "The job was suspened by root or the LSF administrator.  ",
				},
			0x00008000:{
				'name':'SUSP_RES_RESERVE',
				'description': "The job is terminated due to resource limit.  ",
				},
			0x00010000:{
				'name':'SUSP_MBD_LOCK',
				'description': "The job is locked by the mbatchd.  ",
				},
			0x00020000:{
				'name':'SUSP_RES_LIMIT',
				'description': "The job's requirements for resource reservation are not satisfied.  ",
				},
			0x00040000:{
				'name':'SUSP_SBD_STARTUP',
				'description': "The job is suspended while the sbatchd is restarting.  ",
				},
			0x00080000:{
				'name':'SUSP_HOST_LOCK_MASTER',
				'description': "The execution host is locked by the master LIM.  ",
				},
			0x00100000:{
				'name':'SUSP_HOST_RSVACTIVE',
				'description': "An advance reservation using the host is active.  ",
				},
			0x00200000:{
				'name':'SUSP_DETAILED_SUBREASON',
				'description': "There is a detailed reason in the subreason field.  ",
				},
			0x00400000:{
				'name':'SUSP_GLB_LICENSE_PREEMPT',
				'description': "The job is preempted by glb.  ",
				},
			0x00800000:{
				'name':'SUSP_CRAYX1_POSTED',
				'description': "Job not placed by Cray X1 psched.  ",
				},
			0x01000000:{
				'name':'SUSP_ADVRSV_EXPIRED',
				'description': "Job suspended when its advance reservation expired. ",
				},
	}
class PendReason(StateNumeric):
	states={
			0:{
				'name':'PEND_JOB_REASON',
				'description': 'Virtual code; not a reason.  ',
				},
			1:{
				'name':'PEND_JOB_NEW',
				'description': 'A new job is waiting to be scheduled.  ',
				},
			2:{
				'name':'PEND_JOB_START_TIME',
				'description': 'The job is held until its specified start time.  ',
				},
			3:{
				'name':'PEND_JOB_DEPEND',
				'description': 'The job is waiting for its dependency condition(s) to be satisfied.  ',
				},
			4:{
				'name':'PEND_JOB_DEP_INVALID',
				'description': 'The dependency condition is invalid or never satisfied.  ',
				},
			5:{
				'name':'PEND_JOB_MIG',
				'description': 'The migrating job is waiting to be rescheduled.  ',
				},
			6:{
				'name':'PEND_JOB_PRE_EXEC',
				'description': 'The jobs pre-exec command exited with non-zero status.  ',
				},
			7:{
				'name':'PEND_JOB_NO_FILE',
				'description': 'Unable to access jobfile.  ',
				},
			8:{
				'name':'PEND_JOB_ENV',
				'description': 'Unable to set jobs environment variables.  ',
				},
			9:{
				'name':'PEND_JOB_PATHS',
				'description': 'Unable to determine the jobs home or working directories.  ',
				},
			10:{
				'name':'PEND_JOB_OPEN_FILES',
				'description': 'Unable to open the jobs input and output files.  ',
				},
			11:{
				'name':'PEND_JOB_EXEC_INIT',
				'description': 'Job execution initialization failed.  ',
				},
			12:{
				'name':'PEND_JOB_RESTART_FILE',
				'description': 'Unable to copy restarting jobs checkpoint files.  ',
				},
			13:{
				'name':'PEND_JOB_DELAY_SCHED',
				'description': 'Scheduling of the job is delayed.  ',
				},
			14:{
				'name':'PEND_JOB_SWITCH',
				'description': 'Waiting for the re-scheduling of the job after switching queues.  ',
				},
			15:{
				'name':'PEND_JOB_DEP_REJECT',
				'description': 'An event is rejected by eeventd due to a syntax error.  ',
				},
			16:{
				'name':'PEND_JOB_JS_DISABLED',
				'description': 'A JobScheduler feature is not enabled.  ',
				},
			17:{
				'name':'PEND_JOB_NO_PASSWD',
				'description': 'Failed to get user password.  ',
				},
			18:{
				'name':'PEND_JOB_LOGON_FAIL',
				'description': 'The job is pending due to logon failure.  ',
				},
			19:{
				'name':'PEND_JOB_MODIFY',
				'description': 'The job is waiting to be re-scheduled after its parameters have been changed.  ',
				},
			20:{
				'name':'PEND_JOB_TIME_INVALID',
				'description': 'The job time event is invalid.  ',
				},
			21:{
				'name':'PEND_TIME_EXPIRED',
				'description': 'The job time event has expired.  ',
				},
			23:{
				'name':'PEND_JOB_REQUEUED',
				'description': 'The job has been requeued.  ',
				},
			24:{
				'name':'PEND_WAIT_NEXT',
				'description': 'Waiting for the next time event.  ',
				},
			25:{
				'name':'PEND_JGRP_HOLD',
				'description': 'The parent group is held.  ',
				},
			26:{
				'name':'PEND_JGRP_INACT',
				'description': 'The parent group is inactive.  ',
				},
			27:{
				'name':'PEND_JGRP_WAIT',
				'description': 'The group is waiting for scheduling.  ',
				},
			28:{
				'name':'PEND_JOB_RCLUS_UNREACH',
				'description': 'The remote cluster(s) are unreachable.  ',
				},
			29:{
				'name':'PEND_JOB_QUE_REJECT',
				'description': 'SNDJOBS_TO queue rejected by remote clusters.  ',
				},
			30:{
				'name':'PEND_JOB_RSCHED_START',
				'description': 'Waiting for new remote scheduling session.  ',
				},
			31:{
				'name':'PEND_JOB_RSCHED_ALLOC',
				'description': 'Waiting for allocation reply from remote clusters.  ',
				},
			32:{
				'name':'PEND_JOB_FORWARDED',
				'description': 'The job is forwarded to a remote cluster.  ',
				},
			33:{
				'name':'PEND_JOB_RMT_ZOMBIE',
				'description': 'The job running remotely is in a zombie state.  ',
				},
			34:{
				'name':'PEND_JOB_ENFUGRP',
				'description': 'Jobs enforced user group share account not selected.  ',
				},
			35:{
				'name':'PEND_SYS_UNABLE',
				'description': 'The system is unable to schedule the job.  ',
				},
			36:{
				'name':'PEND_JGRP_RELEASE',
				'description': 'The parent group has just been released.  ',
				},
			37:{
				'name':'PEND_HAS_RUN',
				'description': 'The job has run since group active.  ',
				},
			38:{
				'name':'PEND_JOB_ARRAY_JLIMIT',
				'description': 'The job has reached its running element limit.  ',
				},
			39:{
				'name':'PEND_CHKPNT_DIR',
				'description': 'Checkpoint directory is invalid.  ',
				},
			40:{
				'name':'PEND_CHUNK_FAIL',
				'description': 'The first job in the chunk failed (all other jobs in the chunk are set to PEND).  ',
				},
			41:{
				'name':'PEND_JOB_SLA_MET',
				'description': 'Optimum number of running jobs for SLA has been reached.  ',
				},
			42:{
				'name':'PEND_JOB_APP_NOEXIST',
				'description': 'Specified application profile does not exist.  ',
				},
			43:{
				'name':'PEND_APP_PROCLIMIT',
				'description': 'Job no longer satisfies application PROCLIMIT configuration.  ',
				},
			44:{
				'name':'PEND_EGO_NO_HOSTS',
				'description': 'No hosts for the job from EGO.  ',
				},
			45:{
				'name':'PEND_JGRP_JLIMIT',
				'description': 'The specified job group has reached its job limit.  ',
				},
			46:{
				'name':'PEND_PREEXEC_LIMIT',
				'description': 'Job pre-exec retry limit.  ',
				},
			47:{
				'name':'PEND_REQUEUE_LIMIT',
				'description': 'Job re-queue limit.  ',
				},
			48:{
				'name':'PEND_BAD_RESREQ',
				'description': 'Job has bad res req.  ',
				},
			49:{
				'name':'PEND_RSV_INACTIVE',
				'description': 'Jobs reservation is inactive.  ',
				},
			50:{
				'name':'PEND_WAITING_RESUME',
				'description': 'Job was in PSUSP with bad res req, after successful bmod waiting for the user to bresume.  ',
				},
			51:{
				'name':'PEND_SLOT_COMPOUND',
				'description': 'Job slot request cannot satisfy compound resource requirement.  ',
				},
			301:{
				'name':'PEND_QUE_INACT',
				'description': 'The queue is inactivated by the administrator.  ',
				},
			302:{
				'name':'PEND_QUE_WINDOW',
				'description': 'The queue is inactivated by its time windows.  ',
				},
			303:{
				'name':'PEND_QUE_JOB_LIMIT',
				'description': 'The queue has reached its job slot limit.  ',
				},
			304:{
				'name':'PEND_QUE_USR_JLIMIT',
				'description': 'The user has reached the per-user job slot limit of the queue.  ',
				},
			305:{
				'name':'PEND_QUE_USR_PJLIMIT',
				'description': 'Not enough per-user job slots of the queue for the parallel job.  ',
				},
			306:{
				'name':'PEND_QUE_PRE_FAIL',
				'description': 'The queues pre-exec command exited with non-zero status.  ',
				},
			307:{
				'name':'PEND_NQS_RETRY',
				'description': 'The job was not accepted by the NQS host, Attempt again later.  ',
				},
			308:{
				'name':'PEND_NQS_REASONS',
				'description': 'Unable to send the job to an NQS host.  ',
				},
			309:{
				'name':'PEND_NQS_FUN_OFF',
				'description': 'Unable to contact NQS host.  ',
				},
			310:{
				'name':'PEND_SYS_NOT_READY',
				'description': 'The system is not ready for scheduling after reconfiguration.  ',
				},
			311:{
				'name':'PEND_SBD_JOB_REQUEUE',
				'description': 'The requeued job is waiting for rescheduling.  ',
				},
			312:{
				'name':'PEND_JOB_SPREAD_TASK',
				'description': 'Not enough hosts to meet the jobs spanning requirement.  ',
				},
			313:{
				'name':'PEND_QUE_SPREAD_TASK',
				'description': 'Not enough hosts to meet the queues spanning requirement.  ',
				},
			314:{
				'name':'PEND_QUE_PJOB_LIMIT',
				'description': 'The queue has not enough job slots for the parallel job.  ',
				},
			315:{
				'name':'PEND_QUE_WINDOW_WILL_CLOSE',
				'description': 'The job will not finish before queues run window is closed.  ',
				},
			316:{
				'name':'PEND_QUE_PROCLIMIT',
				'description': 'Job no longer satisfies queue PROCLIMIT configuration.  ',
				},
			317:{
				'name':'PEND_SBD_PLUGIN',
				'description': 'Job requeued due to plug-in failure.  ',
				},
			318:{
				'name':'PEND_WAIT_SIGN_LEASE',
				'description': 'Waiting for lease signing.  ',
				},
			601:{
				'name':'PEND_USER_JOB_LIMIT',
				'description': 'The job slot limit is reached.  ',
				},
			602:{
				'name':'PEND_UGRP_JOB_LIMIT',
				'description': 'A user group has reached its job slot limit.  ',
				},
			603:{
				'name':'PEND_USER_PJOB_LIMIT',
				'description': 'The job slot limit for the parallel job is reached.  ',
				},
			604:{
				'name':'PEND_UGRP_PJOB_LIMIT',
				'description': 'A user group has reached its job slot limit for the parallel job.  ',
				},
			605:{
				'name':'PEND_USER_RESUME',
				'description': 'Waiting for scheduling after resumed by user.  ',
				},
			607:{
				'name':'PEND_USER_STOP',
				'description': 'The job was suspended by the user while pending.  ',
				},
			608:{
				'name':'PEND_NO_MAPPING',
				'description': 'Unable to determine user account for execution.  ',
				},
			609:{
				'name':'PEND_RMT_PERMISSION',
				'description': 'The user has no permission to run the job on remote host/cluster.  ',
				},
			610:{
				'name':'PEND_ADMIN_STOP',
				'description': 'The job was suspended by LSF admin or root while pending.  ',
				},
			611:{
				'name':'PEND_MLS_INVALID',
				'description': 'The requested label is not valid.  ',
				},
			612:{
				'name':'PEND_MLS_CLEARANCE',
				'description': 'The requested label is above user allowed range.  ',
				},
			613:{
				'name':'PEND_MLS_RHOST',
				'description': 'The requested label rejected by /etc/rhost.conf.  ',
				},
			614:{
				'name':'PEND_MLS_DOMINATE',
				'description': 'The requested label does not dominate current label.  ',
				},
			615:{
				'name':'PEND_MLS_FATAL',
				'description': 'The requested label problem.  ',
				},
			616:{
				'name':'PEND_INTERNAL_STOP',
				'description': 'LSF internally bstoped a pending job.  ',
				},
			1001:{
				'name':'PEND_HOST_RES_REQ',
				'description': 'The jobs resource requirements not satisfied.  ',
				},
			1002:{
				'name':'PEND_HOST_NONEXCLUSIVE',
				'description': 'The jobs requirement for exclusive execution not satisfied.  ',
				},
			1003:{
				'name':'PEND_HOST_JOB_SSUSP',
				'description': 'Higher or equal priority jobs already suspended by system.  ',
				},
			1004:{
				'name':'PEND_HOST_PART_PRIO',
				'description': 'The job failed to compete with other jobs on host partition.  ',
				},
			1005:{
				'name':'PEND_SBD_GETPID',
				'description': 'Unable to get the PID of the restarting job.  ',
				},
			1006:{
				'name':'PEND_SBD_LOCK',
				'description': 'Unable to lock the host for exclusively executing the job.  ',
				},
			1007:{
				'name':'PEND_SBD_ZOMBIE',
				'description': 'Cleaning up zombie job.  ',
				},
			1008:{
				'name':'PEND_SBD_ROOT',
				'description': 'Cant run jobs submitted by root.  The job is rejected by the sbatchd  ',
				},
			1009:{
				'name':'PEND_HOST_WIN_WILL_CLOSE',
				'description': 'Job cant finish on the host before queues run window is closed.  ',
				},
			1010:{
				'name':'PEND_HOST_MISS_DEADLINE',
				'description': 'Job cant finish on the host before jobs termination deadline.  ',
				},
			1011:{
				'name':'PEND_FIRST_HOST_INELIGIBLE',
				'description': 'The specified first execution host is not eligible for this job at this time.  ',
				},
			1012:{
				'name':'PEND_HOST_EXCLUSIVE_RESERVE',
				'description': 'Exclusive job reserves slots on host.  ',
				},
			1013:{
				'name':'PEND_FIRST_HOST_REUSE',
				'description': 'Resized shadow job or non-first resReq of a compound resReq job try to reuse the first execution host.  ',
				},
			1301:{
				'name':'PEND_HOST_DISABLED',
				'description': 'The host is closed by the LSF administrator.  ',
				},
			1302:{
				'name':'PEND_HOST_LOCKED',
				'description': 'The host is locked by the LSF administrator.  ',
				},
			1303:{
				'name':'PEND_HOST_LESS_SLOTS',
				'description': 'Not enough job slots for the parallel job.  ',
				},
			1304:{
				'name':'PEND_HOST_WINDOW',
				'description': 'Dispatch windows are closed.  ',
				},
			1305:{
				'name':'PEND_HOST_JOB_LIMIT',
				'description': 'The job slot limit reached.  ',
				},
			1306:{
				'name':'PEND_QUE_PROC_JLIMIT',
				'description': 'The queues per-CPU job slot limit is reached.  ',
				},
			1307:{
				'name':'PEND_QUE_HOST_JLIMIT',
				'description': 'The queues per-host job slot limit is reached.  ',
				},
			1308:{
				'name':'PEND_USER_PROC_JLIMIT',
				'description': 'The users per-CPU job slot limit is reached.  ',
				},
			1309:{
				'name':'PEND_HOST_USR_JLIMIT',
				'description': 'The hosts per-user job slot limit is reached.  ',
				},
			1310:{
				'name':'PEND_HOST_QUE_MEMB',
				'description': 'Not a member of the queue.  ',
				},
			1311:{
				'name':'PEND_HOST_USR_SPEC',
				'description': 'Not a user-specified host.  ',
				},
			1312:{
				'name':'PEND_HOST_PART_USER',
				'description': 'The user has no access to the host partition.  ',
				},
			1313:{
				'name':'PEND_HOST_NO_USER',
				'description': 'There is no such user account.  ',
				},
			1314:{
				'name':'PEND_HOST_ACCPT_ONE',
				'description': 'Just started a job recently.  ',
				},
			1315:{
				'name':'PEND_LOAD_UNAVAIL',
				'description': 'Load info unavailable.  ',
				},
			1316:{
				'name':'PEND_HOST_NO_LIM',
				'description': 'The LIM is unreachable by the sbatchd.  ',
				},
			1317:{
				'name':'PEND_HOST_UNLICENSED',
				'description': 'The host does not have a valid LSF software license.  ',
				},
			1318:{
				'name':'PEND_HOST_QUE_RESREQ',
				'description': 'The queues resource requirements are not satisfied.  ',
				},
			1319:{
				'name':'PEND_HOST_SCHED_TYPE',
				'description': 'The submission host type is not the same.  ',
				},
			1320:{
				'name':'PEND_JOB_NO_SPAN',
				'description': 'There are not enough processors to meet the jobs spanning requirement.  The job level locality is unsatisfied.  ',
				},
			1321:{
				'name':'PEND_QUE_NO_SPAN',
				'description': 'There are not enough processors to meet the queues spanning requirement.  The queue level locality is unsatisfied.  ',
				},
			1322:{
				'name':'PEND_HOST_EXCLUSIVE',
				'description': 'An exclusive job is running.  ',
				},
			1323:{
				'name':'PEND_HOST_JS_DISABLED',
				'description': 'Job Scheduler is disabled on the host.  It is not licensed to accept repetitive jobs.  ',
				},
			1324:{
				'name':'PEND_UGRP_PROC_JLIMIT',
				'description': 'The user groups per-CPU job slot limit is reached.  ',
				},
			1325:{
				'name':'PEND_BAD_HOST',
				'description': 'Incorrect host, group or cluster name.  ',
				},
			1326:{
				'name':'PEND_QUEUE_HOST',
				'description': 'Host is not used by the queue.  ',
				},
			1327:{
				'name':'PEND_HOST_LOCKED_MASTER',
				'description': 'Host is locked by master LIM.  ',
				},
			1328:{
				'name':'PEND_HOST_LESS_RSVSLOTS',
				'description': 'Not enough reserved job slots at this time for specified reservation ID.  ',
				},
			1329:{
				'name':'PEND_HOST_LESS_DURATION',
				'description': 'Not enough slots or resources for whole duration of the job.  ',
				},
			1330:{
				'name':'PEND_HOST_NO_RSVID',
				'description': 'Specified reservation has expired or has been deleted.  ',
				},
			1331:{
				'name':'PEND_HOST_LEASE_INACTIVE',
				'description': 'The host is closed due to lease is inactive.  ',
				},
			1332:{
				'name':'PEND_HOST_ADRSV_ACTIVE',
				'description': 'Not enough job slot(s) while advance reservation is active.  ',
				},
			1333:{
				'name':'PEND_QUE_RSVID_NOMATCH',
				'description': 'This queue is not configured to send jobs to the cluster specified in the advance.  ',
				},
			1334:{
				'name':'PEND_HOST_GENERAL',
				'description': 'Individual host based reasons.  ',
				},
			1335:{
				'name':'PEND_HOST_RSV',
				'description': 'Host does not belong to the specified advance reservation.  ',
				},
			1336:{
				'name':'PEND_HOST_NOT_CU',
				'description': 'Host does not belong to a compute unit of the required type.  ',
				},
			1337:{
				'name':'PEND_HOST_CU_EXCL',
				'description': 'A compute unit containing the host is used exclusively.  ',
				},
			1338:{
				'name':'PEND_HOST_CU_OCCUPIED',
				'description': 'CU-level excl.  job cannot start since CU is occupied  ',
				},
			1339:{
				'name':'PEND_HOST_USABLE_CU',
				'description': 'Insufficiently many usable slots on the hosts compute unit.  ',
				},
			1340:{
				'name':'PEND_JOB_FIRST_CU',
				'description': 'No first execution compute unit satisfies CU usablepercu requirement.  ',
				},
			1341:{
				'name':'PEND_HOST_CU_EXCL_RSV',
				'description': 'A CU containing the host is reserved exclusively.  ',
				},
			1342:{
				'name':'PEND_JOB_CU_MAXCUS',
				'description': 'Maxcus cannot be satisfied.  ',
				},
			1343:{
				'name':'PEND_JOB_CU_BALANCE',
				'description': 'Balance cannot be satisfied.  ',
				},
			1344:{
				'name':'PEND_CU_TOPLIB_HOST',
				'description': 'Cu not supported on toplib integration hosts.  ',
				},
			1601:{
				'name':'PEND_SBD_UNREACH',
				'description': 'Cannot reach sbatchd.  ',
				},
			1602:{
				'name':'PEND_SBD_JOB_QUOTA',
				'description': 'Number of jobs exceed quota.  ',
				},
			1603:{
				'name':'PEND_JOB_START_FAIL',
				'description': 'The job failed in talking to the server to start the job.  ',
				},
			1604:{
				'name':'PEND_JOB_START_UNKNWN',
				'description': 'Failed in receiving the reply from the server when starting the job.  ',
				},
			1605:{
				'name':'PEND_SBD_NO_MEM',
				'description': 'Unable to allocate memory to run job.  There is no memory on the sbatchd.  ',
				},
			1606:{
				'name':'PEND_SBD_NO_PROCESS',
				'description': 'Unable to fork process to run the job.  There are no more processes on the sbatchd.  ',
				},
			1607:{
				'name':'PEND_SBD_SOCKETPAIR',
				'description': 'Unable to communicate with the job process.  ',
				},
			1608:{
				'name':'PEND_SBD_JOB_ACCEPT',
				'description': 'The slave batch server failed to accept the job.  ',
				},
			1609:{
				'name':'PEND_LEASE_JOB_REMOTE_DISPATCH',
				'description': 'Lease job remote dispatch failed.  ',
				},
			1610:{
				'name':'PEND_JOB_RESTART_FAIL',
				'description': 'Failed to restart job from last checkpoint.  ',
				},
			2001:{
				'name':'PEND_HOST_LOAD',
				'description': 'The load threshold is reached.  ',
				},
			2301:{
				'name':'PEND_HOST_QUE_RUSAGE',
				'description': 'The queues requirements for resource reservation are not satisfied.  ',
				},
			2601:{
				'name':'PEND_HOST_JOB_RUSAGE',
				'description': 'The jobs requirements for resource reservation are not satisfied.  ',
				},
			2901:{
				'name':'PEND_RMT_JOB_FORGOTTEN',
				'description': 'Remote job not recongized by remote cluster, waiting for rescheduling.  ',
				},
			2902:{
				'name':'PEND_RMT_IMPT_JOBBKLG',
				'description': 'Remote import limit reached, waiting for rescheduling.  ',
				},
			2903:{
				'name':'PEND_RMT_MAX_RSCHED_TIME',
				'description': 'Remote schedule time reached, waiting for rescheduling.  ',
				},
			2904:{
				'name':'PEND_RMT_MAX_PREEXEC_RETRY',
				'description': 'Remote pre-exec retry limit reached, waiting for rescheduling.  ',
				},
			2905:{
				'name':'PEND_RMT_QUEUE_CLOSED',
				'description': 'Remote queue is closed.  ',
				},
			2906:{
				'name':'PEND_RMT_QUEUE_INACTIVE',
				'description': 'Remote queue is inactive.  ',
				},
			2907:{
				'name':'PEND_RMT_QUEUE_CONGESTED',
				'description': 'Remote queue is congested.  ',
				},
			2908:{
				'name':'PEND_RMT_QUEUE_DISCONNECT',
				'description': 'Remote queue is disconnected.  ',
				},
			2909:{
				'name':'PEND_RMT_QUEUE_NOPERMISSION',
				'description': 'Remote queue is not configured to accept jobs from this cluster.  ',
				},
			2910:{
				'name':'PEND_RMT_BAD_TIME',
				'description': 'Jobs termination time exceeds the job creation time on remote cluster.  ',
				},
			2911:{
				'name':'PEND_RMT_PERMISSIONS',
				'description': 'Permission denied on the execution cluster.  ',
				},
			2912:{
				'name':'PEND_RMT_PROC_NUM',
				'description': 'Jobs required on number of processors cannot be satisfied on the remote cluster.  ',
				},
			2913:{
				'name':'PEND_RMT_QUEUE_USE',
				'description': 'User is not defined in the fairshare policy of the remote queue.  ',
				},
			2914:{
				'name':'PEND_RMT_NO_INTERACTIVE',
				'description': 'Remote queue is a non-interactive queue.  ',
				},
			2915:{
				'name':'PEND_RMT_ONLY_INTERACTIVE',
				'description': 'Remote queue is an interactive-only queue.  ',
				},
			2916:{
				'name':'PEND_RMT_PROC_LESS',
				'description': 'Jobs required maximum number of processors is less then the minimum number.  ',
				},
			2917:{
				'name':'PEND_RMT_OVER_LIMIT',
				'description': 'Jobs required resource limit exceeds that of the remote queue.  ',
				},
			2918:{
				'name':'PEND_RMT_BAD_RESREQ',
				'description': 'Jobs resource requirements do not match with those of the remote queue.  ',
				},
			2919:{
				'name':'PEND_RMT_CREATE_JOB',
				'description': 'Job failed to be created on the remote cluster.  ',
				},
			2920:{
				'name':'PEND_RMT_RERUN',
				'description': 'Job is requeued for rerun on the execution cluster.  ',
				},
			2921:{
				'name':'PEND_RMT_EXIT_REQUEUE',
				'description': 'Job is requeued on the execution cluster due to exit value.  ',
				},
			2922:{
				'name':'PEND_RMT_REQUEUE',
				'description': 'Job was killed and requeued on the execution cluster.  ',
				},
			2923:{
				'name':'PEND_RMT_JOB_FORWARDING',
				'description': 'Job was forwarded to remote cluster.  ',
				},
			2924:{
				'name':'PEND_RMT_QUEUE_INVALID',
				'description': 'Remote import queue defined for the job in lsb.queues is either not ready or not valid.  ',
				},
			2925:{
				'name':'PEND_RMT_QUEUE_NO_EXCLUSIVE',
				'description': 'Remote queue is a non-exclusive queue.  ',
				},
			2926:{
				'name':'PEND_RMT_UGROUP_MEMBER',
				'description': 'Job was rejected; submitter does not belong to the specified User Group in the remote cluster or the user group does not exist in the remote cluster.  ',
				},
			2927:{
				'name':'PEND_RMT_INTERACTIVE_RERUN',
				'description': 'Remote queue is rerunnable: can not accept interactive jobs.  ',
				},
			2928:{
				'name':'PEND_RMT_JOB_START_FAIL',
				'description': 'Remote cluster failed in talking to server to start the job.  ',
				},
			2930:{
				'name':'PEND_RMT_FORWARD_FAIL_UGROUP_MEMBER',
				'description': 'Job was rejected; submitter does not belong to the specified User Group in the remote cluster or the user group does not exist in the remote cluster.  ',
				},
			2931:{
				'name':'PEND_RMT_HOST_NO_RSVID',
				'description': 'Specified remote reservation has expired or has been deleted.  ',
				},
			2932:{
				'name':'PEND_RMT_APP_NULL',
				'description': 'Application profile could not be found in the remote cluster.  ',
				},
			2933:{
				'name':'PEND_RMT_BAD_RUNLIMIT',
				'description': 'Jobs required RUNLIMIT exceeds RUNTIME * JOB_RUNLIMIT_RATIO of the remote cluster.  ',
				},
			2934:{
				'name':'PEND_RMT_OVER_QUEUE_LIMIT',
				'description': 'Jobs required RUNTIME exceeds the hard runtime limit in the remote queue.  ',
				},
			2935:{
				'name':'PEND_RMT_WHEN_NO_SLOTS',
				'description': 'Job will be pend when no slots available among remote queues.  ',
				},
			3201:{
				'name':'PEND_GENERAL_LIMIT_USER',
				'description': 'Resource limit defined on user or user group has been reached.  ',
				},
			3501:{
				'name':'PEND_GENERAL_LIMIT_QUEUE',
				'description': 'Resource (s) limit defined on queue has been reached.  ',
				},
			3801:{
				'name':'PEND_GENERAL_LIMIT_PROJECT',
				'description': 'Resource limit defined on project has been reached.  ',
				},
			4101:{
				'name':'PEND_GENERAL_LIMIT_CLUSTER',
				'description': 'Resource (s) limit defined cluster wide has been reached.  ',
				},
			4401:{
				'name':'PEND_GENERAL_LIMIT_HOST',
				'description': 'Resource (s) limit defined on host and/or host group has been reached.  ',
				},
			4701:{
				'name':'PEND_GENERAL_LIMIT_JOBS_USER',
				'description': 'JOBS limit defined for the user or user group has been reached.  ',
				},
			4702:{
				'name':'PEND_GENERAL_LIMIT_JOBS_QUEUE',
				'description': 'JOBS limit defined for the queue has been reached.  ',
				},
			4703:{
				'name':'PEND_GENERAL_LIMIT_JOBS_PROJECT',
				'description': 'JOBS limit defined for the project has been reached.  ',
				},
			4704:{
				'name':'PEND_GENERAL_LIMIT_JOBS_CLUSTER',
				'description': 'JOBS limit defined cluster-wide has been reached.  ',
				},
			4705:{
				'name':'PEND_GENERAL_LIMIT_JOBS_HOST',
				'description': 'JOBS limit defined on host or host group has been reached.  ',
				},
			4900:{
				'name':'PEND_RMS_PLUGIN_INTERNAL',
				'description': 'RMS scheduler plugin internal error.  ',
				},
			4901:{
				'name':'PEND_RMS_PLUGIN_RLA_COMM',
				'description': 'RLA communication failure.  ',
				},
			4902:{
				'name':'PEND_RMS_NOT_AVAILABLE',
				'description': 'RMS is not available.  ',
				},
			4903:{
				'name':'PEND_RMS_FAIL_TOPOLOGY',
				'description': 'Cannot satisfy the topology requirement.  ',
				},
			4904:{
				'name':'PEND_RMS_FAIL_ALLOC',
				'description': 'Cannot allocate an RMS resource.  ',
				},
			4905:{
				'name':'PEND_RMS_SPECIAL_NO_PREEMPT_BACKFILL',
				'description': 'RMS job with special topology requirements cannot be preemptive or backfill job.  ',
				},
			4906:{
				'name':'PEND_RMS_SPECIAL_NO_RESERVE',
				'description': 'RMS job with special topology requirements cannot reserve slots.  ',
				},
			4907:{
				'name':'PEND_RMS_RLA_INTERNAL',
				'description': 'RLA internal error.  ',
				},
			4908:{
				'name':'PEND_RMS_NO_SLOTS_SPECIAL',
				'description': 'Not enough slots for job.  Job with RMS topology requirements cannot reserve slots, be preemptive, or be a backfill job.  ',
				},
			4909:{
				'name':'PEND_RMS_RLA_NO_SUCH_USER',
				'description': 'User account does not exist on the execution host.  ',
				},
			4910:{
				'name':'PEND_RMS_RLA_NO_SUCH_HOST',
				'description': 'Unknown host and/or partition unavailable.  ',
				},
			4911:{
				'name':'PEND_RMS_CHUNKJOB',
				'description': 'Cannot schedule chunk jobs to RMS hosts.  ',
				},
			4912:{
				'name':'PEND_RLA_PROTOMISMATCH',
				'description': 'RLA protocol mismatch.  ',
				},
			4913:{
				'name':'PEND_RMS_BAD_TOPOLOGY',
				'description': 'Contradictory topology requirements specified.  ',
				},
			4914:{
				'name':'PEND_RMS_RESREQ_MCONT',
				'description': 'Not enough slots to satisfy manditory contiguous requirement.  ',
				},
			4915:{
				'name':'PEND_RMS_RESREQ_PTILE',
				'description': 'Not enough slots to satisfy RMS ptile requirement.  ',
				},
			4916:{
				'name':'PEND_RMS_RESREQ_NODES',
				'description': 'Not enough slots to satisfy RMS nodes requirement.  ',
				},
			4917:{
				'name':'PEND_RMS_RESREQ_BASE',
				'description': 'Cannot satisfy RMS base node requirement.  ',
				},
			4918:{
				'name':'PEND_RMS_RESREQ_RAILS',
				'description': 'Cannot satisfy RMS rails requirement.  ',
				},
			4919:{
				'name':'PEND_RMS_RESREQ_RAILMASK',
				'description': 'Cannot satisfy RMS railmask requirement.  ',
				},
			5000:{
				'name':'PEND_MAUI_UNREACH',
				'description': 'Unable to communicate with external Maui scheduler.  ',
				},
			5001:{
				'name':'PEND_MAUI_FORWARD',
				'description': 'Job is pending at external Maui scheduler.  ',
				},
			5030:{
				'name':'PEND_MAUI_REASON',
				'description': 'External Maui scheduler sets detail reason.  ',
				},
			5200:{
				'name':'PEND_CPUSET_ATTACH',
				'description': 'CPUSET attach failed.  Job requeued  ',
				},
			5201:{
				'name':'PEND_CPUSET_NOT_CPUSETHOST',
				'description': 'Not a cpuset host.  ',
				},
			5202:{
				'name':'PEND_CPUSET_TOPD_INIT',
				'description': 'Topd initialization failed.  ',
				},
			5203:{
				'name':'PEND_CPUSET_TOPD_TIME_OUT',
				'description': 'Topd communication timeout.  ',
				},
			5204:{
				'name':'PEND_CPUSET_TOPD_FAIL_ALLOC',
				'description': 'Cannot satisfy the cpuset allocation requirement.  ',
				},
			5205:{
				'name':'PEND_CPUSET_TOPD_BAD_REQUEST',
				'description': 'Bad cpuset allocation request.  ',
				},
			5206:{
				'name':'PEND_CPUSET_TOPD_INTERNAL',
				'description': 'Topd internal error.  ',
				},
			5207:{
				'name':'PEND_CPUSET_TOPD_SYSAPI_ERR',
				'description': 'Cpuset system API failure.  ',
				},
			5208:{
				'name':'PEND_CPUSET_TOPD_NOSUCH_NAME',
				'description': 'Specified static cpuset does not exist on the host.  ',
				},
			5209:{
				'name':'PEND_CPUSET_TOPD_JOB_EXIST',
				'description': 'Cpuset is already allocated for this job.  ',
				},
			5210:{
				'name':'PEND_CPUSET_TOPD_NO_MEMORY',
				'description': 'Topd malloc failure.  ',
				},
			5211:{
				'name':'PEND_CPUSET_TOPD_INVALID_USER',
				'description': 'User account does not exist on the cpuset host.  ',
				},
			5212:{
				'name':'PEND_CPUSET_TOPD_PERM_DENY',
				'description': 'User does not have permission to run job within cpuset.  ',
				},
			5213:{
				'name':'PEND_CPUSET_TOPD_UNREACH',
				'description': 'Topd is not available.  ',
				},
			5214:{
				'name':'PEND_CPUSET_TOPD_COMM_ERR',
				'description': 'Topd communication failure.  ',
				},
			5215:{
				'name':'PEND_CPUSET_PLUGIN_INTERNAL',
				'description': 'CPUSET scheduler plugin internal error.  ',
				},
			5216:{
				'name':'PEND_CPUSET_CHUNKJOB',
				'description': 'Cannot schedule chunk jobs to cpuset hosts.  ',
				},
			5217:{
				'name':'PEND_CPUSET_CPULIST',
				'description': 'Cant satisfy CPU_LIST requirement.  ',
				},
			5218:{
				'name':'PEND_CPUSET_MAXRADIUS',
				'description': 'Cannot satisfy CPUSET MAX_RADIUS requirement.  ',
				},
			5300:{
				'name':'PEND_NODE_ALLOC_FAIL',
				'description': 'Node allocation failed.  ',
				},
			5400:{
				'name':'PEND_RMSRID_UNAVAIL',
				'description': 'RMS resource is not available.  ',
				},
			5450:{
				'name':'PEND_NO_FREE_CPUS',
				'description': 'Not enough free cpus to satisfy job requirements.  ',
				},
			5451:{
				'name':'PEND_TOPOLOGY_UNKNOWN',
				'description': 'Topology unknown or recently changed.  ',
				},
			5452:{
				'name':'PEND_BAD_TOPOLOGY',
				'description': 'Contradictory topology requirement specified.  ',
				},
			5453:{
				'name':'PEND_RLA_COMM',
				'description': 'RLA communications failure.  ',
				},
			5454:{
				'name':'PEND_RLA_NO_SUCH_USER',
				'description': 'User account does not exist on execution host.  ',
				},
			5455:{
				'name':'PEND_RLA_INTERNAL',
				'description': 'RLA internal error.  ',
				},
			5456:{
				'name':'PEND_RLA_NO_SUCH_HOST',
				'description': 'Unknown host and/or partition unavailable.  ',
				},
			5457:{
				'name':'PEND_RESREQ_TOOFEWSLOTS',
				'description': 'Too few slots for specified topology requirement.  ',
				},
			5500:{
				'name':'PEND_PSET_PLUGIN_INTERNAL',
				'description': 'PSET scheduler plugin internal error.  ',
				},
			5501:{
				'name':'PEND_PSET_RESREQ_PTILE',
				'description': 'Cannot satisfy PSET ptile requirement.  ',
				},
			5502:{
				'name':'PEND_PSET_RESREQ_CELLS',
				'description': 'Cannot satisfy PSET cells requirement.  ',
				},
			5503:{
				'name':'PEND_PSET_CHUNKJOB',
				'description': 'Cannot schedule chunk jobs to PSET hosts.  ',
				},
			5504:{
				'name':'PEND_PSET_NOTSUPPORT',
				'description': 'Host does not support processor set functionality.  ',
				},
			5505:{
				'name':'PEND_PSET_BIND_FAIL',
				'description': 'PSET bind failed.  Job requeued  ',
				},
			5506:{
				'name':'PEND_PSET_RESREQ_CELLLIST',
				'description': 'Cannot satisfy PSET CELL_LIST requirement.  ',
				},
			5550:{
				'name':'PEND_SLURM_PLUGIN_INTERNAL',
				'description': 'SLURM scheduler plugin internal error.  ',
				},
			5551:{
				'name':'PEND_SLURM_RESREQ_NODES',
				'description': 'Not enough resource to satisfy SLURM nodes requirment.  ',
				},
			5552:{
				'name':'PEND_SLURM_RESREQ_NODE_ATTR',
				'description': 'Not enough resource to satisfy SLURM node attributes requirment.  ',
				},
			5553:{
				'name':'PEND_SLURM_RESREQ_EXCLUDE',
				'description': 'Not enough resource to satisfy SLURM exclude requirment.  ',
				},
			5554:{
				'name':'PEND_SLURM_RESREQ_NODELIST',
				'description': 'Not enough resource to satisfy SLURM nodelist requirment.  ',
				},
			5555:{
				'name':'PEND_SLURM_RESREQ_CONTIGUOUS',
				'description': 'Not enough resource to satisfy SLURM contiguous requirment.  ',
				},
			5556:{
				'name':'PEND_SLURM_ALLOC_UNAVAIL',
				'description': 'SLURM allocation is not available.  Job requeued.  ',
				},
			5557:{
				'name':'PEND_SLURM_RESREQ_BAD_CONSTRAINT',
				'description': 'Invalid grammar in SLURM constraints option, job will never run.  ',
				},
			5600:{
				'name':'PEND_CRAYX1_SSP',
				'description': 'Not enough SSPs for job.  ',
				},
			5601:{
				'name':'PEND_CRAYX1_MSP',
				'description': 'Not enough MSPs for job.  ',
				},
			5602:{
				'name':'PEND_CRAYX1_PASS_LIMIT',
				'description': 'Unable to pass limit information to psched.  ',
				},
			5650:{
				'name':'PEND_CRAYXT3_ASSIGN_FAIL',
				'description': 'Unable to create or assign a partition by CPA.  ',
				},
			5700:{
				'name':'PEND_BLUEGENE_PLUGIN_INTERNAL',
				'description': 'BG/L: Scheduler plug-in internal error.  ',
				},
			5701:{
				'name':'PEND_BLUEGENE_ALLOC_UNAVAIL',
				'description': 'BG/L: Allocation is not available.  Job requeued.  ',
				},
			5702:{
				'name':'PEND_BLUEGENE_NOFREEMIDPLANES',
				'description': 'BG/L: No free base partitions available for a full block allocation.  ',
				},
			5703:{
				'name':'PEND_BLUEGENE_NOFREEQUARTERS',
				'description': 'BG/L: No free quarters available for a small block allocation.  ',
				},
			5704:{
				'name':'PEND_BLUEGENE_NOFREENODECARDS',
				'description': 'BG/L: No free node cards available for a small block allocation.  ',
				},
			5705:{
				'name':'PEND_RESIZE_FIRSTHOSTUNAVAIL',
				'description': 'First execution host unavailable.  ',
				},
			5706:{
				'name':'PEND_RESIZE_MASTERSUSP',
				'description': 'Master is not in the RUN state.  ',
				},
			5707:{
				'name':'PEND_RESIZE_MASTER_SAME',
				'description': 'Host is not same as for master.  ',
				},
			5708:{
				'name':'PEND_RESIZE_SPAN_PTILE',
				'description': 'Host already used by master.  ',
				},
			5709:{
				'name':'PEND_RESIZE_SPAN_HOSTS',
				'description': 'The job can only use first host.  ',
				},
			5710:{
				'name':'PEND_RESIZE_LEASE_HOST',
				'description': 'The job cannot get slots on remote hosts.  ',
				},
			5800:{
				'name':'PEND_COMPOUND_RESREQ_OLD_LEASE_HOST',
				'description': 'The job cannot get slots on pre-7Update5 remote hosts.  ',
				},
			5801:{
				'name':'PEND_COMPOUND_RESREQ_TOPLIB_HOST',
				'description': 'Hosts using LSF HPC system integrations do not support compound resource requirements.  ',
				},
			5900:{
				'name':'PEND_MULTIPHASE_RESREQ_OLD_LEASE_HOST',
				'description': 'The job cannot get slots on pre-7Update6 remote hosts.  ',
				},
			5750:{
				'name':'PEND_PS_PLUGIN_INTERNAL',
				'description': 'Host does not have enough slots for this SLA job.  ',
				},
			5751:{
				'name':'PEND_PS_MBD_SYNC',
				'description': 'EGO SLA: Failed to synchronize resource with MBD.  ',
				},
			20001:{
				'name':'PEND_CUSTOMER_MIN',
				'description': 'Customized pending reason number between min and max.  ',
				},
			25000:{
				'name':'PEND_CUSTOMER_MAX',
				'description': 'Customized pending reason number between min and max.  ',
				},
			25001:{
				'name':'PEND_MAX_REASONS',
				'description': 'The maximum number of reasons.  ',
				},
			}
class JobStatus(StateNumeric):
	states={
			0x00:{
				'name':'JOB_STAT_NULL'  ,
				'description': 'State null.' ,
				},
			0x01:{
				'name':'JOB_STAT_PEND',
				'description':'The job is pending, i.e., it has not been dispatched yet.',
				},
			0x02:{
				'name':"JOB_STAT_PSUSP",
				'description':"The pending job was suspended by its owner or the LSF system administrator.",
				},
			0x04:{
				'name':"JOB_STAT_RUN",
				'description':"The job is running.",
				},
			0x08:{
				'name':"JOB_STAT_SSUSP",
				'description':"The running job was suspended by the system because an execution host was overloaded or the queue run window closed.",
				},
			0x10:{
				'name':"JOB_STAT_USUSP",
				'description':"The running job was suspended by its owner or the LSF system administrator.",
				},
			0x20:{
				'name':"JOB_STAT_EXIT",
				'description':"The job has terminated with a non-zero status - it may have been aborted due to an error in its execution, or killed by its owner or by the LSF system administrator.",
				},
			0x40:{
				'name':"JOB_STAT_DONE",
				'description':"The job has terminated with status 0.",
				},
			0x80:{
				'name':"JOB_STAT_PDONE",
				'description':"Post job process done successfully.",
				},
			0x100:{
				'name':"JOB_STAT_PERR",
				'description':"Post job process has error.",
				},
			0x200:{
				'name':"JOB_STAT_WAIT",
				'description':"Chunk job waiting its turn to exec.",
				},
			0x10000:{
				'name':"JOB_STAT_UNKWN",
				'description':"The slave batch daemon (sbatchd) on the host on which the job is processed has lost contact with the master batch daemon (mbatchd).",
				},
			}

