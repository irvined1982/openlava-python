class JobStatus:
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

	def __init__(self,status):
		self._status=status
	def __unicode__(self):
		return u'%s' % self.states[self._status]['name']
	def __str__(self):
		return '%s' % self.states[self._status]['name']
	def __int__(self):
		return self._status
	@property
	def name(self):
		return u'%s' % self.states[self._status]['name']
	@property
	def description(self):
		return u'%s' % self.states[self._status]['description']
	@property
	def status(self):
		return self._status
