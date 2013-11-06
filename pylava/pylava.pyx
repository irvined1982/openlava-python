cimport pylava
cdef int lserrno

cdef class OpenLava:
	def __cinit__(self,app_name):
		assert pylava.lsb_init(app_name)==0, "Open Lava Initialization failed."
	def get_cluster_name(self):
		return pylava.ls_getclustername()
	def get_master_name(self):
		return pylava.ls_getmastername()
	def get_jobs(self,
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
		return JobList()

class JobList:
	def __init__(self):
		self.__more=int()
		job=lsb_readjobinfo(self.__more)
		print "job %s" %job
		if job==None:
			raise ValueError("No Job")
		self.__job=job
	def next(self):
		if not self.__more:
			raise StopIteration
		self.__job=pylava.lsb_readjobinfo(self.__more)
		if not self.__job:
			raise ValueError("No Job")
	def __iter__(self):
		return self

