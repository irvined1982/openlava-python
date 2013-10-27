cimport pylava
from openlava.generic import JobStatus,SuspReason,PendReason,QueueStatus,QueueAttribute
from datetime import timedelta
from datetime import datetime
cdef int lserrno

cdef class QueueInfo:
	cdef queueInfoEnt *_q
	cdef _from_struct(self, queueInfoEnt * q):
		self._q=q
	property name:
		def __get__(self):
			return u"%s" % self._q.queue
	def __str__(self):
		return "%s" % self.name
	def __unicode__(self):
		return u"%s" % self.name

	property description:
		def __get__(self):
			return u"%s" % self._q.description

	property priority:
		def __get__(self):
			return self._q.priority

	property nice:
		def __get__(self):
			return self._q.nice

	property allowed_users:
		def __get__(self):
			names=self._q.userList
			return [u"%s" % u for u in names.split()]

	property host_list:
		def __get__(self):
			hosts=self._q.hostList
			return [u"%s" % h for h in hosts.split()]

	property nIdx:
		def __get__(self):
			return self._q.nIdx

	#property *loadSched;:
	#	def __get__(self):
	#		return self._q.*loadSched;

	#property *loadStop:
	#	def __get__(self):
	#		return self._q.*loadStop

	property user_job_limit:
		def __get__(self):
			return self._q.userJobLimit

	property processor_job_limit:
		def __get__(self):
			return self._q.procJobLimit

#	property *windows:
#		def __get__(self):
#			return self._q.*windows

#	property rLimits[LSF_RLIM_NLIMITS]:
#		def __get__(self):
#			return self._q.rLimits[LSF_RLIM_NLIMITS]

	property host_specification:
		def __get__(self):
			return u"%s" % self._q.hostSpec

	property queue_attributes:
		def __get__(self):
			return QueueAttribute.get_status_list(self._q.qAttrib)

	property status:
		def __get__(self):
			return QueueStatus(self._q.qStatus)
	
	property max_jobs:
		def __get__(self):
			return self._q.maxJobs

	property num_jobs:
		def __get__(self):
			return self._q.numJobs

	property num_pending_jobs:
		def __get__(self):
			return self._q.numPEND

	property num_running_jobs:
		def __get__(self):
			return self._q.numRUN

	property num_system_suspended_jobs:
		def __get__(self):
			return self._q.numSSUSP

	property num_user_suspended_jobs:
		def __get__(self):
			return self._q.numUSUSP

	property migration_threashold:
		def __get__(self):
			return self._q.mig

	property scheduling_delay:
		def __get__(self):
			return self._q.schedDelay
	property scheduling_delay_timedelta:
		def __get__(self):
			return datetime.timedelta(seconds=self.scheduling_delay)

	property accept_interval:
		def __get__(self):
			return self._q.acceptIntvl
	property accept_interval_timedelta:
		def __get__(self):
			return datetime.timedelta(seconds=self.accept_interval)

	#property *windowsD:
	#	def __get__(self):
	#		return self._q.*windowsD

	property default_host_specification:
		def __get__(self):
			return u"%s" % self._q.defaultHostSpec

	property process_limit:
		def __get__(self):
			return self._q.procLimit

	property queue_admins:
		def __get__(self):
			admins=self._q.admins
			return [u"%s" % a for a in admins.split()]

	property pre_execution_command:
		def __get__(self):
			return u"%s" % self._q.preCmd

	property post_execution_command:
		def __get__(self):
			return u"%s" % self._q.postCmd

	property pre_post_username:
		def __get__(self):
			return u"%s" % self._q.prepostUsername

	property requeue_exit_values:
		def __get__(self):
			return u"%s" % self._q.requeueEValues

	property host_job_limit:
		def __get__(self):
			return self._q.hostJobLimit

	property resource_request:
		def __get__(self):
			return u"%s" % self._q.resReq

	property reserved_slots:
		def __get__(self):
			return self._q.numRESERVE

	property slot_hold_time:
		def __get__(self):
			return self._q.slotHoldTime

	property resume_condition:
		def __get__(self):
			return u"%s" % self._q.resumeCond

	property stop_condition:
		def __get__(self):
			return u"%s" % self._q.stopCond

	property job_starter:
		def __get__(self):
			return u"%s" %self._q.jobStarter

	property suspend_command:
		def __get__(self):
			return u"%s" % self._q.suspendActCmd

	property resume_command:
		def __get__(self):
			return u"%s" % self._q.resumeActCmd

	property terminate_command:
		def __get__(self):
			return u"%s" % self._q.terminateActCmd

	#property sigMap[LSB_SIG_NUM]:
	#	def __get__(self):
	#		return self._q.sigMap[LSB_SIG_NUM]

	property checkpoint_directory:
		def __get__(self):
			return u"%s" % self._q.chkpntDir

	property checkpoint_period:
		def __get__(self):
			return self._q.chkpntPeriod

	#property defLimits[LSF_RLIM_NLIMITS]:
	#	def __get__(self):
	#		return self._q.defLimits[LSF_RLIM_NLIMITS]

	property min_processor_limit:
		def __get__(self):
			return self._q.minProcLimit

	property default_processor_limit:
		def __get__(self):
			return self._q.defProcLimit


cdef class TransferFile:
	cdef xFile * _xf
	cdef _from_struct(self, xFile * xf):
		self._xf=xf
	property submission_file_name:
		def __get__(self):
			return "%s" % self._xf.subFn
	property execution_file_name:
		def __get__(self):
			return "%s" %  self._xf.execFn
	property options:
		def __get__(self):
			return self._xf.options

cdef class Submit:
	cdef submit * _sub
	cdef _from_struct(self,submit * sub):
		self._sub=sub
	property options:
		def __get__(self):
			return self._sub.options
	property options2:
		def __get__(self):
			return self._sub.options2
	property job_name:
		def __get__(self):
			return u"%s" % self._sub.jobName
	property queue_name:
		def __get__(self):
			return u"%s" % self._sub.queue
	property num_asked_hosts:
		def __get__(self):
			return self._sub.numAskedHosts
	property asked_hosts:
		def __get__(self):
			hosts=[]
			for i in range(self.num_asked_hosts):
				hosts.append(u"%s" % self._sub.askedHosts[i])
			return hosts
	property requested_resources:
		def __get__(self):
			return u"%s" % self._sub.resReq
	#property resource_limits:
	#	def __get__(self):
	#		return self._sub.rlimits
	property host_specification:
		def __get__(self):
			return u"%s" % self._sub.hostSpec
	property num_processors:
		def __get__(self):
			return self._sub.numProcessors
	property dependency_condition:
		def __get__(self):
			return u"%s" % self._sub.dependCond
	property begin_time:
		def __get__(self):
			return self._sub.beginTime
	property begin_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.begin_time)
	property begin_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.begin_time)
	property termination_time:
		def __get__(self):
			return self._sub.termTime
	property termination_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.termination_time)
	property termination_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.termination_time)
	property signal_value:
		def __get__(self):
			return self._sub.sigValue
	property input_file:
		def __get__(self):
			return u"%s" % self._sub.inFile
	property output_file:
		def __get__(self):
			return u"%s" % self._sub.outFile
	property error_file:
		def __get__(self):
			return u"%s" % self._sub.errFile
	property command:
		def __get__(self):
			return u"%s" %self._sub.command
	property new_command:
		def __get__(self):
			return u"%s" % self._sub.newCommand
	property checkpoint_period:
		def __get__(self):
			return self._sub.chkpntPeriod
	property checkpoint_dir:
		def __get__(self):
			return u"%s" % self._sub.chkpntDir
	property num_transfer_files:
		def __get__(self):
			return self._sub.nxf
	property transfer_files:
		def __get__(self):
			files=[]
			for i in range(self.num_transfer_files):
				f=TransferFile()
				f._from_struct(&self._sub.xf[i])
				files.append(f)
			return files
	property pre_execution_command:
		def __get__(self):
			return  u"%s" % self._sub.preExecCmd
	property email_user:
		def __get__(self):
			return  u"%s" % self._sub.mailUser
	property delete_options:
		def __get__(self):
			return self._sub.delOptions
	property delete_options2:
		def __get__(self):
			return self._sub.delOptions2
	property project_name:
		def __get__(self):
			return  u"%s" % self._sub.projectName
	property max_num_processors:
		def __get__(self):
			return self._sub.maxNumProcessors
	property login_shell:
		def __get__(self):
			return  u"%s" % self._sub.loginShell
	property user_priority:
		def __get__(self):
			return self._sub.userPriority


cdef class PIDInfo:
	cdef pidInfo * _pinfo
	cdef _from_struct(self, pidInfo * pinfo):
		self._pinfo=pinfo
	property process_id:
		def __get__(self):
			return self._pinfo.pid
	property parent_process_id:
		def __get__(self):
			return self._pinfo.ppid
	property group_id:
		def __get__(self):
			return self._pinfo.pgid
	property cray_job_id:
		def __get__(self):
			return self._pinfo.jobid

cdef class RUsage:
	cdef jRusage * _ru
	cdef _from_struct(self, jRusage * ru):
		self._ru=ru
	property resident_memory_usage:
		def __get__(self):
			return self._ru.mem
	property virtual_memory_usage:
		def __get__(self):
			return self._ru.swap
	property user_time:
		def __get__(self):
			return self._ru.utime
	property user_time_timedelta:
		def __get__(self):
			return timedelta(seconds=self.user_time)
	property system_time:
		def __get__(self):
			return self._ru.stime
	property system_time_timedelta:
		def __get__(self):
			return timedelta(seconds=self.system_time)
	property num_active_processes:
		def __get__(self):
			return self._ru.npids
	property active_processes:
		def __get__(self):
			pids=[]
			for i in range(self.num_active_processes):
				p=PIDInfo()
				p._from_struct(&self._ru.pidInfo[i])
				pids.append(p)
			return pids
	property num_active_process_groups:
		def __get__(self):
			return self._ru.npgids
	property active_process_groups:
		def __get__(self):
			g=[]
			for i in range(self.num_active_process_groups):
				g.append(self._ru.pgid[i])
			return g


cdef class Job:
	cdef jobInfoEnt * _job
	cdef _from_struct(self, jobInfoEnt * job):
		self._job=job

	property pend_reasons:
		def __get__(self):
			v={
			}
			for i in range(self._job.numReasons):
				reason=self._job.reasonTb[i]
				reason=reason & 0x00000000000ffff
				if self._job.status==0x01: # pend
					r=PendReason(reason)
				if self._job.status==0x02: # psusp
					r=SuspReason(reason)
				try:
					v[r.name].count+=1
				except:
					v[r.name]=r
					v[r.name].count=1
			return v.values()
	property submit:
		def __get__(self):
			s=Submit()
			s._from_struct(&self._job.submit)
			return s
	property resource_usage:
		def __get__(self):
			r=RUsage()
			r._from_struct(&self._job.runRusage)
			return r

	property user:
		def __get__(self):
			return u"%s" % self._job.user

	property status:
		def __get__(self):
			return JobStatus(self._job.status)

	property pid:
		def __get__(self):
			return self._job.jobPid

	property cpu_time:
		def __get__(self):
			return self._job.cpuTime

	property cpu_time_timedelta:
		def __get__(self):
			return timedelta(seconds=self.cpu_time)

	property cwd:
		def __get__(self):
			return u'%s' % self._job.cwd

	property submit_home_dir:
		def __get__(self):
			return u'%s' % self._job.subHomeDir

	property submission_host:
		def __get__(self):
			return u'%s' % self._job.fromHost

	property execution_hosts:
		def __get__(self):
			hosts=[]
			for h in range(self._job.numExHosts):
				hosts.append(u'%s' % self._job.exHosts[h])
			return hosts
	property cpu_factor:
		def __get__(self):
			return self._job.cpuFactor

	property execution_user_id:
		def __get__(self):
			return self._job.execUid

	property execution_home_dir:
		def __get__(self):
			return u'%s' % self._job.execHome

	property execution_cwd:
		def __get__(self):
			return u'%s' % self._job.execCwd

	property execution_user_name:
		def __get__(self):
			return u'%s' % self._job.execUsername

	property parent_group:
		def __get__(self):
			return u'%s' % self._job.parentGroup

	property job_id:
		def __get__(self):
			return self._job.jobId
	
	property name:
		def __get__(self):
			return u'%s' % self._job.jName

	def __str__(self):
		if len(self.name)>0:
			return "%d (%s)"%(self.job_id, self.name)
		else:
			return "%d" % self.job_id

	def __unicode__(self):
		return u'%s' % self.__str__()

	def __int__(self):
		return self.job_id

	property service_port:
		def __get__(self):
			return self._job.port

	property priority:
		def __get__(self):
			return self._job.jobPriority

	property submit_time:
		def __get__(self):
			return self._job.submitTime
	property submit_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.submit_time)
	property submit_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.submit_time)


	property reservation_time:
		def __get__(self):
			return self._job.reserveTime
	property reservation_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.reservation_time)
	property reservation_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.reservation_time)

	property start_time:
		def __get__(self):
			return self._job.startTime
	property start_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.start_time)
	property start_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.start_time)

	property predicted_start_time:
		def __get__(self):
			return self._job.predictedStartTime
	property predicted_start_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.predicted_start_time)
	property predicted_start_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.predicted_start_time)

	property end_time:
		def __get__(self):
			return self._job.endTime
	property end_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.end_time)
	property end_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.end_time)

	property resource_usage_last_update_time:
		def __get__(self):
			return self._job.jRusageUpdateTime
	property resource_usage_last_update_time_datetime_local:
		def __get__(self):
			return datetime.fromtimestamp(self.resource_usage_last_update_time)
	property resource_usage_last_update_time_datetime_utc:
		def __get__(self):
			return datetime.utcfromtimestamp(self.resource_usage_last_update_time)

cdef class OpenLava:
	def __cinit__(self,app_name):
		assert pylava.lsb_init(app_name)==0, "Open Lava Initialization failed."
	def get_cluster_name(self):
		return pylava.ls_getclustername()
	def get_master_name(self):
		return pylava.ls_getmastername()
	def open_job_info(self,
			job_id=0, 
			job_name="",
			user="all",
			queue="", 
			host="", 
			options=0,
			):

		num_jobs= pylava.lsb_openjobinfo(job_id,job_name,user,queue,host,options)
		if num_jobs<0:
			raise ValueError("No Jobs Found")
		return num_jobs
	def read_job_info(self):
		cdef int * more
		cdef jobInfoEnt * j
		j=pylava.lsb_readjobinfo(more)
		job=Job()
		job._from_struct(j)
		return job
	def close_job_info(self):
		pylava.lsb_closejobinfo()
	def get_queue_info(self,queue_names=[],host="",user_name=""):
		cdef int num_queues
		cdef queueInfoEnt *queue_info
		cdef queueInfoEnt   *qp
		cdef char* h
		cdef char* u

		h=NULL
		u=NULL
		num_queues=0

		if len(host)>0:
			h=host
		if len(user_name)>0:
			u=user_name

		queue_info=pylava.lsb_queueinfo(NULL, &num_queues, h, u,0)
		queues=[]
		for i in range(num_queues):
			qp=&queue_info[i]
			queue=QueueInfo()
			queue._from_struct(qp)
			if len(queue_names)>0:
				if queue.name in queue_names:
					queues.append(queue)
			else:
				queues.append(queue)
		return queues


	

