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

from libc.stdlib cimport malloc, free
from libc.string cimport strcmp
from cpython.string cimport PyString_AsString
cimport openlava
from datetime import timedelta
from datetime import datetime
import json

class NumericState:
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

	@property
	def friendly(self):
		try:
			return u"%s" % self.states[self._status]['friendly']
		except:
			return u""


	@classmethod
	def get_status_list(cls, mask):
		statuses=[]
		for key in cls.states.keys():
			if (key & mask) == key: 
				statuses.append(cls(key))
		return statuses

	def to_dict(self):
		return {'name':self.name,'description':self.description,'status':self._status}


class PendReason(NumericState):
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
                        17:{
                                'name':'PEND_JOB_NO_PASSWD',
                                'description': 'Failed to get user password.  ',
                                },
                        19:{
                                'name':'PEND_JOB_MODIFY',
                                'description': 'The job is waiting to be re-scheduled after its parameters have been changed.  ',
                                },
                        23:{
                                'name':'PEND_JOB_REQUEUED',
                                'description': 'The job has been requeued.  ',
                                },
                        35:{
                                'name':'PEND_SYS_UNABLE',
                                'description': 'The system is unable to schedule the job.  ',
                                },
                        38:{
                                'name':'PEND_JOB_ARRAY_JLIMIT',
                                'description': 'The job has reached its running element limit.  ',
                                },
                        39:{
                                'name':'PEND_CHKPNT_DIR',
                                'description': 'Checkpoint directory is invalid.  ',
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
                        2900:{
                                'name':'PEND_MAX_REASONS',
                                'description': 'The maximum number of reasons.  ',
                                },
                        }

class JobStatus(NumericState):
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

class SuspReason(NumericState):
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
			0x00000020:{
				'name':'SUSP_HOST_LOCK',
				'description': "The LSF administrator has locked the execution host.  ",
				},
			0x00000040:{
				'name':'SUSP_LOAD_REASON',
				'description': "A load index exceeds its threshold.  The subreasons field indicates which indices.  ",
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
	}

class RUsage:

	def __init__(self, r):
		for i in ['mem','swap','utime','stime','npids','npgids','pgid']:
			setattr(self,"_%s" % i, getattr(r,i))
		self._pidInfo=[PIDInfo(i) for i in r.pidInfo]

	def to_dict(self):
		items={}
		for i in ['resident_memory_usage','virtual_memory_usage','user_time','system_time','num_active_processes','active_processes','num_active_process_groups','active_process_groups']:
			items[i]=getattr(self,i)
		items['user_time_timedelta']="%s" % self.user_time_timedelta
		items['system_time_timedelta']="%s" % self.system_time_timedelta
		return items


	@property
	def resident_memory_usage(self):
		return self._mem

	@property
	def virtual_memory_usage(self):
		return self._swap

	@property
	def user_time(self):
		return self._utime

	@property
	def user_time_timedelta(self):
		return timedelta(seconds=self.user_time)

	@property
	def system_time(self):
		return self._stime

	@property
	def system_time_timedelta(self):
		return timedelta(seconds=self.system_time)

	@property
	def num_active_processes(self):
		return self._npids

	@property
	def active_processes(self):
		return self._pidInfo

	@property
	def num_active_process_groups(self):
		return self._npgids

	@property
	def active_process_groups(self):
		return self._pgid


class PIDInfo:
	def to_dict(self):
		items={}
		for i in ['process_id','parent_process_id','group_id','cray_job_id']:
			items[i]=getattr(self,i)
		return items

	def __init__(self, p):
		self._pid=p.pid
		self._ppid=p.ppid
		self._pgid=p.pgid
		self._jobid=p.jobid

	@property
	def process_id(self):
		return self._pid

	@property
	def parent_process_id(self):
		return self._ppid

	@property
	def group_id(self):
		return self._pgid

	@property
	def cray_job_id(self):
		return self._jobid


class Submit2Option(NumericState):
	states={
			0x01:{
				'name':'SUB2_HOLD',
				'description': "",
				'friendly': "SUB2_HOLD",
				},
			0x02:{
				'name':'SUB2_MODIFY_CMD',
				'description': "",
				'friendly': "SUB2_MODIFY_CMD",
				},
			0x04:{
				'name':'SUB2_BSUB_BLOCK',
				'description': "",
				'friendly': "SUB2_BSUB_BLOCK",
				},
			0x08:{
				'name':'SUB2_HOST_NT',
				'description': "",
				'friendly': "SUB2_HOST_NT",
				},
			0x10:{
				'name':'SUB2_HOST_UX',
				'description': "",
				'friendly': "SUB2_HOST_UX",
				},
			0x20:{
				'name':'SUB2_QUEUE_CHKPNT',
				'description': "",
				'friendly': "SUB2_QUEUE_CHKPNT",
				},
			0x40:{
				'name':'SUB2_QUEUE_RERUNNABLE',
				'description': "",
				'friendly': "SUB2_QUEUE_RERUNNABLE",
				},
			0x80:{
				'name':'SUB2_IN_FILE_SPOOL',
				'description': "",
				'friendly': "SUB2_IN_FILE_SPOOL",
				},
			0x100:{
				'name':'SUB2_JOB_CMD_SPOOL',
				'description': "",
				'friendly': "SUB2_JOB_CMD_SPOOL",
				},
			0x200:{
				'name':'SUB2_JOB_PRIORITY',
				'description': "",
				'friendly': "SUB2_JOB_PRIORITY",
				},
			0x400:{
				'name':'SUB2_USE_DEF_PROCLIMIT',
				'description': "",
				'friendly': "SUB2_USE_DEF_PROCLIMIT",
				},
			0x800:{
				'name':'SUB2_MODIFY_RUN_JOB',
				'description': "",
				'friendly': "SUB2_MODIFY_RUN_JOB",
				},
			0x1000:{
				'name':'SUB2_MODIFY_PEND_JOB',
				'description': "",
				'friendly': "SUB2_MODIFY_PEND_JOB",
				},
			}
class SubmitOption(NumericState):
	states={
			0x01:{
				'name':'SUB_JOB_NAME',
				'description': "Submitted with a job name",
				'friendly': "Job submitted with name",
				},
			0x02:{
				'name':'SUB_QUEUE',
				'description': "",
				'friendly': "Job submitted with queue",
				},
			0x04:{
				'name':'SUB_HOST',
				'description': "",
				'friendly': "SUB_HOST",
				},
			0x08:{
				'name':'SUB_IN_FILE',
				'description': "",
				'friendly': "Job Submitted with input file",
				},
			0x10:{
				'name':'SUB_OUT_FILE',
				'description': "",
				'friendly': "Job submitted with output file",
				},
			0x20:{
				'name':'SUB_ERR_FILE',
				'description': "",
				'friendly': "Job submitted with error file",
				},
			0x40:{
				'name':'SUB_EXCLUSIVE',
				'description': "",
				'friendly': "Job submitted to run exclusively",
				},
			0x80:{
				'name':'SUB_NOTIFY_END',
				'description': "",
				'friendly': "SUB_NOTIFY_END",
				},
			0x100:{
				'name':'SUB_NOTIFY_BEGIN',
				'description': "",
				'friendly': "SUB_NOTIFY_BEGIN",
				},
			0x200:{
				'name':'SUB_USER_GROUP',
				'description': "",
				'friendly': "SUB_USER_GROUP",
				},
			0x400:{
				'name':'SUB_CHKPNT_PERIOD',
				'description': "",
				'friendly': "Job submitted with checkpoint period",
				},
			0x800:{
				'name':'SUB_CHKPNT_DIR',
				'description': "",
				'friendly': "Job submitted with checkpoint directory",
				},
			0x1000:{
				'name':'SUB_RESTART_FORCE',
				'description': "",
				'friendly': "SUB_RESTART_FORCE",
				},
			0x2000:{
				'name':'SUB_RESTART',
				'description': "",
				'friendly': "SUB_RESTART",
				},
			0x4000:{
				'name':'SUB_RERUNNABLE',
				'description': "",
				'friendly': "Job submitted as rerunnable",
				},
			0x8000:{
				'name':'SUB_WINDOW_SIG',
				'description': "",
				'friendly': "SUB_WINDOW_SIG",
				},
			0x10000:{
				'name':'SUB_HOST_SPEC',
				'description': "",
				'friendly': "Job submitted with host spec",
				},
			0x20000:{
				'name':'SUB_DEPEND_COND',
				'description': "",
				'friendly': "Job submitted with depend conditions",
				},
			0x40000:{
				'name':'SUB_RES_REQ',
				'description': "",
				'friendly': "Job submitted with resource request",
				},
			0x80000:{
				'name':'SUB_OTHER_FILES',
				'description': "",
				'friendly': "SUB_OTHER_FILES",
				},
			0x100000:{
				'name':'SUB_PRE_EXEC',
				'description': "",
				'friendly': "Job submitted with pre exec script",
				},
			0x200000:{
				'name':'SUB_LOGIN_SHELL',
				'description': "",
				'friendly': "Job submitted with login shell",
				},
			0x400000:{
				'name':'SUB_MAIL_USER',
				'description': "",
				'friendly': "Job submitted to email user",
				},
			0x800000:{
				'name':'SUB_MODIFY',
				'description': "",
				'friendly': "SUB_MODIFY",
				},
			0x1000000:{
				'name':'SUB_MODIFY_ONCE',
				'description': "",
				'friendly': "SUB_MODIFY_ONCE",
				},
			0x2000000:{
				'name':'SUB_PROJECT_NAME',
				'description': "",
				'friendly': "Job submitted to project",
				},
			0x4000000:{
				'name':'SUB_INTERACTIVE',
				'description': "",
				'friendly': "Job submitted as interactive",
				},
			0x8000000:{
				'name':'SUB_PTY',
				'description': "",
				'friendly': "SUB_PTY",
				},
			0x10000000:{
				'name':'SUB_PTY_SHELL',
				'description': "",
				'friendly': "SUB_PTY_SHELL",
				},
			}



class Submit:
	def __init__(self, s):
		for i in ['options','options2','jobName','queue','numAskedHosts','askedHosts','resReq','hostSpec','numProcessors','dependCond','beginTime','termTime','sigValue','inFile','outFile','errFile','command','chkpntPeriod','chkpntDir','nxf','preExecCmd','mailUser','delOptions','delOptions2','projectName','maxNumProcessors','loginShell','userPriority']:
			setattr(self,"_%s" % i,getattr(s,i))
		self._xf= [ TransferFile(i) for i in s.xf]
		self._rLimits=RLimit(*s.rLimits)

	def to_dict(self):
		items={}
		for i in ['options','job_name','queue_name','num_asked_hosts','asked_hosts','requested_resources','resource_limits','host_specification','num_processors','dependency_condition','begin_time','termination_time','signal_value','input_file','output_file','error_file','command','checkpoint_period','checkpoint_dir','num_transfer_files','transfer_files','pre_execution_command','email_user','delete_options','project_name','max_num_processors','login_shell','user_priority']:
			items[i]=getattr(self,i)
		return items

	@property
	def options(self):
		options=[]
		options.extend(SubmitOption.get_status_list(self._options))
		options.extend(Submit2Option.get_status_list(self._options2))
		return options

	@property
	def job_name(self):
		return self._jobName

	@property
	def queue_name(self):
		return self._queue

	@property
	def num_asked_hosts(self):
		return self._numAskedHosts

	@property
	def asked_hosts(self):
		return self._askedHosts

	@property
	def requested_resources(self):
		return self._resReq

	@property
	def resource_limits(self):
		return self._rLimits

	@property
	def host_specification(self):
		return self._hostSpec

	@property
	def num_processors(self):
		return self._numProcessors

	@property
	def dependency_condition(self):
		return self._dependCond

	@property
	def begin_time(self):
		return self._beginTime

	@property
	def begin_time_datetime_local(self):
		return datetime.fromtimestamp(self.begin_time)

	@property
	def begin_time_datetime_utc(self):
		return datetime.utcfromtimestamp(self.begin_time)

	@property
	def termination_time(self):
		return self._termTime

	@property
	def termination_time_datetime_local(self):
		return datetime.fromtimestamp(self.termination_time)

	@property
	def termination_time_datetime_utc(self):
		return datetime.utcfromtimestamp(self.termination_time)

	@property
	def signal_value(self):
		return self._sigValue

	@property
	def input_file(self):
		return self._inFile

	@property
	def output_file(self):
			return self._outFile

	@property
	def error_file(self):
		return self._errFile

	@property
	def command(self):
		return self._command

	@property
	def new_command(self):
		return self._newCommand

	@property
	def checkpoint_period(self):
		return self._chkpntPeriod

	@property
	def checkpoint_dir(self):
		return self._chkpntDir

	@property
	def num_transfer_files(self):
		return self._nxf

	@property
	def transfer_files(self):
		return self._xf

	@property
	def pre_execution_command(self):
		return  self._preExecCmd

	@property
	def email_user(self):
		return  self._mailUser

	@property
	def delete_options(self):
		options=[]
		options.extend(SubmitOption.get_status_list(self._delOptions))
		options.extend(Submit2Option.get_status_list(self._delOptions2))
		return options

	@property
	def project_name(self):
		return self._projectName

	@property
	def max_num_processors(self):
		return self._maxNumProcessors

	@property
	def login_shell(self):
			return self._loginShell

	@property
	def user_priority(self):
		return self._userPriority


class TransferFile:
	def __init__(self,f):
		self._subFn=f.subFn
		self._xecFn=f.execFn
		self._options=f.options

	@property
	def submission_file_name(self):
		return self._subFn

	@property
	def execution_file_name(self):
		return self._execFn

	@property
	def options(self):
		return self._options


# Jobs are a little different as OpenLava uses the same memory for each job info, which means once readjobinfo has been called, the data
# changes.  As such data is copied locally at initialization time.
class Job:
	def __init__(self, j=None, job_id=None, array_id=0):
		if not isinstance(j, __jobInfoEnt):
			j=OpenLava.create_job_id(job_id, array_id)
			if not OpenLava.initialized:
				OpenLava.__initialize()
			num_jobs=OpenLavaCAPI.lsb_openjobinfo(job_id=j)
			if num_jobs<1:
				OpenLavaCAPI.lsb_closejobinfo()
				raise ValueError("Cannot Load Job by id")
			j=OpenLavaCAPI.lsb_readjobinfo()
			OpenLavaCAPI.lsb_closejobinfo()

		if not isinstance(j, __jobInfoEnt):
			raise ValueError("Job not __jobInfoEnt instance")

		for attr in ['user','status','reserveTime', 'reasonTb','numReasons','reasons','subreasons','jobId', 'jobPid','submitTime','startTime','predictedStartTime','endTime','cpuTime','umask','cwd','subHomeDir','fromHost','exHosts','cpuFactor','nIdx','loadSched','loadStop','exitStatus','execUid','execHome','execCwd','execUsername','jRusageUpdateTime','jType','parentGroup','jName','counter','port','jobPriority']:
			setattr(self, "_%s" % attr, getattr(j,attr))
		self._runRusage=RUsage(j.runRusage)
		self._submit=Submit(j.submit)

	def __str__(self):
		if len(self.name)>0:
			return "%d (%s)"%(self.job_id, self.name)
		else:
			return "%d" % self.job_id

	def __unicode__(self):
		return u'%s' % self.__str__()

	def __int__(self):
		return self.job_id

	def to_dict(self):
		items={}
		for i in ['admins', 'reasons','submit','resource_usage','user','status','pid','cpu_time','cwd','submit_home_dir','submission_host','execution_hosts','cpu_factor','execution_user_id','execution_home_dir','execution_cwd','execution_user_name','parent_group','job_id','name','service_port','priority','submit_time','reservation_time','start_time','predicted_start_time','end_time','resource_usage_last_update_time']:
			items[i]=getattr(self,i)
		items['predicted_start_time_datetime']="%s" % self.predicted_start_time_datetime_local
		items['start_time_datetime']="%s" % self.start_time_datetime_local
		items['end_time_datetime']="%s" % self.end_time_datetime_local
		return items

	@property
	def reasons(self):
		v={
		}
		for reason in self._reasonTb:
			reason=reason & 0x00000000000ffff
			if self.status.name=="JOB_STAT_PEND": # pend
				r=PendReason(reason)
			if self.status.name=="JOB_STAT_PSUSP": # psusp
				r=SuspReason(reason)
			try:
				v[r.name]['count']+=1
			except:
				v[r.name]={
						'count':1,
						'name':r.name,
						'description':r.description,
						'status':r.status,
						'friendly_name':r.friendly,
						}
		print v.values()
		return v.values()

	@property
	def submit(self):
		return self._submit

	@property
	def resource_usage(self):
		return self._runRusage

	@property
	def user(self):
		return self._user

	@property
	def status(self):
		return JobStatus(self._status)

	@property
	def pid(self):
		return self._jobPid

	@property
	def cpu_time(self):
		return self._cpuTime

	@property
	def cpu_time_timedelta(self):
		return timedelta(seconds=self.cpu_time)

	@property
	def cwd(self):
		return self._cwd

	@property
	def submit_home_dir(self):
		return self._subHomeDir

	@property
	def submission_host(self):
		return self._fromHost

	@property
	def execution_hosts(self):
		return self._exHosts

	@property
	def cpu_factor(self):
		return self._cpuFactor

	@property
	def execution_user_id(self):
		return self._execUid

	@property
	def execution_home_dir(self):
		return self._execHome

	@property
	def execution_cwd(self):
		return self._execCwd

	@property
	def execution_user_name(self):
		return self._execUsername

	@property
	def parent_group(self):
			return self._parentGroup

	@property
	def job_id(self):
			return OpenLava.get_job_id(self._jobId)

	@property
	def array_id(self):
			return OpenLava.get_array_index(self._jobId)

	@property
	def full_id(self):
			return self._jobId

	@property
	def name(self):
			return self._jName

	@property
	def service_port(self):
			return self._port

	@property
	def priority(self):
			return self._jobPriority

	@property
	def submit_time(self):
			return self._submitTime
	@property
	def submit_time_datetime_local(self):
			return datetime.fromtimestamp(self.submit_time)
	@property
	def submit_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.submit_time)


	@property
	def reservation_time(self):
			return self._reserveTime
	@property
	def reservation_time_datetime_local(self):
			return datetime.fromtimestamp(self.reservation_time)
	@property
	def reservation_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.reservation_time)

	@property
	def start_time(self):
			return self._startTime
	@property
	def start_time_datetime_local(self):
			return datetime.fromtimestamp(self.start_time)
	@property
	def start_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.start_time)

	@property
	def predicted_start_time(self):
			return self._predictedStartTime
	@property
	def predicted_start_time_datetime_local(self):
			return datetime.fromtimestamp(self.predicted_start_time)
	@property
	def predicted_start_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.predicted_start_time)

	@property
	def end_time(self):
			return self._endTime
	@property
	def end_time_datetime_local(self):
			return datetime.fromtimestamp(self.end_time)
	@property
	def end_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.end_time)

	@property
	def resource_usage_last_update_time(self):
			return self._jRusageUpdateTime
	@property
	def resource_usage_last_update_time_datetime_local(self):
			return datetime.fromtimestamp(self.resource_usage_last_update_time)
	@property
	def resource_usage_last_update_time_datetime_utc(self):
			return datetime.utcfromtimestamp(self.resource_usage_last_update_time)

	@property
	def admins(self):
		admins=[self.user]
		q=Queue(self.submit.queue_name)
		admins.extend(q.queue_admins)
		return admins

	def get_full_job_id(self):
		return OpenLava.create_job_id(self.job_id, self.array_id)

	def kill(self):
		full_job_id=self.get_full_job_id()
		return OpenLavaCAPI.lsb_signaljob(full_job_id, OpenLavaCAPI.SIGKILL)

	def suspend(self):
		full_job_id=self.get_full_job_id()
		code=OpenLavaCAPI.lsb_signaljob(full_job_id, OpenLavaCAPI.SIGSTOP)
		return code

	def requeue(self, hold=False):
		new_state=OpenLavaCAPI.JOB_STAT_PEND
		if hold:
			new_state=OpenLavaCAPI.JOB_STAT_PSUSP

		if self.status.name==u"JOB_STAT_DONE":
			option=OpenLavaCAPI.REQUEUE_DONE
		elif self.status.name==u"JOB_STAT_RUN":
			option=OpenLavaCAPI.REQUEUE_RUN
		elif self.status.name==u"JOB_STAT_EXIT":
			option=OpenLavaCAPI.REQUEUE_EXIT
		else:
			raise ValueError(self.status)

		return OpenLavaCAPI.lsb_requeuejob(self.job_id, self.array_id, new_state, option)

	def resume(self):
		full_job_id=self.get_full_job_id()
		return OpenLavaCAPI.lsb_signaljob(full_job_id, OpenLavaCAPI.SIGCONT)


	def has_admin(self, user):
		if user == self.user or user in self.queue.admins:
			return True
		else:
			return False

##############################
###########
#

cdef class __userInfoEnt:
	cdef userInfoEnt * _data
	cdef _set_struct(self, userInfoEnt * data ):
		self._data=data

	property user:
		def __get__(self):
			return u'%s' % self._data.user

	property procJobLimit:
		def __get__(self):
			return self._data.procJobLimit

	property maxJobs:
		def __get__(self):
			return self._data.maxJobs

	property numStartJobs:
		def __get__(self):
			return self._data.numStartJobs

	property numJobs:
		def __get__(self):
			return self._data.numJobs

	property numPEND:
		def __get__(self):
			return self._data.numPEND

	property numRUN:
		def __get__(self):
			return self._data.numRUN

	property numSSUSP:
		def __get__(self):
			return self._data.numSSUSP

	property numUSUSP:
		def __get__(self):
			return self._data.numUSUSP

	property numRESERVE:
		def __get__(self):
			return self._data.numRESERVE

cdef class __pidInfo:
	cdef pidInfo * _data

	cdef _set_struct(self, pidInfo * data ):
		self._data=data

	property pid:
		def __get__(self):
			return self._data.pid

	property ppid:
		def __get__(self):
			return self._data.ppid

	property pgid:
		def __get__(self):
			return self._data.pgid

	property jobid:
		def __get__(self):
			return self._data.jobid

cdef class __jRusage:
	cdef jRusage * _data

	cdef _set_struct(self, jRusage * data ):
		self._data=data

	property mem:
		def __get__(self):
			return self._data.mem

	property swap:
		def __get__(self):
			return self._data.swap

	property utime:
		def __get__(self):
			return self._data.utime

	property stime:
		def __get__(self):
			return self._data.stime

	property npids:
		def __get__(self):
			return self._data.npids

	property pidInfo:
		def __get__(self):
			pids=[]
			for i in range(self.npids):
				p=__pidInfo()
				p._set_struct(self._data.pidInfo)
				pids.append(p)
			return pids

	property npgids:
		def __get__(self):
			return self._data.npgids

	property pgid:
		def __get__(self):
			return [ self._data.pgid[i] for i in range(self.npgids)]


cdef class __xFile:
	cdef xFile * _data

	cdef _set_struct(self, xFile * data ):
		self._data=data

	property subFn:
		def __get__(self):
			return self._data.subFn

	property execFn:
		def __get__(self):
			return self._data.execFn

	property options:
		def __get__(self):
			return self._data.options



cdef class __submit:
	cdef submit * _data

	cdef _set_struct(self, submit * data ):
		self._data=data

	property options:
		def __get__(self):
			return self._data.options

	property options2:
		def __get__(self):
			return self._data.options2

	property jobName:
		def __get__(self):
			return u'%s' % self._data.jobName

	property queue:
		def __get__(self):
			return u'%s' % self._data.queue

	property numAskedHosts:
		def __get__(self):
			return self._data.numAskedHosts

	property askedHosts:
		def __get__(self):
			return [u'%s' % self._data.askedHosts[i] for i in range(self.numAskedHosts)]

	property resReq:
		def __get__(self):
			return u'%s' % self._data.resReq

	property rLimits:
		def __get__(self):
			rlims=[self._data.rLimits[i] for i in range(11)]
			return rlims

	property hostSpec:
		def __get__(self):
			return u'%s' % self._data.hostSpec

	property numProcessors:
		def __get__(self):
			return self._data.numProcessors

	property dependCond:
		def __get__(self):
			return u'%s' % self._data.dependCond

	property beginTime:
		def __get__(self):
			return self._data.beginTime

	property termTime:
		def __get__(self):
			return self._data.termTime

	property sigValue:
		def __get__(self):
			return self._data.sigValue

	property inFile:
		def __get__(self):
			return u'%s' % self._data.inFile

	property outFile:
		def __get__(self):
			return u'%s' % self._data.outFile

	property errFile:
		def __get__(self):
			return u'%s' % self._data.errFile

	property command:
		def __get__(self):
			return u'%s' % self._data.command

	property newCommand:
		def __get__(self):
			return u'%s' % self._data.newCommand

	property chkpntPeriod:
		def __get__(self):
			return self._data.chkpntPeriod

	property chkpntDir:
		def __get__(self):
			return u'%s' % self._data.chkpntDir

	property nxf:
		def __get__(self):
			return self._data.nxf

	property xf:
		def __get__(self):
			xfs=[]
			for i in range(self.nxf):
				x=__xFile()
				x._set_struct(&self._data.xf[i])
				xfs.append(x)
			return xfs

	property preExecCmd:
		def __get__(self):
			return u'%s' % self._data.preExecCmd

	property mailUser:
		def __get__(self):
			return u'%s' % self._data.mailUser

	property delOptions:
		def __get__(self):
			return self._data.delOptions

	property delOptions2:
		def __get__(self):
			return self._data.delOptions2

	property projectName:
		def __get__(self):
			return u'%s' % self._data.projectName

	property maxNumProcessors:
		def __get__(self):
			return self._data.maxNumProcessors

	property loginShell:
		def __get__(self):
			return u'%s' % self._data.loginShell

	property userPriority:
		def __get__(self):
			return self._data.userPriority

cdef class __queueInfoEnt:
	cdef queueInfoEnt * _data

	cdef _set_struct(self, queueInfoEnt * data ):
		self._data=data

	property queue:
		def __get__(self):
			return u'%s' % self._data.queue

	property description:
		def __get__(self):
			return u'%s' % self._data.description

	property priority:
		def __get__(self):
			return self._data.priority

	property nice:
		def __get__(self):
			return self._data.nice

	property userList:
		def __get__(self):
			return u'%s' % self._data.userList

	property hostList:
		def __get__(self):
			return u'%s' % self._data.hostList

	property nIdx:
		def __get__(self):
			return self._data.nIdx

	property loadSched:
		def __get__(self):
			return [self._data.loadSched[i] for i in range(self.nIdx)]

	property loadStop:
		def __get__(self):
			return [self._data.loadStop[i] for i in range(self.nIdx)]

	property userJobLimit:
		def __get__(self):
			return self._data.userJobLimit

	property procJobLimit:
		def __get__(self):
			return self._data.procJobLimit

	property windows:
		def __get__(self):
			return u'%s' % self._data.windows

	property rLimits:
		def __get__(self):
			return [self._data.rLimits[i] for i in range(11)]

	property hostSpec:
		def __get__(self):
			return u'%s' % self._data.hostSpec

	property qAttrib:
		def __get__(self):
			return self._data.qAttrib

	property qStatus:
		def __get__(self):
			return self._data.qStatus

	property maxJobs:
		def __get__(self):
			return self._data.maxJobs

	property numJobs:
		def __get__(self):
			return self._data.numJobs

	property numPEND:
		def __get__(self):
			return self._data.numPEND

	property numRUN:
		def __get__(self):
			return self._data.numRUN

	property numSSUSP:
		def __get__(self):
			return self._data.numSSUSP

	property numUSUSP:
		def __get__(self):
			return self._data.numUSUSP

	property mig:
		def __get__(self):
			return self._data.mig

	property schedDelay:
		def __get__(self):
			return self._data.schedDelay

	property acceptIntvl:
		def __get__(self):
			return self._data.acceptIntvl

	property windowsD:
		def __get__(self):
			return u'%s' % self._data.windowsD

	property defaultHostSpec:
		def __get__(self):
			return u'%s' % self._data.defaultHostSpec

	property procLimit:
		def __get__(self):
			return self._data.procLimit

	property admins:
		def __get__(self):
			return u'%s' % self._data.admins

	property preCmd:
		def __get__(self):
			return u'%s' % self._data.preCmd

	property postCmd:
		def __get__(self):
			return u'%s' % self._data.postCmd

	property prepostUsername:
		def __get__(self):
			return u'%s' % self._data.prepostUsername

	property requeueEValues:
		def __get__(self):
			return u'%s' % self._data.requeueEValues

	property hostJobLimit:
		def __get__(self):
			return self._data.hostJobLimit

	property resReq:
		def __get__(self):
			return u'%s' % self._data.resReq

	property numRESERVE:
		def __get__(self):
			return self._data.numRESERVE

	property slotHoldTime:
		def __get__(self):
			return self._data.slotHoldTime

	property resumeCond:
		def __get__(self):
			return u'%s' % self._data.resumeCond

	property stopCond:
		def __get__(self):
			return u'%s' % self._data.stopCond

	property jobStarter:
		def __get__(self):
			return u'%s' % self._data.jobStarter

	property suspendActCmd:
		def __get__(self):
			return u'%s' % self._data.suspendActCmd

	property resumeActCmd:
		def __get__(self):
			return u'%s' % self._data.resumeActCmd

	property terminateActCmd:
		def __get__(self):
			return u'%s' % self._data.terminateActCmd

	property sigMap:
		def __get__(self):
			return [self._data.sigMap[i] for i in range(22)]

	property chkpntDir:
		def __get__(self):
			return u'%s' % self._data.chkpntDir

	property chkpntPeriod:
		def __get__(self):
			return self._data.chkpntPeriod

	property defLimits:
		def __get__(self):
			return [self._data.rLimits[i] for i in range(11)]

	property minProcLimit:
		def __get__(self):
			return self._data.minProcLimit

	property defProcLimit:
		def __get__(self):
			return self._data.defProcLimit


cdef class __hostInfoEnt:
	cdef hostInfoEnt * _data
	
	cdef _set_struct(self, hostInfoEnt * data ):
		self._data=data
		

	property host:
		def __get__(self):
			return u'%s' % self._data.host

	property hStatus:
		def __get__(self):
			return self._data.hStatus

	property busySched:
		def __get__(self):
			return [self._data.busySched[i] for i in range(self.nIdx)]

	property busyStop:
		def __get__(self):
			return [self._data.busyStop[i] for i in range(self.nIdx)]

	property cpuFactor:
		def __get__(self):
			return self._data.cpuFactor

	property nIdx:
		def __get__(self):
			return self._data.nIdx

	property load:
		def __get__(self):
			return [self._data.loadStop[i] for i in range(self.nIdx)]

	property loadSched:
		def __get__(self):
			return [self._data.loadSched[i] for i in range(self.nIdx)]

	property loadStop:
		def __get__(self):
			return [self._data.loadStop[i] for i in range(self.nIdx)]

	property windows:
		def __get__(self):
			return u'%s' % self._data.windows

	property userJobLimit:
		def __get__(self):
			return self._data.userJobLimit

	property maxJobs:
		def __get__(self):
			return self._data.maxJobs

	property numJobs:
		def __get__(self):
			return self._data.numJobs

	property numRUN:
		def __get__(self):
			return self._data.numRUN

	property numSSUSP:
		def __get__(self):
			return self._data.numSSUSP

	property numUSUSP:
		def __get__(self):
			return self._data.numUSUSP

	property mig:
		def __get__(self):
			return self._data.mig

	property attr:
		def __get__(self):
			return self._data.attr

	property realLoad:
		def __get__(self):
			return [self._data.realLoad[i] for i in range(self.nIdx)]

	property numRESERVE:
		def __get__(self):
			return self._data.numRESERVE

	property chkSig:
		def __get__(self):
			return self._data.chkSig


cdef class __jobInfoEnt:
	cdef jobInfoEnt * _data

	cdef _set_struct(self, jobInfoEnt * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property user:
		def __get__(self):
			return u'%s' % self._data.user

	property status:
		def __get__(self):
			return self._data.status

	property reasonTb:
		def __get__(self):
			return [self._data.reasonTb[i] for i in range(self.numReasons)]

	property numReasons:
		def __get__(self):
			return self._data.numReasons

	property reasons:
		def __get__(self):
			return self._data.reasons

	property subreasons:
		def __get__(self):
			return self._data.subreasons

	property jobPid:
		def __get__(self):
			return self._data.jobPid

	property submitTime:
		def __get__(self):
			return self._data.submitTime

	property reserveTime:
		def __get__(self):
			return self._data.reserveTime

	property startTime:
		def __get__(self):
			return self._data.startTime

	property predictedStartTime:
		def __get__(self):
			return self._data.predictedStartTime

	property endTime:
		def __get__(self):
			return self._data.endTime

	property cpuTime:
		def __get__(self):
			return self._data.cpuTime

	property umask:
		def __get__(self):
			return self._data.umask

	property cwd:
		def __get__(self):
			return u'%s' % self._data.cwd

	property subHomeDir:
		def __get__(self):
			return u'%s' % self._data.subHomeDir

	property fromHost:
		def __get__(self):
			return u'%s' % self._data.fromHost

	property exHosts:
		def __get__(self):
			return [ u'%s' % self._data.exHosts[i] for i in range(self.numExHosts)]

	property numExHosts:
		def __get__(self):
			return self._data.numExHosts

	property cpuFactor:
		def __get__(self):
			return self._data.cpuFactor

	property nIdx:
		def __get__(self):
			return self._data.nIdx

	property loadSched:
		def __get__(self):
			return [self._data.loadSched[i] for i in range(self.nIdx)]

	property loadStop:
		def __get__(self):
			return [self._data.loadStop[i] for i in range(self.nIdx)]

	property submit:
		def __get__(self):
			s=__submit()
			s._set_struct(&self._data.submit)
			return s

	property exitStatus:
		def __get__(self):
			return self._data.exitStatus

	property execUid:
		def __get__(self):
			return self._data.execUid

	property execHome:
		def __get__(self):
			return u'%s' % self._data.execHome

	property execCwd:
		def __get__(self):
			return u'%s' % self._data.execCwd

	property execUsername:
		def __get__(self):
			return u'%s' % self._data.execUsername

	property jRusageUpdateTime:
		def __get__(self):
			return self._data.jRusageUpdateTime

	property runRusage:
		def __get__(self):
			r=__jRusage()
			r._set_struct(&self._data.runRusage)
			return r

	property jType:
		def __get__(self):
			return self._data.jType

	property parentGroup:
		def __get__(self):
			return u'%s' % self._data.parentGroup

	property jName:
		def __get__(self):
			return u'%s' % self._data.jName

	property counter:
		def __get__(self):
			return [self._data.counter[i] for i in range(7)]

	property port:
		def __get__(self):
			return self._data.port

	property jobPriority:
		def __get__(self):
			return self._data.jobPriority


cdef char ** to_cstring_array(list_str):
	cdef char **ret = <char **>malloc(len(list_str) * sizeof(char *))
	for i in xrange(len(list_str)):
		ret[i] = PyString_AsString(list_str[i])
	return ret

cdef class OpenLavaCAPI:
	@classmethod 
	def get_lsberrno(cls):
		return openlava.lsberrno

	REQUEUE_DONE=  0x1
	REQUEUE_EXIT=  0x2
	REQUEUE_RUN =  0x4

	SIGKILL=9
	SIGSTOP=19
	SIGCONT=18

	NUM_JGRP_COUNTERS=8

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

	HOST_STAT_OK = 0x0
	HOST_STAT_BUSY = 0x01
	HOST_STAT_WIND = 0x02
	HOST_STAT_DISABLED = 0x04
	HOST_STAT_LOCKED = 0x08
	HOST_STAT_FULL = 0x10
	HOST_STAT_UNREACH = 0x20
	HOST_STAT_UNAVAIL = 0x40
	HOST_STAT_NO_LIM = 0x80
	HOST_STAT_EXCLUSIVE = 0x100
	HOST_STAT_LOCKED_MASTER = 0x200

	QUEUE_STAT_OPEN = 0x01
	QUEUE_STAT_ACTIVE = 0x02
	QUEUE_STAT_RUN = 0x04
	QUEUE_STAT_NOPERM = 0x08
	QUEUE_STAT_DISC = 0x10
	QUEUE_STAT_RUNWIN_CLOSE = 0x20

	PEND_JOB_REASON        =0
	PEND_JOB_NEW           =1
	PEND_JOB_START_TIME    =2
	PEND_JOB_DEPEND        =3
	PEND_JOB_DEP_INVALID   =4
	PEND_JOB_MIG           =5
	PEND_JOB_PRE_EXEC     = 6
	PEND_JOB_NO_FILE      = 7
	PEND_JOB_ENV          = 8
	PEND_JOB_PATHS        = 9
	PEND_JOB_OPEN_FILES   = 10
	PEND_JOB_EXEC_INIT    = 11
	PEND_JOB_RESTART_FILE = 12
	PEND_JOB_DELAY_SCHED  = 13
	PEND_JOB_SWITCH       = 14
	PEND_JOB_DEP_REJECT   = 15
	PEND_JOB_NO_PASSWD    = 17
	PEND_JOB_MODIFY       = 19
	PEND_JOB_REQUEUED     = 23
	PEND_SYS_UNABLE       = 35
	PEND_JOB_ARRAY_JLIMIT = 38
	PEND_CHKPNT_DIR       = 39
	PEND_QUE_INACT             =301
	PEND_QUE_WINDOW            =302
	PEND_QUE_JOB_LIMIT         =303
	PEND_QUE_USR_JLIMIT        =304
	PEND_QUE_USR_PJLIMIT       =305
	PEND_QUE_PRE_FAIL          =306
	PEND_SYS_NOT_READY         =310
	PEND_SBD_JOB_REQUEUE       =311
	PEND_JOB_SPREAD_TASK       =312
	PEND_QUE_SPREAD_TASK       =313
	PEND_QUE_PJOB_LIMIT        =314
	PEND_QUE_WINDOW_WILL_CLOSE= 315
	PEND_QUE_PROCLIMIT   =  316

	PEND_USER_JOB_LIMIT    =601
	PEND_UGRP_JOB_LIMIT    =602
	PEND_USER_PJOB_LIMIT   =603
	PEND_UGRP_PJOB_LIMIT   =604
	PEND_USER_RESUME       =605
	PEND_USER_STOP         =607
	PEND_NO_MAPPING        =608
	PEND_RMT_PERMISSION    =609
	PEND_ADMIN_STOP        =610
	PEND_HOST_RES_REQ      =1001
	PEND_HOST_NONEXCLUSIVE =1002
	PEND_HOST_JOB_SSUSP    =1003
	PEND_SBD_GETPID        =1005
	PEND_SBD_LOCK          =1006
	PEND_SBD_ZOMBIE        =1007
	PEND_SBD_ROOT          =1008
	PEND_HOST_WIN_WILL_CLOSE =1009
	PEND_HOST_MISS_DEADLINE  =1010
	PEND_FIRST_HOST_INELIGIBLE= 1011
	PEND_HOST_DISABLED    = 1301
	PEND_HOST_LOCKED      = 1302
	PEND_HOST_LESS_SLOTS  = 1303
	PEND_HOST_WINDOW      = 1304
	PEND_HOST_JOB_LIMIT   = 1305
	PEND_QUE_PROC_JLIMIT  = 1306
	PEND_QUE_HOST_JLIMIT  = 1307
	PEND_USER_PROC_JLIMIT = 1308
	PEND_HOST_USR_JLIMIT  = 1309
	PEND_HOST_QUE_MEMB    = 1310
	PEND_HOST_USR_SPEC    = 1311
	PEND_HOST_PART_USER   = 1312
	PEND_HOST_NO_USER     = 1313
	PEND_HOST_ACCPT_ONE   = 1314
	PEND_LOAD_UNAVAIL     = 1315
	PEND_HOST_NO_LIM      = 1316
	PEND_HOST_QUE_RESREQ  = 1318
	PEND_HOST_SCHED_TYPE  = 1319
	PEND_JOB_NO_SPAN      = 1320
	PEND_QUE_NO_SPAN      = 1321
	PEND_HOST_EXCLUSIVE   =1322
	PEND_UGRP_PROC_JLIMIT = 1324
	PEND_BAD_HOST         = 1325
	PEND_QUEUE_HOST       = 1326
	PEND_HOST_LOCKED_MASTER= 1327
	PEND_SBD_UNREACH     =  1601
	PEND_SBD_JOB_QUOTA  =   1602
	PEND_JOB_START_FAIL =   1603
	PEND_JOB_START_UNKNWN=  1604
	PEND_SBD_NO_MEM     =   1605
	PEND_SBD_NO_PROCESS =   1606
	PEND_SBD_SOCKETPAIR =   1607
	PEND_SBD_JOB_ACCEPT =   1608
	PEND_HOST_LOAD      =   2001
	PEND_HOST_QUE_RUSAGE=  2301
	PEND_HOST_JOB_RUSAGE= 2601
	PEND_MAX_REASONS = 2900




	JOB_STAT_NULL = 0x00
	JOB_STAT_PEND = 0x01
	JOB_STAT_PSUSP = 0x02
	JOB_STAT_RUN = 0x04
	JOB_STAT_SSUSP = 0x08
	JOB_STAT_USUSP = 0x10
	JOB_STAT_EXIT = 0x20
	JOB_STAT_DONE = 0x40
	JOB_STAT_PDONE = (0x80)
	JOB_STAT_PERR = (0x100)
	JOB_STAT_WAIT = (0x200)
	JOB_STAT_UNKWN = 0x10000
	SUSP_USER_REASON = 0x00000000
	SUSP_USER_RESUME = 0x00000001
	SUSP_USER_STOP = 0x00000002
	SUSP_QUEUE_REASON = 0x00000004
	SUSP_QUEUE_WINDOW = 0x00000008
	SUSP_HOST_LOCK = 0x00000020
	SUSP_LOAD_REASON = 0x00000040
	SUSP_QUE_STOP_COND = 0x00000200
	SUSP_QUE_RESUME_COND = 0x00000400
	SUSP_PG_IT = 0x00000800
	SUSP_REASON_RESET = 0x00001000
	SUSP_LOAD_UNAVAIL = 0x00002000
	SUSP_ADMIN_STOP = 0x00004000
	SUSP_RES_RESERVE = 0x00008000
	SUSP_MBD_LOCK = 0x00010000
	SUSP_RES_LIMIT = 0x00020000
	SUSP_SBD_STARTUP = 0x00040000
	SUSP_HOST_LOCK_MASTER = 0x00080000

	SUB_JOB_NAME = 0x01
	SUB_QUEUE = 0x02
	SUB_HOST = 0x04
	SUB_IN_FILE = 0x08
	SUB_OUT_FILE = 0x10
	SUB_ERR_FILE = 0x20
	SUB_EXCLUSIVE = 0x40
	SUB_NOTIFY_END = 0x80
	SUB_NOTIFY_BEGIN = 0x100
	SUB_USER_GROUP = 0x200
	SUB_CHKPNT_PERIOD = 0x400
	SUB_CHKPNT_DIR = 0x800
	SUB_RESTART_FORCE = 0x1000
	SUB_RESTART = 0x2000
	SUB_RERUNNABLE = 0x4000
	SUB_WINDOW_SIG = 0x8000
	SUB_HOST_SPEC = 0x10000
	SUB_DEPEND_COND = 0x20000
	SUB_RES_REQ = 0x40000
	SUB_OTHER_FILES = 0x80000
	SUB_PRE_EXEC = 0x100000
	SUB_LOGIN_SHELL = 0x200000
	SUB_MAIL_USER = 0x400000
	SUB_MODIFY = 0x800000
	SUB_MODIFY_ONCE = 0x1000000
	SUB_PROJECT_NAME = 0x2000000
	SUB_INTERACTIVE = 0x4000000
	SUB_PTY = 0x8000000
	SUB_PTY_SHELL = 0x10000000
	SUB2_HOLD = 0x01
	SUB2_MODIFY_CMD = 0x02
	SUB2_BSUB_BLOCK = 0x04
	SUB2_HOST_NT = 0x08
	SUB2_HOST_UX = 0x10
	SUB2_QUEUE_CHKPNT = 0x20
	SUB2_QUEUE_RERUNNABLE = 0x40
	SUB2_IN_FILE_SPOOL = 0x80
	SUB2_JOB_CMD_SPOOL = 0x100
	SUB2_JOB_PRIORITY = 0x200
	SUB2_USE_DEF_PROCLIMIT = 0x400
	SUB2_MODIFY_RUN_JOB = 0x800
	SUB2_MODIFY_PEND_JOB = 0x1000

	EVENT_JOB_NEW = 1
	EVENT_JOB_START = 2
	EVENT_JOB_STATUS = 3
	EVENT_JOB_SWITCH = 4
	EVENT_JOB_MOVE = 5
	EVENT_QUEUE_CTRL = 6
	EVENT_HOST_CTRL = 7
	EVENT_MBD_DIE = 8
	EVENT_MBD_UNFULFILL = 9
	EVENT_JOB_FINISH = 10
	EVENT_LOAD_INDEX = 11
	EVENT_CHKPNT = 12
	EVENT_MIG = 13
	EVENT_PRE_EXEC_START = 14
	EVENT_MBD_START = 15
	EVENT_JOB_MODIFY = 16
	EVENT_JOB_SIGNAL = 17
	EVENT_JOB_EXECUTE = 18
	EVENT_JOB_MSG = 19
	EVENT_JOB_MSG_ACK = 20
	EVENT_JOB_REQUEUE = 21
	EVENT_JOB_SIGACT = 22
	EVENT_SBD_JOB_STATUS = 23
	EVENT_JOB_START_ACCEPT = 24
	EVENT_JOB_CLEAN = 25
	EVENT_JOB_FORCE = 26
	EVENT_LOG_SWITCH = 27
	EVENT_JOB_MODIFY2 = 28
	EVENT_JOB_ATTR_SET = 29
	EVENT_UNUSED_30 = 30
	EVENT_UNUSED_31 = 31
	EVENT_UNUSED_32 = 32

	LSB_KILL_REQUEUE=0x10

	@classmethod
	def lsb_init(cls, app_name):
		return openlava.lsb_init(app_name)

	@classmethod
	def ls_getclustername(cls):
		return openlava.ls_getclustername()

	@classmethod
	def ls_getmastername(cls):
		return openlava.ls_getmastername()

	@classmethod
	def lsb_openjobinfo(cls, job_id=0, job_name="", user="all", queue="", host="", options=0):
		cdef int numJobs
		numJobs=openlava.lsb_openjobinfo(job_id,job_name,user,queue,host,options)
		return numJobs

	@classmethod
	def lsb_readjobinfo(cls):
		cdef jobInfoEnt * j
		cdef int * more
		more=NULL
		j=openlava.lsb_readjobinfo(more)
		a=__jobInfoEnt()
		a._set_struct(j)
		return a

	@classmethod
	def lsb_closejobinfo(cls):
		openlava.lsb_closejobinfo()

	@classmethod
	def lsb_userinfo(cls, user_list=[]):
		assert(isinstance(user_list,list))
		cdef int num_users
		num_users=len(user_list)

		cdef char ** users
		users=NULL

		if num_users>0:
			users=to_cstring_array(user_list)

		cdef userInfoEnt *user_info
		cdef userInfoEnt *u

		user_info=openlava.lsb_userinfo(users,&num_users)

		usrs=[]
		for i in range(num_users):
			u=&user_info[i]
			user=__userInfoEnt()
			user._set_struct(u)
			usrs.append(user)
		return usrs

	@classmethod
	def lsb_queueinfo(cls, queue_list=[], numQueues=0, hosts="", users="", options=0):
		assert(isinstance(queue_list,list))
		cdef int num_queues
		num_queues=len(queue_list)

		cdef char ** queues
		queues=NULL
		if num_queues>0:
			queues=to_cstring_array(queue_list)
		if numQueues==1:
			num_queues=1

		cdef char * chosts
		cdef char * cusers
		chosts=NULL
		cusers=NULL
		if len(users)>0:
			cusers=users
		if len(hosts)>0:
			chosts=hosts

		cdef queueInfoEnt *queue_info
		cdef queueInfoEnt *q

		queue_info=openlava.lsb_queueinfo(queues, &num_queues, chosts, cusers, options)
		if num_queues<1:
			raise ValueError("No Queues")

		ql=[]
		for i in range (num_queues):
			q=&queue_info[i]
			queue=__queueInfoEnt()
			queue._set_struct(q)
			ql.append(queue)
		return ql

	@classmethod
	def lsb_hostinfo(cls, host_list=[], numHosts=0):
		assert(isinstance(host_list,list))
		cdef int num_hosts
		num_hosts=len(host_list)

		cdef char ** hosts
		hosts=NULL
		if num_hosts>0:
			hosts=to_cstring_array(host_list)
		if numHosts==1:
			num_hosts=1

		cdef hostInfoEnt *host_info
		cdef hostInfoEnt *h

		host_info=openlava.lsb_hostinfo(hosts, &num_hosts)

		hl=[]
		for i in range (num_hosts):
			h=&host_info[i]
			host=__hostInfoEnt()
			host._set_struct(h)
			hl.append(host)
		return hl

	@classmethod
	def lsb_geteventrec(cls, file_handle, line_num):
		cdef FILE * fh
		cdef int line
		cdef eventRec * record
		line=line_num
		fh=PyFile_AsFile(file_handle)
		record=openlava.lsb_geteventrec(fh, &line)
		if record==NULL:
			return (None, line_num)
		Record=__eventRec()
		Record._set_struct(record)
		line_num=line
		return (Record, line_num)

	@classmethod
	def lsb_deletejob(cls, job_id, submit_time, options=0):
		return openlava.lsb_deletejob(job_id, submit_time, options)

	@classmethod
	def lsb_signaljob (cls, jobId, sigValue):
		return openlava.lsb_signaljob(jobId, sigValue)

	@classmethod
	def lsb_requeuejob(cls, job_id, array_id, status, options):
		cdef jobrequeue rq
		job_id=OpenLava.create_job_id(job_id, array_id)
		if status!=OpenLavaCAPI.JOB_STAT_PEND and status!=OpenLavaCAPI.JOB_STAT_PSUSP:
			raise ValueError("Invalid Status")
		if options != OpenLavaCAPI.REQUEUE_DONE and options != OpenLavaCAPI.REQUEUE_EXIT and options != OpenLavaCAPI.REQUEUE_RUN:
			raise ValueError("Invalid Option")
		rq.jobId=job_id
		rq.status=status
		rq.options=options
		return openlava.lsb_requeuejob(&rq)


#cdef class JobRequeue:
#	cdef jobrequeue * _rq
#	property jobId:
#		def __get__(self):
#			return self._rq.jobId
#
#		def __set__(self, value):
#			self._rq.jobId=value
#
#
#	property status:
#		def __get__(self):
#			return self._rq.status
#
#		def __set__(self, value):
#			if value==OpenLavaCAPI.JOB_STAT_PEND or value==OpenLavaCAPI.JOB_STATE_PSUSP:
#				self._rq.status=value
#			else:
#				raise ValueError
#
#
#	property options:
#		def __get__(self):
#			return self._rq.options
#
#		def __set__(self, value):
#			if value == OpenLavaCAPI.REQUEUE_DONE or value==OpenLavaCAPI.REQUEUE_EXIT or value==OpenLavaCAPI.REQUEUE_RUN:
#				self._rq.options=value
#			else:
#				raise ValueError
#
#	cdef jobrequeue * get_struct(self):
#		return self._rq


cdef class __eventRec:
	cdef eventRec * _data

	cdef _set_struct(self, eventRec * data ):
		self._data=data

	property version:
		def __get__(self):
			return u'%s' % self._data.version

	property type:
		def __get__(self):
			return self._data.type

	property eventTime:
		def __get__(self):
			return self._data.eventTime

	property eventLog:
		def __get__(self):
			log=__eventLog()
			log._set_struct(&self._data.eventLog)
			return log

class EventLog:
	def __init__(self, file_name=None,file_handle=None):
		if file_name:
			self._fh=open(file_name)
		elif file_handle:
			self._fh=file_handle
		self._row_num=0

	def __iter__(self):
		return self

	def next(self):
		while(True):
			# iterate until we run out, or we get a row we can do something with
			(self._event, self._row_num)=OpenLavaCAPI.lsb_geteventrec(self._fh, self._row_num)
			if OpenLavaCAPI.get_lsberrno()==OpenLavaCAPI.LSBE_EOF:
				raise StopIteration
			if self._event:
				if self.event_type==OpenLavaCAPI.EVENT_JOB_NEW:
					self._log=JobNewLog(self._event.eventLog.jobNewLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_FINISH:
					self._log=JobFinishLog(self._event.eventLog.jobFinishLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_START:
					self._log=JobStartLog(self._event.eventLog.jobStartLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_EXECUTE:
					self._log=JobExecuteLog(self._event.eventLog.jobExecuteLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_START_ACCEPT:
					self._log=JobStartAcceptLog(self._event.eventLog.jobStartAcceptLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_CLEAN:
					self._log=JobCleanLog(self._event.eventLog.jobCleanLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_STATUS:
					self._log=JobStatusLog(self._event.eventLog.jobStatusLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_LOAD_INDEX:
					self._log=LoadIndexLog(self._event.eventLog.loadIndexLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_LOG_SWITCH:
					self._log=LogSwitchLog(self._event.eventLog.logSwitchLog)
					break
				elif self.event_type==OpenLavaCAPI.EVENT_JOB_SIGNAL:
					self._log=SignalLog(self._event.eventLog.signalLog)
					break
				else:
					print "Unable to do anything with log type: %s" % self.event_type
		return self

	def to_dict(self):
		items={}
		items['time']=self.time
		items['event_type']=self.event_type
		items['version']=self.version
		items.update(self.log.to_dict())
		return items

	@property
	def	log(self):
		return self._log

	@property
	def version(self):
		return self._event.version

	@property
	def event_type(self):
		return self._event.type

	@property
	def time(self):
		return self._event.eventTime

		


cdef class __jobNewLog:
	cdef jobNewLog * _data
	
	cdef _set_struct(self, jobNewLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property userId:
		def __get__(self):
			return self._data.userId

	property userName:
		def __get__(self):
			return u'%s' % self._data.userName

	property options:
		def __get__(self):
			return self._data.options

	property options2:
		def __get__(self):
			return self._data.options2

	property numProcessors:
		def __get__(self):
			return self._data.numProcessors

	property submitTime:
		def __get__(self):
			return self._data.submitTime

	property beginTime:
		def __get__(self):
			return self._data.beginTime

	property termTime:
		def __get__(self):
			return self._data.termTime

	property sigValue:
		def __get__(self):
			return self._data.sigValue

	property chkpntPeriod:
		def __get__(self):
			return self._data.chkpntPeriod

	property restartPid:
		def __get__(self):
			return self._data.restartPid

	property rLimits:
		def __get__(self):
			return [ self._data.rLimits[i] for i in range(11) ]

	property hostSpec:
		def __get__(self):
			return u'%s' % self._data.hostSpec

	property hostFactor:
		def __get__(self):
			return self._data.hostFactor

	property umask:
		def __get__(self):
			return self._data.umask

	property queue:
		def __get__(self):
			return "%s" % self._data.queue

	property resReq:
		def __get__(self):
			return u'%s' % self._data.resReq

	property fromHost:
		def __get__(self):
			return u"%s" % self._data.fromHost

	property cwd:
		def __get__(self):
			return u"%s" % self._data.cwd

	property chkpntDir:
		def __get__(self):
			return u"%s" % self._data.chkpntDir

	property inFile:
		def __get__(self):
			return u"%s" % self._data.inFile

	property outFile:
		def __get__(self):
			return u"%s" % self._data.outFile

	property errFile:
		def __get__(self):
			return u"%s" % self._data.errFile

	property inFileSpool:
		def __get__(self):
			return u"%s" % self._data.inFileSpool

	property commandSpool:
		def __get__(self):
			return u"%s" % self._data.commandSpool

	property jobSpoolDir:
		def __get__(self):
			return u"%s" % self._data.jobSpoolDir

	property subHomeDir:
		def __get__(self):
			return u"%s" % self._data.subHomeDir

	property jobFile:
		def __get__(self):
			return u"%s" % self._data.jobFile

	property numAskedHosts:
		def __get__(self):
			return self._data.numAskedHosts

	property askedHosts:
		def __get__(self):
			return [u'%s' % self._data.askedHosts[i] for i in range(self.numAskedHosts)]

	property dependCond:
		def __get__(self):
			return u'%s' % self._data.dependCond

	property jobName:
		def __get__(self):
			return u"%s" % self._data.jobName

	property command:
		def __get__(self):
			return u"%s" % self._data.command

	property nxf:
		def __get__(self):
			return self._data.nxf

	property xf:
		def __get__(self):
			xfs=[]
			for i in range(self.nxf):
				x=__xFile()
				x._set_struct(&self._data.xf[i])
				xfs.append(x)
			return xfs

	property preExecCmd:
		def __get__(self):
			return u'%s' % self._data.preExecCmd

	property mailUser:
		def __get__(self):
			return u'%s' % self._data.mailUser

	property projectName:
		def __get__(self):
			return u'%s' % self._data.projectName

	property niosPort:
		def __get__(self):
			return self._data.niosPort

	property maxNumProcessors:
		def __get__(self):
			return self._data.maxNumProcessors

	property schedHostType:
		def __get__(self):
			return u'%s' % self._data.schedHostType

	property loginShell:
		def __get__(self):
			return u'%s' % self._data.loginShell

	property idx:
		def __get__(self):
			return self._data.idx

	property userPriority:
		def __get__(self):
			return self._data.userPriority


class JobNewLog:
	def __init__(self, data):
		if isinstance(data, __jobNewLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def user_id(self):
		return self._data.userId

	@property
	def user_name(self):
		return self._data.userName

	@property
	def options(self):
		opt=[]
		opt.extend(SubmitOption.get_status_list(self._data.options))
		opt.extend(Submit2Option.get_status_list(self._data.options2))
		return opt

	@property
	def num_processors(self):
		return self._data.numProcessors

	@property
	def submit_time(self):
		return self._data.submitTime

	@property
	def begin_time(self):
		return self._data.beginTime

	@property
	def termination_time(self):
		return self._data.termTime

	@property
	def signal_value(self):
		return self._data.sigValue

	@property
	def checkpoint_period(self):
		return self._data.chkpntPeriod

	@property
	def restart_pid(self):
		return self._data.restartPid

	@property
	def resource_limits(self):
		return RLimit(*self._data.rLimits)

	@property
	def host_specification(self):
		return self._data.hostSpec

	@property
	def host_factor(self):
		return self._data.hostFactor

	@property
	def umask(self):
		return self._data.umask

	@property
	def queue(self):
		return self._data.queue

	@property
	def resource_request(self):
		return self._data.resReq

	@property
	def submit_host(self):
		return self._data.fromHost

	@property
	def cwd(self):
		return self._data.cwd

	@property
	def checkpoint_dir(self):
		return self._data.chkpntDir

	@property
	def input_file(self):
		return self._data.inFile

	@property
	def output_file(self):
		return self._data.outFile

	@property
	def error_file(self):
		return self._data.errFile

	@property
	def input_file_spool(self):
		return self._data.inFileSpool

	@property
	def command_spool(self):
		return self._data.commandSpool

	@property
	def job_spool_dir(self):
		return self._data.jobSpoolDir

	@property
	def submit_home_dir(self):
		return self._data.subHomeDir

	@property
	def job_file(self):
		return self._data.jobFile

	@property
	def num_asked_hosts(self):
		return self._data.numAskedHosts

	@property
	def asked_hosts(self):
		return self._data.askedHosts

	@property
	def dependency_condition(self):
		return self._data.dependCond

	@property
	def job_name(self):
		return self._data.jobName

	@property
	def command(self):
		return self._data.command

	@property
	def num_transfer_files(self):
		return self._data.nxf

	@property
	def transfer_files(self):
		return self._data.xf

	@property
	def pre_execution_cmd(self):
		return self._data.preExecCmd

	@property
	def email_user(self):
		return self._data.mailUser

	@property
	def project_name(self):
		return self._data.projectName

	@property
	def nios_port(self):
		return self._data.niosPort

	@property
	def max_num_processors(self):
		return self._data.maxNumProcessors

	@property
	def schedule_host_type(self):
		return self._data.schedHostType

	@property
	def login_shell(self):
		return self._data.loginShell

	@property
	def array_index(self):
		return self._data.idx

	@property
	def user_priority(self):
		return self._data.userPriority

	def to_dict(self):
		keys={}
		for attr in ["job_id","user_id","user_name","options","num_processors","submit_time","begin_time","termination_time","signal_value","checkpoint_period","restart_pid","resource_limits","host_specification","host_factor","umask","queue","resource_request","submit_host","cwd","checkpoint_dir","input_file","output_file","error_file","input_file_spool","command_spool","job_spool_dir","submit_home_dir","job_file","num_asked_hosts","asked_hosts","dependency_condition","job_name","command","num_transfer_files","transfer_files","pre_execution_cmd","email_user","project_name","nios_port","max_num_processors","schedule_host_type","login_shell","array_index","user_priority"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobStartLog:
	cdef jobStartLog * _data

	cdef _set_struct(self, jobStartLog * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property jStatus:
		def __get__(self):
			return self._data.jStatus

	property jobPid:
		def __get__(self):
			return self._data.jobPid

	property jobPGid:
		def __get__(self):
			return self._data.jobPGid

	property hostFactor:
		def __get__(self):
			return self._data.hostFactor

	property numExHosts:
		def __get__(self):
			return self._data.numExHosts

	property execHosts:
		def __get__(self):
			return [u'%s' % self._data.execHosts[i] for i in range(self.numExHosts)]

	property queuePreCmd:
		def __get__(self):
			return u'%s' % self._data.queuePreCmd

	property queuePostCmd:
		def __get__(self):
			return u'%s' % self._data.queuePostCmd

	property jFlags:
		def __get__(self):
			return self._data.jFlags

	property idx:
		def __get__(self):
			return self._data.idx

class JobStartLog:
	def __init__(self, data):
		if isinstance(data, __jobStartLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def job_status(self):
		return JobStatus(self._data.jStatus)

	@property
	def job_pid(self):
		return self._data.jobPid

	@property
	def job_process_group_id(self):
		return self._data.jobPGid

	@property
	def host_factor(self):
		return self._data.hostFactor

	@property
	def num_execution_hosts(self):
		return self._data.numExHosts

	@property
	def execution_hosts(self):
		return self._data.execHosts

	@property
	def queue_pre_execution_cmd(self):
		return self._data.queuePreCmd

	@property
	def queue_post_execution_cmd(self):
		return self._data.queuePostCmd

	@property
	def job_flags(self):
		return JobFlag.get_status_list( self._data.jFlags )

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","job_status","job_pid","job_process_group_id","host_factor","num_execution_hosts","execution_hosts","queue_pre_execution_cmd","queue_post_execution_cmd","job_flags","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys

cdef class __jobStatusLog:
	cdef jobStatusLog * _data

	cdef _set_struct(self, jobStatusLog * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property jStatus:
		def __get__(self):
			return self._data.jStatus

	property reason:
		def __get__(self):
			return self._data.reason

	property subreasons:
		def __get__(self):
			return self._data.subreasons

	property cpuTime:
		def __get__(self):
			return self._data.cpuTime

	property endTime:
		def __get__(self):
			return self._data.endTime

	property ru:
		def __get__(self):
			return self._data.ru

	property lsfRusage:
		def __get__(self):
			ru=__lsfRusage()
			ru._set_struct(&self._data.lsfRusage)
			return ru

	property jFlags:
		def __get__(self):
			return self._data.jFlags

	property exitStatus:
		def __get__(self):
			return self._data.exitStatus

	property idx:
		def __get__(self):
			return self._data.idx

class JobFlag(NumericState):
	states={
			0x02:{
				'name':"JFLAG_LASTRUN_SUCC",
				'description':'',
			},
			0x004:{
				'name':'JFLAG_DEPCOND_INVALID',
				'description':'',
				},
			0x008:{
				'name':'JFLAG_READY',
				'description':'',
				},
			0x200:{
				'name':'FLAG_EXACT',
				'description':'',
				},
			0x400:{
				'name':'JFLAG_UPTO',
				'description':'',
				},
			0x8000:{
				'name':'JFLAG_DEPCOND_REJECT',
				'description':'',
				},
			0x10000:{
				'name':'JFLAG_SEND_SIG',
				'description':'',
				},
			0x20000:{
				'name':'JFLAG_BTOP',
				'description':'',
				},
			0x40000:{
				'name':'JFLAG_ADM_BTOP',
				'description':'',
				},
			0x100000:{
				'name':'JFLAG_READY1',
				'description':'',
				},
			0x200000:{
				'name':'JFLAG_READY2',
				'description':'',
				},
			0x400000:{
				'name':'JFLAG_URGENT',
				'description':'',
				},
			0x800000:{
				'name':'JFLAG_URGENT_NOSTOP',
				'description':'',
				},
			0x1000000:{
				'name':'JFLAG_REQUEUE',
				'description':'',
				},
			0x2000000:{
				'name':'JFLAG_HAS_BEEN_REQUEUED',
				'description':'',
				},
			}
class JobStatusLog:
	def __init__(self, data):
		if isinstance(data, __jobStatusLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def job_status(self):
		return JobStatus( self._data.jStatus )

	@property
	def reasons(self):
		if self.job_status.name=="JOB_STAT_PEND":
			return PendReason.get_status_list(self._data.reason)
		if self.job_status.name=="JOB_STAT_SUSP":
			return SuspReason.get_status_list(self._data.reason)

	@property
	def sub_reasons(self):
		return self._data.subreasons

	@property
	def cpu_time(self):
		return self._data.cpuTime

	@property
	def end_time(self):
		return self._data.endTime

	@property
	def resource_usage_available(self):
		return self._data.ru

	@property
	def resource_usage(self):
		if self.resource_usage_available:
			return LsfRusage(self._data.lsfRusage)
		else:
			return None

	@property
	def job_flags(self):
		return JobFlag.get_status_list(self._data.jFlags)

	@property
	def exit_status(self):
		return self._data.exitStatus

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","job_status","reasons","sub_reasons","cpu_time","end_time","resource_usage_available","resource_usage","job_flags","exit_status","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __lsfRusage:
	cdef lsfRusage * _data

	cdef _set_struct(self, lsfRusage * data ):
		self._data=data

	property ru_utime:
		def __get__(self):
			return self._data.ru_utime

	property ru_stime:
		def __get__(self):
			return self._data.ru_stime

	property ru_maxrss:
		def __get__(self):
			return self._data.ru_maxrss

	property ru_ixrss:
		def __get__(self):
			return self._data.ru_ixrss

	property ru_ismrss:
		def __get__(self):
			return self._data.ru_ismrss

	property ru_idrss:
		def __get__(self):
			return self._data.ru_idrss

	property ru_isrss:
		def __get__(self):
			return self._data.ru_isrss

	property ru_minflt:
		def __get__(self):
			return self._data.ru_minflt

	property ru_majflt:
		def __get__(self):
			return self._data.ru_majflt

	property ru_nswap:
		def __get__(self):
			return self._data.ru_nswap

	property ru_inblock:
		def __get__(self):
			return self._data.ru_inblock

	property ru_oublock:
		def __get__(self):
			return self._data.ru_oublock

	property ru_ioch:
		def __get__(self):
			return self._data.ru_ioch

	property ru_msgsnd:
		def __get__(self):
			return self._data.ru_msgsnd

	property ru_msgrcv:
		def __get__(self):
			return self._data.ru_msgrcv

	property ru_nsignals:
		def __get__(self):
			return self._data.ru_nsignals

	property ru_nvcsw:
		def __get__(self):
			return self._data.ru_nvcsw

	property ru_nivcsw:
		def __get__(self):
			return self._data.ru_nivcsw

	property ru_exutime:
		def __get__(self):
			return self._data.ru_exutime


class LsfRusage:
	def __init__(self, data):
		if isinstance(data, __lsfRusage):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_time(self):
		return self._data.ru_utime

	@property
	def system_time(self):
		return self._data.ru_stime

	@property
	def max_rss(self):
		return self._data.ru_maxrss

	@property
	def integral_shared_text(self):
		return self._data.ru_ixrss

	@property
	def integral_shared_memory(self):
		return self._data.ru_ismrss

	@property
	def integral_unshared_data(self):
		return self._data.ru_idrss

	@property
	def integral_unshared_stack(self):
		return self._data.ru_isrss

	@property
	def page_reclaims(self):
		return self._data.ru_minflt

	@property
	def page_faults(self):
		return self._data.ru_majflt

	@property
	def swaps(self):
		return self._data.ru_nswap

	@property
	def input_block_ops(self):
		return self._data.ru_inblock

	@property
	def output_block_ops(self):
		return self._data.ru_oublock

	@property
	def charecter_io_ops(self):
		return self._data.ru_ioch

	@property
	def messages_sent(self):
		return self._data.ru_msgsnd

	@property
	def messages_received(self):
		return self._data.ru_msgrcv

	@property
	def num_signals(self):
		return self._data.ru_nsignals

	@property
	def voluntary_context_switches(self):
		return self._data.ru_nvcsw

	@property
	def involuntary_context_switches(self):
		return self._data.ru_nivcsw

	@property
	def exact_user_time(self):
		return self._data.ru_exutime

	def to_dict(self):
		keys={}
		for attr in ["user_time","system_time","max_rss","integral_shared_text","integral_shared_memory","integral_unshared_data","integral_unshared_stack","page_reclaims","page_faults","swaps","input_block_ops","output_block_ops","charecter_io_ops","messages_sent","messages_received","num_signals","voluntary_context_switches","involuntary_context_switches","exact_user_time"]:
			keys[attr]=getattr(self,attr)
		return keys
	


cdef class __sbdJobStatusLog:
	cdef sbdJobStatusLog * _data

	cdef _set_struct(self, sbdJobStatusLog * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property jStatus:
		def __get__(self):
			return self._data.jStatus

	property reasons:
		def __get__(self):
			return self._data.reasons

	property subreasons:
		def __get__(self):
			return self._data.subreasons

	property actPid:
		def __get__(self):
			return self._data.actPid

	property actValue:
		def __get__(self):
			return self._data.actValue

	property actPeriod:
		def __get__(self):
			return self._data.actPeriod

	property actFlags:
		def __get__(self):
			return self._data.actFlags

	property actStatus:
		def __get__(self):
			return self._data.actStatus

	property actReasons:
		def __get__(self):
			return self._data.actReasons

	property actSubReasons:
		def __get__(self):
			return self._data.actSubReasons

	property idx:
		def __get__(self):
			return self._data.idx

class SbdJobStatusLog:
	def __init__(self, data):
		if isinstance(data, __sbdJobStatusLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def job_status(self):
		return JobStatus(self._data.jStatus)

	@property
	def reasons(self):
		return self._data.reasons

	@property
	def subreasons(self):
		return self._data.subreasons

	@property
	def action_pid(self):
		return self._data.actPid

	@property
	def action_value(self):
		return self._data.actValue

	@property
	def action_period(self):
		return self._data.actPeriod

	@property
	def action_flags(self):
		return self._data.actFlags

	@property
	def action_status(self):
		return self._data.actStatus

	@property
	def action_reasons(self):
		return self._data.actReasons

	@property
	def action_sub_reasons(self):
		return self._data.actSubReasons

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","job_status","reasons","subreasons","action_pid","action_value","action_period","action_flags","action_status","action_reasons","action_sub_reasons","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __jobMoveLog:
	cdef jobMoveLog * _data

	cdef _set_struct(self, jobMoveLog * data ):
		self._data=data

	property userId:
		def __get__(self):
			return self._data.userId

	property jobId:
		def __get__(self):
			return self._data.jobId

	property position:
		def __get__(self):
			return self._data.position

	property base:
		def __get__(self):
			return self._data.base

	property idx:
		def __get__(self):
			return self._data.idx

	property userName:
		def __get__(self):
			return "%s" % self._data.userName


class JobMoveLog:
	def __init__(self, data):
		if isinstance(data, __jobMoveLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.userId

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def position(self):
		return self._data.position

	@property
	def base(self):
		return self._data.base

	@property
	def array_index(self):
		return self._data.idx

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["user_id","job_id","position","base","array_index","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __queueCtrlLog:
	cdef queueCtrlLog * _data

	cdef _set_struct(self, queueCtrlLog * data ):
		self._data=data


	property opCode:
		def __get__(self):
			return self._data.opCode

	property queue:
		def __get__(self):
			return u"%s" % self._data.queue

	property userId:
		def __get__(self):
			return self._data.userId

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName


class QueueCtrlLog:
	def __init__(self, data):
		if isinstance(data, __queueCtrlLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def op_code(self):
		return self._data.opCode

	@property
	def queue(self):
		return self._data.queue

	@property
	def user_id(self):
		return self._data.userId

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["op_code","queue","user_id","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __newDebugLog:
	cdef newDebugLog * _data

	cdef _set_struct(self, newDebugLog * data ):
		self._data=data

	property opCode:
		def __get__(self):
			return self._data.opCode

	property level:
		def __get__(self):
			return self._data.level

	property logclass:
		def __get__(self):
			return self._data.logclass

	property turnOff:
		def __get__(self):
			return self._data.turnOff

	property logFileName:
		def __get__(self):
			return u"%s" % self._data.logFileName

	property userId:
		def __get__(self):
			return self._data.userId

class NewDebugLog:
	def __init__(self, data):
		if isinstance(data, __newDebugLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def op_code(self):
		return self._data.opCode

	@property
	def level(self):
		return self._data.level

	@property
	def logclass(self):
		return self._data.logclass

	@property
	def turn_off(self):
		return self._data.turnOff

	@property
	def log_file_name(self):
		return self._data.logFileName

	@property
	def user_id(self):
		return self._data.userId

	def to_dict(self):
		keys={}
		for attr in ["op_code","level","logclass","turn_off","log_file_name","user_id"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __hostCtrlLog:
	cdef hostCtrlLog * _data

	cdef _set_struct(self, hostCtrlLog * data ):
		self._data=data

	property opCode:
		def __get__(self):
			return self._data.opCode

	property host:
		def __get__(self):
			return u"%s" %  self._data.host

	property userId:
		def __get__(self):
			return self._data.userId

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName

class HostCtrlLog:
	def __init__(self, data):
		if isinstance(data, __hostCtrlLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def op_code(self):
		return self._data.opCode

	@property
	def host(self):
		return self._data.host

	@property
	def user_id(self):
		return self._data.userId

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["op_code","host","user_id","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __mbdStartLog:
	cdef mbdStartLog * _data

	cdef _set_struct(self, mbdStartLog * data ):
		self._data=data

	property master:
		def __get__(self):
			return u"%s" % self._data.master

	property cluster:
		def __get__(self):
			return u"%s" % self._data.cluster

	property numHosts:
		def __get__(self):
			return self._data.numHosts

	property numQueues:
		def __get__(self):
			return self._data.numQueues

class MbdStartLog:
	def __init__(self, data):
		if isinstance(data, __mbdStartLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def master(self):
		return self._data.master

	@property
	def cluster(self):
		return self._data.cluster

	@property
	def num_hosts(self):
		return self._data.numHosts

	@property
	def num_queues(self):
		return self._data.numQueues

	def to_dict(self):
		keys={}
		for attr in ["master","cluster","num_hosts","num_queues"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __mbdDieLog:
	cdef mbdDieLog * _data
	cdef _set_struct(self, mbdDieLog * data ):
		self._data=data

	property master:
		def __get__(self):
			return u"%s" %  self._data.master

	property numRemoveJobs:
		def __get__(self):
			return self._data.numRemoveJobs

	property exitCode:
		def __get__(self):
			return self._data.exitCode

class MbdDieLog:
	def __init__(self, data):
		if isinstance(data, __mbdDieLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def master(self):
		return self._data.master

	@property
	def num_remove_jobs(self):
		return self._data.numRemoveJobs

	@property
	def exit_code(self):
		return self._data.exitCode

	def to_dict(self):
		keys={}
		for attr in ["master","num_remove_jobs","exit_code"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __unfulfillLog:
	cdef unfulfillLog * _data

	cdef _set_struct(self, unfulfillLog * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property notSwitched:
		def __get__(self):
			return self._data.notSwitched

	property sig:
		def __get__(self):
			return self._data.sig

	property sig1:
		def __get__(self):
			return self._data.sig1

	property sig1Flags:
		def __get__(self):
			return self._data.sig1Flags

	property chkPeriod:
		def __get__(self):
			return self._data.chkPeriod

	property notModified:
		def __get__(self):
			return self._data.notModified

	property idx:
		def __get__(self):
			return self._data.idx


class UnfulfillLog:
	def __init__(self, data):
		if isinstance(data, __unfulfillLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def not_switched(self):
		return self._data.notSwitched

	@property
	def signale(self):
		return self._data.sig

	@property
	def signal1(self):
		return self._data.sig1

	@property
	def signal1_flags(self):
		return self._data.sig1Flags

	@property
	def checkpoint_period(self):
		return self._data.chkPeriod

	@property
	def not_modified(self):
		return self._data.notModified

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","not_switched","signale","signal1","signal1_flags","checkpoint_period","not_modified","array_dx"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __jobFinishLog:
	cdef jobFinishLog * _data
	
	cdef _set_struct(self, jobFinishLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property userId:
		def __get__(self):
			return self._data.userId

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName

	property options:
		def __get__(self):
			return self._data.options

	property numProcessors:
		def __get__(self):
			return self._data.numProcessors

	property jStatus:
		def __get__(self):
			return self._data.jStatus

	property submitTime:
		def __get__(self):
			return self._data.submitTime

	property beginTime:
		def __get__(self):
			return self._data.beginTime

	property termTime:
		def __get__(self):
			return self._data.termTime

	property startTime:
		def __get__(self):
			return self._data.startTime

	property endTime:
		def __get__(self):
			return self._data.endTime

	property queue:
		def __get__(self):
			return u"%s" % self._data.queue

	property resReq:
		def __get__(self):
			return u'%s' % self._data.resReq

	property fromHost:
		def __get__(self):
			return u"%s" % self._data.fromHost

	property cwd:
		def __get__(self):
			return u"%s" % self._data.cwd

	property inFile:
		def __get__(self):
			return u"%s" % self._data.inFile

	property outFile:
		def __get__(self):
			return u"%s" % self._data.outFile

	property errFile:
		def __get__(self):
			return u"%s" % self._data.errFile

	property inFileSpool:
		def __get__(self):
			return u"%s" % self._data.inFileSpool

	property commandSpool:
		def __get__(self):
			return u"%s" % self._data.commandSpool

	property jobFile:
		def __get__(self):
			return u"%s" % self._data.jobFile

	property numAskedHosts:
		def __get__(self):
			return self._data.numAskedHosts

	property askedHosts:
		def __get__(self):
			return [u'%s' % self._data.askedHosts[i] for i in range(self.numAskedHosts)]

	property hostFactor:
		def __get__(self):
			return self._data.hostFactor

	property numExHosts:
		def __get__(self):
			return self._data.numExHosts

	property execHosts:
		def __get__(self):
			return [u'%s' % self._data.execHosts[i] for i in range(self.numExHosts)]

	property cpuTime:
		def __get__(self):
			return self._data.cpuTime

	property jobName:
		def __get__(self):
			return u"%s" % self._data.jobName

	property command:
		def __get__(self):
			return u"%s" % self._data.command

	property lsfRusage:
		def __get__(self):
			ru=__lsfRusage()
			ru._set_struct(&self._data.lsfRusage)
			return ru

	property dependCond:
		def __get__(self):
			return u'%s' % self._data.dependCond

	property preExecCmd:
		def __get__(self):
			return u'%s' % self._data.preExecCmd

	property mailUser:
		def __get__(self):
			return u'%s' % self._data.mailUser

	property projectName:
		def __get__(self):
			return u'%s' % self._data.projectName

	property exitStatus:
		def __get__(self):
			return self._data.exitStatus

	property maxNumProcessors:
		def __get__(self):
			return self._data.maxNumProcessors

	property loginShell:
		def __get__(self):
			return u'%s' % self._data.loginShell

	property idx:
		def __get__(self):
			return self._data.idx

	property maxRMem:
		def __get__(self):
			return self._data.maxRMem

	property maxRSwap:
		def __get__(self):
			return self._data.maxRSwap

class JobFinishLog:
	def __init__(self, data):
		if isinstance(data, __jobFinishLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def user_id(self):
		return self._data.userId

	@property
	def user_name(self):
		return self._data.userName

	@property
	def options(self):
		return SubmitOption.get_status_list( self._data.options )

	@property
	def num_processors(self):
		return self._data.numProcessors

	@property
	def job_status(self):
		return JobStatus(self._data.jStatus)

	@property
	def submit_time(self):
		return self._data.submitTime

	@property
	def begin_time(self):
		return self._data.beginTime

	@property
	def termination_time(self):
		return self._data.termTime

	@property
	def start_time(self):
		return self._data.startTime

	@property
	def end_time(self):
		return self._data.endTime

	@property
	def queue(self):
		return self._data.queue

	@property
	def resource_request(self):
		return self._data.resReq

	@property
	def submit_host(self):
		return self._data.fromHost

	@property
	def cwd(self):
		return self._data.cwd

	@property
	def input_file(self):
		return self._data.inFile

	@property
	def output_file(self):
		return self._data.outFile

	@property
	def error_file(self):
		return self._data.errFile

	@property
	def input_file_spool(self):
		return self._data.inFileSpool

	@property
	def command_spool(self):
		return self._data.commandSpool

	@property
	def job_file(self):
		return self._data.jobFile

	@property
	def num_asked_hosts(self):
		return self._data.numAskedHosts

	@property
	def asked_hosts(self):
		return self._data.askedHosts

	@property
	def host_factor(self):
		return self._data.hostFactor

	@property
	def num_execution_hosts(self):
		return self._data.numExHosts

	@property
	def execution_hosts(self):
		return self._data.execHosts

	@property
	def cpu_time(self):
		return self._data.cpuTime

	@property
	def job_name(self):
		return self._data.jobName

	@property
	def command(self):
		return self._data.command

	@property
	def resource_usage(self):
		return LsfRusage( self._data.lsfRusage )

	@property
	def dependency_condition(self):
		return self._data.dependCond

	@property
	def pre_execution_cmd(self):
		return self._data.preExecCmd

	@property
	def email_user(self):
		return self._data.mailUser

	@property
	def project_name(self):
		return self._data.projectName

	@property
	def exit_status(self):
		return self._data.exitStatus

	@property
	def max_num_processors(self):
		return self._data.maxNumProcessors

	@property
	def login_shell(self):
		return self._data.loginShell

	@property
	def array_index(self):
		return self._data.idx

	@property
	def max_residual_mem(self):
		return self._data.maxRMem

	@property
	def max_swap(self):
		return self._data.maxRSwap

	def to_dict(self):
		keys={}
		for attr in ["job_id","user_id","user_name","options","num_processors","job_status","submit_time","begin_time","termination_time","start_time","end_time","queue","resource_request","submit_host","cwd","input_file","output_file","error_file","input_file_spool","command_spool","job_file","num_asked_hosts","asked_hosts","host_factor","num_execution_hosts","execution_hosts","cpu_time","job_name","command","resource_usage","dependency_condition","pre_execution_cmd","email_user","project_name","exit_status","max_num_processors","login_shell","array_index","max_residual_mem","max_swap"]:

			keys[attr]=getattr(self,attr)
		return keys



cdef class __loadIndexLog:
	cdef loadIndexLog * _data
	cdef _set_struct(self, loadIndexLog * data ):
		self._data=data

	property nIdx:
		def __get__(self):
			return self._data.nIdx

	property name:
		def __get__(self):
			return [ u'%s' % self._data.name[i] for i in range(self.nIdx)]

class LoadIndexLog:
	def __init__(self, data):
		if isinstance(data, __loadIndexLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def num_load_indexes(self):
		return self._data.nIdx

	@property
	def name(self):
		return self._data.name

	def to_dict(self):
		keys={}
		for attr in ["num_load_indexes","name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __migLog:
	cdef migLog * _data

	cdef _set_struct(self, migLog * data ):
		self._data=data


	property jobId:
		def __get__(self):
			return self._data.jobId

	property numAskedHosts:
		def __get__(self):
			return self._data.numAskedHosts

	property askedHosts:
		def __get__(self):
			return [u'%s' % self._data.askedHosts[i] for i in range(self.numAskedHosts)]

	property userId:
		def __get__(self):
			return self._data.userId

	property idx:
		def __get__(self):
			return self._data.idx

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName

class MigLog:
	def __init__(self, data):
		if isinstance(data, __migLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def num_asked_hosts(self):
		return self._data.numAskedHosts

	@property
	def asked_hosts(self):
		return self._data.askedHosts

	@property
	def user_id(self):
		return self._data.userId

	@property
	def array_index(self):
		return self._data.idx

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["job_id","num_asked_hosts","asked_hosts","user_id","array_index","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __signalLog:
	cdef signalLog * _data
	
	cdef _set_struct(self, signalLog * data ):
		self._data=data
		

	property userId:
		def __get__(self):
			return self._data.userId

	property jobId:
		def __get__(self):
			return self._data.jobId

	property signalSymbol:
		def __get__(self):
			return u'%s' % self._data.signalSymbol

	property runCount:
		def __get__(self):
			return self._data.runCount

	property idx:
		def __get__(self):
			return self._data.idx

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName

class SignalLog:
	def __init__(self, data):
		if isinstance(data, __signalLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.userId

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def signal_symbol(self):
		return self._data.signalSymbol

	@property
	def run_count(self):
		return self._data.runCount

	@property
	def array_index(self):
		return self._data.idx

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["user_id","job_id","signal_symbol","run_count","array_index","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobExecuteLog:
	cdef jobExecuteLog * _data
	
	cdef _set_struct(self, jobExecuteLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property execUid:
		def __get__(self):
			return self._data.execUid

	property execHome:
		def __get__(self):
			return u'%s' % self._data.execHome

	property execCwd:
		def __get__(self):
			return u'%s' % self._data.execCwd

	property jobPGid:
		def __get__(self):
			return self._data.jobPGid

	property execUsername:
		def __get__(self):
			return u'%s' % self._data.execUsername

	property jobPid:
		def __get__(self):
			return self._data.jobPid

	property idx:
		def __get__(self):
			return self._data.idx

class JobExecuteLog:
	def __init__(self, data):
		if isinstance(data, __jobExecuteLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def execution_uid(self):
		return self._data.execUid

	@property
	def execution_home_dir(self):
		return self._data.execHome

	@property
	def execution_cwd(self):
		return self._data.execCwd

	@property
	def job_process_group_id(self):
		return self._data.jobPGid

	@property
	def execution_username(self):
		return self._data.execUsername

	@property
	def job_pid(self):
		return self._data.jobPid

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","execution_uid","execution_home_dir","execution_cwd","job_process_group_id","execution_username","job_pid","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobMsgLog:
	cdef jobMsgLog * _data
	
	cdef _set_struct(self, jobMsgLog * data ):
		self._data=data
		

	property usrId:
		def __get__(self):
			return self._data.usrId

	property jobId:
		def __get__(self):
			return self._data.jobId

	property msgId:
		def __get__(self):
			return self._data.msgId

	property type:
		def __get__(self):
			return self._data.type

	property src:
		def __get__(self):
			return u'%s' % self._data.src

	property dest:
		def __get__(self):
			return u'%s' % self._data.dest

	property msg:
		def __get__(self):
			return u'%s' % self._data.msg

	property idx:
		def __get__(self):
			return self._data.idx

class JobMsgLog:
	def __init__(self, data):
		if isinstance(data, __jobMsgLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.usrId

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def message_id(self):
		return self._data.msgId

	@property
	def type(self):
		return self._data.type

	@property
	def source(self):
		return self._data.src

	@property
	def destination(self):
		return self._data.dest

	@property
	def message(self):
		return self._data.msg

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["user_id","job_id","message_id","type","source","destination","message","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobMsgAckLog:
	cdef jobMsgAckLog * _data
	
	cdef _set_struct(self, jobMsgAckLog * data ):
		self._data=data
		

	property usrId:
		def __get__(self):
			return self._data.usrId

	property jobId:
		def __get__(self):
			return self._data.jobId

	property msgId:
		def __get__(self):
			return self._data.msgId

	property type:
		def __get__(self):
			return self._data.type

	property src:
		def __get__(self):
			return u'%s' % self._data.src

	property dest:
		def __get__(self):
			return u'%s' % self._data.dest

	property msg:
		def __get__(self):
			return u'%s' % self._data.msg

	property idx:
		def __get__(self):
			return self._data.idx

class JobMsgAckLog:
	def __init__(self, data):
		if isinstance(data, __jobMsgAckLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.usrId

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def message_id(self):
		return self._data.msgId

	@property
	def type(self):
		return self._data.type

	@property
	def source(self):
		return self._data.src

	@property
	def destination(self):
		return self._data.dest

	@property
	def emssage(self):
		return self._data.msg

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["user_id","job_id","message_id","type","source","destination","message","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobRequeueLog:
	cdef jobRequeueLog * _data

	cdef _set_struct(self, jobRequeueLog * data ):
		self._data=data


	property jobId:
		def __get__(self):
			return self._data.jobId

	property idx:
		def __get__(self):
			return self._data.idx

class JobRequeueLog:
	def __init__(self, data):
		if isinstance(data, __jobRequeueLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __chkpntLog:
	cdef chkpntLog * _data
	cdef _set_struct(self, chkpntLog * data ):
		self._data=data


	property jobId:
		def __get__(self):
			return self._data.jobId

	property period:
		def __get__(self):
			return self._data.period

	property pid:
		def __get__(self):
			return self._data.pid

	property ok:
		def __get__(self):
			return self._data.ok

	property flags:
		def __get__(self):
			return self._data.flags

	property idx:
		def __get__(self):
			return self._data.idx
class CheckPointFlag(NumericState):
	states={}
class ActionFlag(NumericState):
	states={}
class ActionStatus(NumericState):
	states={}

class ChkpntLog:
	def __init__(self, data):
		if isinstance(data, __chkpntLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def period(self):
		return self._data.period

	@property
	def process_id(self):
		return self._data.pid

	@property
	def ok(self):
		return self._data.ok

	@property
	def flags(self):
		return CheckPointFlag(self._data.flags)

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","period","process_id","ok","flags","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys




cdef class __sigactLog:
	cdef sigactLog * _data
	
	cdef _set_struct(self, sigactLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property period:
		def __get__(self):
			return self._data.period

	property pid:
		def __get__(self):
			return self._data.pid

	property jStatus:
		def __get__(self):
			return self._data.jStatus

	property reasons:
		def __get__(self):
			return self._data.reasons

	property flags:
		def __get__(self):
			return self._data.flags

	property signalSymbol:
		def __get__(self):
			return u'%s' % self._data.signalSymbol

	property actStatus:
		def __get__(self):
			return self._data.actStatus

	property idx:
		def __get__(self):
			return self._data.idx

class SigactLog:
	def __init__(self, data):
		if isinstance(data, __sigactLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def period(self):
		return self._data.period

	@property
	def process_id(self):
		return self._data.pid

	@property
	def j_status(self):
		return JobStatus(self._data.jStatus)

	@property
	def reasons(self):
		return PendReason.get_status_list(self._data.reasons)

	@property
	def action_flags(self):
		return ActionFlag.get_status_list(self._data.flags)

	@property
	def signal_symbol(self):
		return self._data.signalSymbol

	@property
	def action_status(self):
		return ActionStatus(self._data.actStatus)

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","period","process_id","job_status","pending_reasons","action_flags","action_symbol","action_status","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __jobStartAcceptLog:
	cdef jobStartAcceptLog * _data
	
	cdef _set_struct(self, jobStartAcceptLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property jobPid:
		def __get__(self):
			return self._data.jobPid

	property jobPGid:
		def __get__(self):
			return self._data.jobPGid

	property idx:
		def __get__(self):
			return self._data.idx

class JobStartAcceptLog:
	def __init__(self, data):
		if isinstance(data, __jobStartAcceptLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def job_pid(self):
		return self._data.jobPid

	@property
	def job_process_group_id(self):
		return self._data.jobPGid

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","job_pid","job_process_group_id","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys





cdef class __jobCleanLog:
	cdef jobCleanLog * _data
	
	cdef _set_struct(self, jobCleanLog * data ):
		self._data=data
		

	property jobId:
		def __get__(self):
			return self._data.jobId

	property idx:
		def __get__(self):
			return self._data.idx

class JobCleanLog:
	def __init__(self, data):
		if isinstance(data, __jobCleanLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def array_index(self):
		return self._data.idx

	def to_dict(self):
		keys={}
		for attr in ["job_id","array_index"]:
			keys[attr]=getattr(self,attr)
		return keys





cdef class __jobForceRequestLog:
	cdef jobForceRequestLog * _data
	cdef _set_struct(self, jobForceRequestLog * data ):
		self._data=data

	property userId:
		def __get__(self):
			return self._data.userId

	property numExecHosts:
		def __get__(self):
			return self._data.numExecHosts

	property execHosts:
		def __get__(self):
			return [u"%s" % self._data.execHosts[i] for i in range(self.numExecHosts)]

	property jobId:
		def __get__(self):
			return self._data.jobId

	property idx:
		def __get__(self):
			return self._data.idx

	property options:
		def __get__(self):
			return self._data.options

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName


class ForceRequestOption(NumericState):
	states={}

class JobForceRequestLog:
	def __init__(self, data):
		if isinstance(data, __jobForceRequestLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.userId

	@property
	def num_execution_hosts(self):
		return self._data.numExecHosts

	@property
	def execution_hosts(self):
		return self._data.execHosts

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def array_index(self):
		return self._data.idx

	@property
	def options(self):
		return ForceRequestOption(self._data.options)

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["user_id","num_execution_hosts","execution_hosts","job_id","array_index","options","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobSwitchLog:
	cdef jobSwitchLog * _data

	cdef _set_struct(self, jobSwitchLog * data ):
		self._data=data

	property userId:
		def __get__(self):
			return self._data.userId

	property jobId:
		def __get__(self):
			return self._data.jobId

	property queue:
		def __get__(self):
			return u"%s" % self._data.queue

	property idx:
		def __get__(self):
			return self._data.idx

	property userName:
		def __get__(self):
			return u"%s" % self._data.userName

class JobSwitchLog:
	def __init__(self, data):
		if isinstance(data, __jobSwitchLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def user_id(self):
		return self._data.userId

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def queue(self):
		return self._data.queue

	@property
	def idx(self):
		return self._data.idx

	@property
	def user_name(self):
		return self._data.userName

	def to_dict(self):
		keys={}
		for attr in ["user_id","job_id","queue","array_index","user_name"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobModLog:
	cdef jobModLog * _data
	
	cdef _set_struct(self, jobModLog * data ):
		self._data=data
		

	property jobIdStr:
		def __get__(self):
			return u'%s' % self._data.jobIdStr

	property options:
		def __get__(self):
			return self._data.options

	property options2:
		def __get__(self):
			return self._data.options2

	property delOptions:
		def __get__(self):
			return self._data.delOptions

	property delOptions2:
		def __get__(self):
			return self._data.delOptions2

	property userId:
		def __get__(self):
			return self._data.userId

	property userName:
		def __get__(self):
			return u'%s' % self._data.userName

	property submitTime:
		def __get__(self):
			return self._data.submitTime

	property umask:
		def __get__(self):
			return self._data.umask

	property numProcessors:
		def __get__(self):
			return self._data.numProcessors

	property beginTime:
		def __get__(self):
			return self._data.beginTime

	property termTime:
		def __get__(self):
			return self._data.termTime

	property sigValue:
		def __get__(self):
			return self._data.sigValue

	property restartPid:
		def __get__(self):
			return self._data.restartPid

	property jobName:
		def __get__(self):
			return u'%s' % self._data.jobName

	property queue:
		def __get__(self):
			return u'%s' % self._data.queue

	property numAskedHosts:
		def __get__(self):
			return self._data.numAskedHosts

	property askedHosts:
		def __get__(self):
			return [ u'%s' % self._data.askedHosts[i] for i in range(self.numAskedHosts)] 

	property resReq:
		def __get__(self):
			return u'%s' % self._data.resReq

	property rLimits:
		def __get__(self):
			return [ self._data.rLimits[i] for i in range(11)]

	property hostSpec:
		def __get__(self):
			return u'%s' % self._data.hostSpec

	property dependCond:
		def __get__(self):
			return u'%s' % self._data.dependCond

	property subHomeDir:
		def __get__(self):
			return u'%s' % self._data.subHomeDir

	property inFile:
		def __get__(self):
			return u'%s' % self._data.inFile

	property outFile:
		def __get__(self):
			return u'%s' % self._data.outFile

	property errFile:
		def __get__(self):
			return u'%s' % self._data.errFile

	property command:
		def __get__(self):
			return u'%s' % self._data.command

	property inFileSpool:
		def __get__(self):
			return u'%s' % self._data.inFileSpool

	property commandSpool:
		def __get__(self):
			return u'%s' % self._data.commandSpool

	property chkpntPeriod:
		def __get__(self):
			return self._data.chkpntPeriod

	property chkpntDir:
		def __get__(self):
			return u'%s' % self._data.chkpntDir

	property nxf:
		def __get__(self):
			return self._data.nxf

	property xf:
		def __get__(self):
			xfs=[]
			for i in range(self.nxf):
				x=__xFile()
				x._set_struct(&self._data.xf[i])
				xfs.append(x)
			return xfs

	property jobFile:
		def __get__(self):
			return u'%s' % self._data.jobFile

	property fromHost:
		def __get__(self):
			return u'%s' % self._data.fromHost

	property cwd:
		def __get__(self):
			return u'%s' % self._data.cwd

	property preExecCmd:
		def __get__(self):
			return u'%s' % self._data.preExecCmd

	property mailUser:
		def __get__(self):
			return u'%s' % self._data.mailUser

	property projectName:
		def __get__(self):
			return u'%s' % self._data.projectName

	property niosPort:
		def __get__(self):
			return self._data.niosPort

	property maxNumProcessors:
		def __get__(self):
			return self._data.maxNumProcessors

	property loginShell:
		def __get__(self):
			return u'%s' % self._data.loginShell

	property schedHostType:
		def __get__(self):
			return u'%s' % self._data.schedHostType

	property userPriority:
		def __get__(self):
			return self._data.userPriority

class JobModLog:
	def __init__(self, data):
		if isinstance(data, __jobModLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id_string(self):
		return self._data.jobIdStr

	@property
	def options(self):
		options=[]
		options.extend(SubmitOption.get_status_list(self._data.options))
		options.extend(Submit2Option.get_status_list(self._data.options2))
		return options

	@property
	def delete_options(self):
		options=[]
		options.extend(SubmitOption.get_status_list(self._data.del_options))
		options.extend(Submit2Option.get_status_list(self._data.del_options2))
		return options

	@property
	def user_id(self):
		return self._data.userId

	@property
	def user_name(self):
		return self._data.userName

	@property
	def submit_time(self):
		return self._data.submitTime

	@property
	def umask(self):
		return self._data.umask

	@property
	def num_processors(self):
		return self._data.numProcessors

	@property
	def begin_time(self):
		return self._data.beginTime

	@property
	def termination_time(self):
		return self._data.termTime

	@property
	def signal_value(self):
		return self._data.sigValue

	@property
	def restart_pid(self):
		return self._data.restartPid

	@property
	def job_name(self):
		return self._data.jobName

	@property
	def queue(self):
		return self._data.queue

	@property
	def num_asked_hosts(self):
		return self._data.numAskedHosts

	@property
	def asked_hosts(self):
		return self._data.askedHosts

	@property
	def resource_request(self):
		return self._data.resReq

	@property
	def resource_limits(self):
		return RLimit(*self._data.rLimits)

	@property
	def host_specification(self):
		return self._data.hostSpec

	@property
	def dependency_condition(self):
		return self._data.dependCond

	@property
	def submit_home_dir(self):
		return self._data.subHomeDir

	@property
	def input_file(self):
		return self._data.inFile

	@property
	def output_file(self):
		return self._data.outFile

	@property
	def error_file(self):
		return self._data.errFile

	@property
	def command(self):
		return self._data.command

	@property
	def input_file_spool(self):
		return self._data.inFileSpool

	@property
	def command_spool(self):
		return self._data.commandSpool

	@property
	def checkpoint_period(self):
		return self._data.chkpntPeriod

	@property
	def checkpoint_dir(self):
		return self._data.chkpntDir

	@property
	def num_transfer_files(self):
		return self._data.nxf

	@property
	def transfer_files(self):
		return [ TransferFile(i) for i in self._data.xf]

	@property
	def job_file(self):
		return self._data.jobFile

	@property
	def from_host(self):
		return self._data.fromHost

	@property
	def cwd(self):
		return self._data.cwd

	@property
	def pre_execution_cmd(self):
		return self._data.preExecCmd

	@property
	def email_user(self):
		return self._data.mailUser

	@property
	def project_name(self):
		return self._data.projectName

	@property
	def nios_port(self):
		return self._data.niosPort

	@property
	def max_num_processors(self):
		return self._data.maxNumProcessors

	@property
	def login_shell(self):
		return self._data.loginShell

	@property
	def schedule_host_type(self):
		return self._data.schedHostType

	@property
	def user_priority(self):
		return self._data.userPriority

	def to_dict(self):
		keys={}
		for attr in ["job_id_string","options","delete_options","user_id","user_name","submit_time","umask","num_processors","begin_time","term_time","sig_value","restart_pid","job_name","queue","num_asked_hosts","asked_hosts","resource_request","resource_limits","host_specification","dependency_condition","submit_home_dir","input_file","output_file","error_file","command","input_file_spool","command_spool","checkpoint_period","checkkpoint_dir","num_transfer_files","transfer_files","job_file","subit_host","cwd","pre_execution_cmd","email_user","project_name","nios_port","max_num_processors","login_shell","schedule_host_type","user_priority"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __jobAttrSetLog:
	cdef jobAttrSetLog * _data

	cdef _set_struct(self, jobAttrSetLog * data ):
		self._data=data

	property jobId:
		def __get__(self):
			return self._data.jobId

	property idx:
		def __get__(self):
			return self._data.idx

	property uid:
		def __get__(self):
			return self._data.uid

	property port:
		def __get__(self):
			return self._data.port

	property hostname:
		def __get__(self):
			return u'%s' % self._data.hostname

class JobAttrSetLog:
	def __init__(self, data):
		if isinstance(data, __jobAttrSetLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def job_id(self):
		return self._data.jobId

	@property
	def array_dx(self):
		return self._data.idx

	@property
	def user_id(self):
		return self._data.uid

	@property
	def port(self):
		return self._data.port

	@property
	def hostname(self):
		return self._data.hostname

	def to_dict(self):
		keys={}
		for attr in ["job_id","array_index","user_id","port","hostname"]:
			keys[attr]=getattr(self,attr)
		return keys



cdef class __logSwitchLog:
	cdef logSwitchLog * _data

	cdef _set_struct(self, logSwitchLog * data ):
		self._data=data

	property lastJobId:
		def __get__(self):
			return self._data.lastJobId

class LogSwitchLog:
	def __init__(self, data):
		if isinstance(data, __logSwitchLog):
			self._data=data
		else:
			raise ValueError("Incorrect class passed")

	@property
	def last_job_id(self):
		return self._data.lastJobId

	def to_dict(self):
		keys={}
		for attr in ["last_job_id"]:
			keys[attr]=getattr(self,attr)
		return keys


cdef class __eventLog:
	cdef eventLog * _data

	cdef _set_struct(self, eventLog * data ):
		self._data=data

	property jobNewLog:
		def __get__(self):
			log=__jobNewLog()
			log._set_struct(&self._data.jobNewLog)
			return log

	property jobStartLog:
		def __get__(self):
			log=__jobStartLog()
			log._set_struct(&self._data.jobStartLog)
			return log

	property jobStatusLog:
		def __get__(self):
			log=__jobStatusLog()
			log._set_struct(&self._data.jobStatusLog)
			return log

	property sbdJobStatusLog:
		def __get__(self):
			log=__sbdJobStatusLog()
			log._set_struct(&self._data.sbdJobStatusLog)
			return log

	property jobSwitchLog:
		def __get__(self):
			log=__jobSwitchLog()
			log._set_struct(&self._data.jobSwitchLog)
			return log

	property jobMoveLog:
		def __get__(self):
			log=__jobMoveLog()
			log._set_struct(&self._data.jobMoveLog)
			return log

	property queueCtrlLog:
		def __get__(self):
			log=__queueCtrlLog()
			log._set_struct( &self._data.queueCtrlLog)
			return log

	property newDebugLog:
		def __get__(self):
			log=__newDebugLog()
			log._set_struct(&self._data.newDebugLog)
			return log

	property hostCtrlLog:
		def __get__(self):
			log=__hostCtrlLog()
			log._set_struct(&self._data.hostCtrlLog)
			return log

	property mbdStartLog:
		def __get__(self):
			log=__mbdStartLog()
			log._set_struct(&self._data.mbdStartLog)
			return log

	property mbdDieLog:
		def __get__(self):
			log=__mbdDieLog()
			log._set_struct( &self._data.mbdDieLog)
			return log

	property unfulfillLog:
		def __get__(self):
			log=__unfulfillLog()
			log._set_struct(&self._data.unfulfillLog)
			return log

	property jobFinishLog:
		def __get__(self):
			log=__jobFinishLog()
			log._set_struct( &self._data.jobFinishLog)
			return log

	property loadIndexLog:
		def __get__(self):
			log=__loadIndexLog()
			log._set_struct(&self._data.loadIndexLog)
			return log

	property migLog:
		def __get__(self):
			log=__migLog()
			log._set_struct(&self._data.migLog)
			return log

	property signalLog:
		def __get__(self):
			log=__signalLog()
			log._set_struct(&self._data.signalLog)
			return log

	property jobExecuteLog:
		def __get__(self):
			log=__jobExecuteLog()
			log._set_struct(&self._data.jobExecuteLog)
			return log

	property jobMsgLog:
		def __get__(self):
			log=__jobMsgLog()
			log._set_struct(&self._data.jobMsgLog)
			return log

	property jobMsgAckLog:
		def __get__(self):
			log=__jobMsgAckLog()
			log._set_struct(&self._data.jobMsgAckLog)
			return log

	property jobRequeueLog:
		def __get__(self):
			log=__jobRequeueLog()
			log._set_struct(&self._data.jobRequeueLog)
			return log

	property chkpntLog:
		def __get__(self):
			log=__chkpntLog()
			log._set_struct(&self._data.chkpntLog)
			return log

	property sigactLog:
		def __get__(self):
			log=__sigactLog()
			log._set_struct(&self._data.sigactLog)
			return log

	property jobStartAcceptLog:
		def __get__(self):
			log=__jobStartAcceptLog()
			log._set_struct( &self._data.jobStartAcceptLog)
			return log

	property jobCleanLog:
		def __get__(self):
			log=__jobCleanLog()
			log._set_struct( &self._data.jobCleanLog)
			return log

	property jobForceRequestLog:
		def __get__(self):
			log=__jobForceRequestLog()
			log._set_struct(&self._data.jobForceRequestLog)
			return log

	property logSwitchLog:
		def __get__(self):
			log=__logSwitchLog()
			log._set_struct(&self._data.logSwitchLog)
			return log

	property jobModLog:
		def __get__(self):
			log=__jobModLog()
			log._set_struct(&self._data.jobModLog)
			return log

	property jobAttrSetLog:
		def __get__(self):
			log=__jobAttrSetLog()
			log._set_struct(&self._data.jobAttrSetLog)
			return log





class RLimit:
	def __init__(self, cpu,file_size,data,stack,core,rss,nofile,openmax,swap,run,process):
		self._cpu=cpu
		self._file_size=file_size
		self._data=data
		self._stack=stack
		self._core=core
		self._rss=rss
		self._nofile=nofile
		self._openmax=openmax
		self._swap=swap
		self._run=run
		self._process=process
	def to_dict(self):
		items={}
		for i in ['cpu','file_size','data','stack','core','rss','run','process','swap','nofile','open_files']:
			items[i]=getattr(self,i)
		return items
	@property
	def cpu(self):
		return self._cpu

	@property
	def file_size(self):
		return self._file_size

	@property
	def data(self):
		return self._data

	@property
	def stack(self):
		return self._stack

	@property
	def core(self):
		return self._core

	@property
	def rss(self):
		return self._rss

	@property
	def run(self):
		return self._run

	@property
	def process(self):
		return self._process
	@property
	def swap(self):
		return self._swap

	@property
	def nofile(self):
		return self._nofile

	@property
	def open_files(self):
		return self._openmax

class LoadSched:
	def __init__(self, run_queue_15s,run_queue_1m,run_queue_15m,cpu_utilization,paging_rate,disk_io_rate,login_users, idle_time, tmp_space, swap_free, mem_free):
		self._run_queue_15s=float(run_queue_15s)
		self._run_queue_1m=float(run_queue_1m)
		self._run_queue_15m=float(run_queue_15m)
		self._cpu_utilization=float(cpu_utilization)
		self._paging_rate=float(paging_rate)
		self._disk_io_rate=float(disk_io_rate)
		self._login_users=float(login_users)
		self._idle_time=float(idle_time)
		self._tmp_space=float(tmp_space)
		self._swap_free=float(swap_free)
		self._mem_free=float(mem_free)

	@property
	def run_queue_15s(self):
		return self._run_queue_15s

	@property
	def run_queue_1m(self):
		return self._run_queue_1m

	@property
	def run_queue_15m(self):
		return self._run_queue_15m

	@property
	def cpu_utilization(self):
		return self._cpu_utilization

	@property
	def paging_rate(self):
		return self._paging_rate

	@property
	def disk_io_rate(self):
		return self._disk_io_rate

	@property
	def login_users(self):
		return self._login_users

	@property
	def idle_time(self):
		return self._idle_time

	@property
	def idle_time_timedelta(self):
		return timedelta(minutes=self._idle_time)

	@property
	def tmp_space(self):
		return self._tmp_space

	@property 
	def swap_free(self):
		return self._swap_free

	@property
	def mem_free(self):
		return self._mem_free

	def __len__(self):
		return 10
	def __getitem__(self,key):
		items=['run_queue_15s','run_queue_1m','run_queue_15m','cpu_utilization','paging_rate','disk_io_rate','login_users', 'idle_time', 'tmp_space', 'swap_free', 'mem_free']
		name=items[key]
		return getattr(self,name)
	def to_dict(self):
		d={}
		items=['run_queue_15s','run_queue_1m','run_queue_15m','cpu_utilization','paging_rate','disk_io_rate','login_users', 'idle_time', 'tmp_space', 'swap_free', 'mem_free']
		for i in items:
			d[i]=getattr(self,i)
		return d









class QueueStatus(NumericState):
	states={
			0x01:{
				'name':'QUEUE_STAT_OPEN',
				'description':'The queue is open to accept newly submitted jobs.',
				},
			0x02:{
				'name':'QUEUE_STAT_ACTIVE',
				'description':'The queue is actively dispatching jobs.  The queue can be inactivated and reactivated by the LSF administrator using lsb_queuecontrol. The queue will also be inactivated when its run or dispatch window is closed. In this case it cannot be reactivated manually; it will be reactivated by the LSF system when its run and dispatch windows reopen.',
				},
			0x04:{
				'name':'QUEUE_STAT_RUN',
				'description':'The queue run and dispatch windows are open.  The initial state of a queue at LSF boot time is open and either active or inactive, depending on its run and dispatch windows.',
				},
			0x08:{
				'name':'QUEUE_STAT_NOPERM',
				'description':'Remote queue rejecting jobs.',
				},
			0x10:{
				'name':'QUEUE_STAT_DISC',
				'description':'Remote queue status is disconnected.',
				},
			0x20:{
				'name':'QUEUE_STAT_RUNWIN_CLOSE',
				'description':'Queue run windows are closed.',
				},
			}



class QueueAttribute(NumericState):

	states={
			0x01:{
				'name':'Q_ATTRIB_EXCLUSIVE',
				'description': "This queue accepts jobs which request exclusive execution.  ",
				},
			0x02:{
				'name':'Q_ATTRIB_DEFAULT',
				'description': "This queue is a default LSF queue.  ",
				},
			0x04:{
				'name':'Q_ATTRIB_FAIRSHARE',
				'description': "This queue uses the FAIRSHARE scheduling policy.  The user shares are given in userShares.  ",
				},
			0x80:{
					'name':'Q_ATTRIB_BACKFILL',
					'description': "This queue uses a backfilling policy.  ",
					},
			0x100:{
					'name':'Q_ATTRIB_HOST_PREFER',
					'description': "This queue uses a host preference policy.  ",
					},
			0x800:{
					'name':'Q_ATTRIB_NO_INTERACTIVE',
					'description': "This queue does not accept batch interactive jobs.  ",
					},
			0x1000:{
					'name':'Q_ATTRIB_ONLY_INTERACTIVE',
					'description': "This queue only accepts batch interactive jobs.  ",
					},
			0x2000:{
					'name':'Q_ATTRIB_NO_HOST_TYPE',
					'description': "No host type related resource name specified in resource requirement.  ",
					},
			0x4000:{
					'name':'Q_ATTRIB_IGNORE_DEADLINE',
					'description': "This queue disables deadline constrained resource scheduling.  ",
					},
			0x8000:{
					'name':'Q_ATTRIB_CHKPNT',
					'description': "Jobs may run as chkpntable.  ",
					},
			0x10000:{
					'name':'Q_ATTRIB_RERUNNABLE',
					'description': "Jobs may run as rerunnable.  ",
					},
			0x80000:{
					'name':'Q_ATTRIB_ENQUE_INTERACTIVE_AHEAD',
					'description': "Push interactive jobs in front of other jobs in queue.  ",
					},
			}


class Queue:
	def __init__(self,arg):
		if isinstance(arg, __queueInfoEnt):
			self._q=arg
		elif isinstance(arg, str) or isinstance(arg, unicode):
			if not OpenLava.initialized:
				OpenLava.__initialize()
			queues=OpenLavaCAPI.lsb_queueinfo(queue_list=[arg])
			if ( len(queues) != 1 ):
				raise ValueError("queue not found")
			self._q=queues[0]
		else:
			raise ValueError("Argument must be either a queue name, or __queueInfoEnt")

	def to_dict(self):
		items={}
		for i in ['name','description','priority','nice','allowed_users','host_list','stop_scheduling_load','stop_job_load','user_job_limit','processor_job_limit','run_windows','hard_resource_limits','host_specification','queue_attributes','status','max_jobs','num_jobs','num_pending_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','migration_threshold','scheduling_delay','accept_interval','dispatch_window','default_host_specification','process_limit','queue_admins','pre_execution_command','post_execution_command','pre_post_username','requeue_exit_values','host_job_limit','resource_request','reserved_slots','slot_hold_time','resume_condition','stop_condition','job_starter','suspend_command','resume_command','terminate_command','checkpoint_directory','checkpoint_period','soft_resource_limits','min_processor_limit','default_processor_limit']:
			items[i]=getattr(self,i)
		return items

	def __str__(self):
		return "%s" % self.name

	def __unicode__(self):
		return u"%s" % self.name

	@property
	def name(self):
		return self._q.queue

	@property
	def description(self):
		return self._q.description

	@property
	def priority(self):
		return self._q.priority

	@property
	def nice(self):
		return self._q.nice

	@property
	def allowed_users(self):
		names=self._q.userList
		return [u"%s" % u for u in names.split()]

	@property
	def host_list(self):
		hosts=self._q.hostList
		return [u"%s" % h for h in hosts.split()]

	@property
	def nIdx(self):
		return self._q.nIdx

	@property
	def stop_scheduling_load(self):
		return LoadSched(*self._q.loadSched)

	@property
	def stop_job_load(self):
		return LoadSched(*self._q.loadStop)

	@property
	def user_job_limit(self):
		return self._q.userJobLimit

	@property
	def processor_job_limit(self):
		return self._q.procJobLimit

	@property
	def run_windows(self):
		return self._q.windows

	@property
	def hard_resource_limits(self):
		return RLimit(*self._q.rLimits)

	@property
	def host_specification(self):
		return self._q.hostSpec

	@property
	def queue_attributes(self):
		return QueueAttribute.get_status_list(self._q.qAttrib)

	@property
	def status(self):
		return QueueStatus.get_status_list(self._q.qStatus)
	
	@property
	def max_jobs(self):
		return self._q.maxJobs

	@property
	def num_jobs(self):
		return self._q.numJobs

	@property
	def num_pending_jobs(self):
		return self._q.numPEND

	@property
	def num_running_jobs(self):
		return self._q.numRUN

	@property
	def num_system_suspended_jobs(self):
		return self._q.numSSUSP

	@property
	def num_user_suspended_jobs(self):
		return self._q.numUSUSP

	@property
	def migration_threshold(self):
		return self._q.mig

	@property
	def migration_threshold_timedelta(self):
		return timedelta(minutes=self.migration_threshold)

	@property
	def scheduling_delay(self):
		return self._q.schedDelay

	@property
	def scheduling_delay_timedelta(self):
		return datetime.timedelta(seconds=self.scheduling_delay)

	@property
	def accept_interval(self):
		return self._q.acceptIntvl

	@property
	def accept_interval_timedelta(self):
		return datetime.timedelta(seconds=self.accept_interval)

	@property
	def dispatch_window(self):
		return self._q.windowsD

	@property
	def default_host_specification(self):
		return self._q.defaultHostSpec

	@property
	def process_limit(self):
		return self._q.procLimit

	@property
	def queue_admins(self):
		admins=self._q.admins
		return [u"%s" % a for a in admins.split()]

	@property
	def pre_execution_command(self):
		return self._q.preCmd

	@property
	def post_execution_command(self):
		return self._q.postCmd

	@property
	def pre_post_username(self):
		return u"%s" % self._q.prepostUsername

	@property
	def requeue_exit_values(self):
		return  self._q.requeueEValues

	@property
	def host_job_limit(self):
		return self._q.hostJobLimit

	@property
	def resource_request(self):
		return u"%s" % self._q.resReq

	@property
	def reserved_slots(self):
		return self._q.numRESERVE

	@property
	def slot_hold_time(self):
		return self._q.slotHoldTime

	@property
	def resume_condition(self):
		return self._q.resumeCond

	@property
	def stop_condition(self):
		return self._q.stopCond

	@property
	def job_starter(self):
		return self._q.jobStarter

	@property
	def suspend_command(self):
		return self._q.suspendActCmd

	@property
	def resume_command(self):
		return self._q.resumeActCmd

	@property
	def terminate_command(self):
		return self._q.terminateActCmd

	@property
	def signal_map(self):
		return self._q.sigMap

	@property
	def checkpoint_directory(self):
		return self._q.chkpntDir

	@property
	def checkpoint_period(self):
		return self._q.chkpntPeriod

	@property
	def checkpoint_period_timedelta(self):
		return timedelta(minutes=self.checkpoint_period)

	@property
	def soft_resource_limits(self):
		return RLimit(*self._q.defLimits)

	@property
	def min_processor_limit(self):
		return self._q.minProcLimit

	@property
	def default_processor_limit(self):
			return self._q.defProcLimit


class User:
	def __init__(self,arg):
		if isinstance(arg, __userInfoEnt):
			self._u=arg
		elif isinstance(arg, str) or isinstance(arg, unicode):
			if not OpenLava.initialized:
				OpenLava.__initialize()
			users=OpenLavaCAPI.lsb_userinfo(user_list=[arg])
			if ( len(users) != 1 ):
				raise ValueError("User not found")
			self._u=users[0]
		else:
			raise ValueError("Invalid User")



	def to_dict(self):
		items={}
		for i in ['name','process_job_limit','max_jobs','num_started_jobs','num_jobs','num_pending_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','num_reserved_slots']:
			items[i]=getattr(self,i)
		return items


	def __str__(self):
		return "%s" % self.name

	def __unicode__(self):
		return u"%s" % self.name

	@property
	def name(self):
		return self._u.user

	@property
	def process_job_limit(self):
		return self._u.procJobLimit

	@property
	def max_jobs(self):
		return self._u.maxJobs

	@property
	def num_started_jobs(self):
		return self._u.numStartJobs

	@property
	def num_jobs(self):
		return self._u.numJobs

	@property
	def num_pending_jobs(self):
		return self._u.numPEND

	@property
	def num_running_jobs(self):
		return self._u.numRUN

	@property
	def num_system_suspended_jobs(self):
		return self._u.numSSUSP

	@property
	def num_user_suspended_jobs(self):
		return self._u.numUSUSP

	@property
	def num_reserved_slots(self):
		return self._u.numRESERVE


class HostAttribute(NumericState):
	states={
			0x1:{
				'name':'H_ATTR_CHKPNTABLE',
				'description': "This host can checkpoint jobs.  ",
				},
			0x2:{
				'name':'H_ATTR_CHKPNT_COPY',
				'description': "This host provides kernel support for checkpoint copy. ",
				},
			}

class HostStatus(NumericState):
	states={
			0x0:{
				'name':'HOST_STAT_OK',
				'description': "Ready to accept and run jobs.  ",
				},
			0x01:{
				'name':'HOST_STAT_BUSY',
				'description': "The host load is greater than a scheduling threshold.  In this status, no new job will be scheduled to run on this host.  ",
				},
			0x02:{
				'name':'HOST_STAT_WIND',
				'description': "The host dispatch window is closed.  In this status, no new job will be accepted.  ",
				},
			0x04:{
				'name':'HOST_STAT_DISABLED',
				'description': "The host has been disabled by the LSF administrator and will not accept jobs.  In this status, no new job will be scheduled to run on this host.  ",
				},
			0x08:{
				'name':'HOST_STAT_LOCKED',
				'description': "The host is locked by a exclusive task.  In this status, no new job will be scheduled to run on this host.  ",
				},
			0x10:{
				'name':'HOST_STAT_FULL',
				'description': "Great than job limit.  The host has reached its job limit. In this status, no new job will be scheduled to run on this host.  ",
				},
			0x20:{
					'name':'HOST_STAT_UNREACH',
					'description': "The sbatchd on this host is unreachable.  ",
					},
			0x40:{
					'name':'HOST_STAT_UNAVAIL',
					'description': "The LIM and sbatchd on this host are unavailable.  ",
					},
			0x80:{
					'name':'HOST_STAT_NO_LIM',
					'description': "The host is running an sbatchd but not a LIM.  ",
					},
			0x100:{
					'name':'HOST_STAT_EXCLUSIVE',
					'description': "Running exclusive job.  ",
					},
			0x200:{
					'name':'HOST_STAT_LOCKED_MASTER',
					'description': "Lim locked by master LIM.  ",
					},
			}



class Host():
	def __init__(self,arg):
		if isinstance(arg, __hostInfoEnt):
			self._h=arg
		elif isinstance(arg, str) or isinstance(arg, unicode):
			if not OpenLava.initialized:
				OpenLava.__initialize()
			hosts=OpenLavaCAPI.lsb_hostinfo(host_list=[arg])
			if ( len(hosts) != 1 ):
				raise ValueError("Host not found")
			self._h=hosts[0]
		else:
			raise ValueError("Argument must be either a hostname, or __hostInfoEnt")

	@property
	def host_name(self):
		return self._h.host

	@property
	def name(self):
		return self.host_name

	@property
	def status(self):
		return HostStatus(self._h.hStatus)

	@property
	def busy_schedule_load(self):
		return LoadSched(*self._h.busySched)

	@property
	def busy_stop_load(self):
		return LoadSched(*self._h.busyStop)

	@property
	def load(self):
		return LoadSched(*self._h.load)

	@property
	def cpu_factor(self):
		return self._h.cpuFactor

	@property
	def run_windows(self):
		return self._h.windows

	@property
	def user_job_limit(self):
		return self._h.userJobLimit

	@property
	def max_jobs(self):
		return self._h.maxJobs

	@property
	def num_jobs(self):
		return self._h.numJobs

	@property
	def num_running_jobs(self):
		return self._h.numRUN

	@property
	def num_system_suspended_jobs(self):
		return self._h.numSSUSP

	@property
	def num_user_suspended_jobs(self):
		return self._h.numUSUSP

	@property
	def migration_threshold(self):
		return self._h.mig

	@property
	def host_attributes(self):
		return HostAttribute.get_status_list(self._h.attr)

	@property
	def real_load(self):
		return LoadSched(*self._h.realLoad)

	@property
	def num_reserved_slots(self):
		return self._h.numRESERVE

	@property
	def checkpoint_signal(self):
		return self._h.chkSig

	def to_dict(self):
		d={}
		for i in ['name','status','busy_schedule_load','busy_stop_load','real_load', 'load','cpu_factor','run_windows','user_job_limit','max_jobs','num_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','migration_threshold','host_attributes','num_reserved_slots','checkpoint_signal']:
			d[i]=getattr(self,i)
		return d











class OpenLavaEncoder(json.JSONEncoder):
	def default(self,obj):
		try:
			return obj.to_dict()
		except:
			return json.JSONEncoder.default(self, obj)

class OpenLava:
	initialized=False

	@classmethod
	def dumps(cls, obj):
		return json.dumps(obj,cls=OpenLavaEncoder)

	@classmethod
	def __initialize(cls):
		OpenLavaCAPI.lsb_init("OpenLava Python")
		cls.initialized=True

	@classmethod
	def get_host_list(cls, hosts=[]):
		if not cls.initialized:
			cls.__initialize()
		hosts=OpenLavaCAPI.lsb_hostinfo(hosts)
		return [Host(h) for h in hosts]

	@classmethod
	def get_user_list(cls, users=[]):
		if not cls.initialized:
			cls.__initialize()
		users=OpenLavaCAPI.lsb_userinfo(users)
		return [User(u) for u in users]

	@classmethod
	def get_queue_list(cls, queues=[], hosts=[], users=[]):
		if not cls.initialized:
			cls.__initialize()
		hosts=" ".join(hosts)
		users=" ".join(users)
		queues=OpenLavaCAPI.lsb_queueinfo(queues, 0, hosts, users)
		return [Queue(q) for q in queues]

	@classmethod
	def get_job_list(cls, job_id=0, job_name="", user="all", queue="", host="", options=0):
		if not cls.initialized:
			cls.__initialize()
		num_jobs=OpenLavaCAPI.lsb_openjobinfo(job_id=job_id, job_name=job_name, user=user, queue=queue, host=host, options=options)

		jobs=[]
		for i in range(num_jobs):
			jobs.append(Job(OpenLavaCAPI.lsb_readjobinfo()))
		OpenLavaCAPI.lsb_closejobinfo()
		return jobs

	@classmethod
	def get_job_id(cls, job_id):
		if job_id==-1:
			id=-1
		else:
			id=job_id & 0x0FFFFFFFF
			return id


	@classmethod
	def create_job_id(cls, job_id, array_index):
		id=array_index
		id=id << 32
		id=id | job_id
		return id

	@classmethod
	def get_array_index(cls, LS_LONG_INT job_id):
		if job_id == -1:
			array_index=0
		else:
			array_index=( job_id >> 32 ) & 0x0FFFF
		return array_index

	@classmethod
	def get_cluster_name(cls):
		if not cls.initialized:
			cls.__initialize()
		return OpenLavaCAPI.ls_getclustername()

	def get_master_name(cls):
		if not cls.initialized:
			cls.__initialize()
		return OpenLavaCAPI.ls_getmastername()
