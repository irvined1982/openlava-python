from openlava.connection import OpenLavaConnection

def get_job_by_id(job_id):
	lava=OpenLavaConnection.get_connection()
	num_jobs=lava.open_job_info(job_id=job_id)
	if num_jobs<1:
		raise ValueError("Job Not Found")
	job=lava.read_job_info()
	lava.close_job_info()
	return job
class JobList():
	def __init__(self, job_id=0,job_name="", user="all", queue="", host="", options=0):
		self._lava=OpenLavaConnection.get_connection()
		self._job_id=job_id
		self._job_name=job_name
		self._user=user
		self._queue=queue
		self._host=host
		self._options=options
		self._counter=0
	def __iter__(self):
		self._num_jobs=self._lava.open_job_info(job_id=self._job_id,job_name=self._job_name, user=self._user, queue=self._queue, host=self._host, options=self._options)
		return self
	def __del__(self):
		self._lava.close_job_info()

	def next(self):
		if self._counter>=self._num_jobs:
			raise StopIteration
		self._counter+=1
		self.job=self._lava.read_job_info()
		print self.job.job_id
		return self
