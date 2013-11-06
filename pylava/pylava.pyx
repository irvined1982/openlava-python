cimport pylava
from python_lava import JobStatus
from datetime import timedelta
cdef int lserrno


cdef class Job:
	cdef jobInfoEnt * _job
	cdef _from_struct(self, jobInfoEnt * job):
		self._job=job

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
			all_jobs=False, 
			unfinished_jobs=True, 
			done_jobs=False, 
			pending_jobs=False, 
			suspended_jobs=False, 
			last_job=False
			):
		num_jobs= pylava.lsb_openjobinfo(job_id,job_name,user,queue,host,0)
		assert num_jobs>=0, "Unable to lsb_openjobinfo"
	def read_job_info(self):
		cdef int * foo
		cdef jobInfoEnt * j
		j=pylava.lsb_readjobinfo(foo)
		job=Job()
		job._from_struct(j)
		return job
