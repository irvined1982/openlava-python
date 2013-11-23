from openlava import OpenLavaCAPI,Host, Queue, User, OpenLava


import unittest


class LSBTests(unittest.TestCase):
	def setUp(self):
		self.assertEqual( OpenLavaCAPI.lsb_init("My App"), 0)
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
	
	def test_users(self):
		users=OpenLavaCAPI.lsb_userinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
		self.assertIsInstance(users,list)
		for u in users:
			self.assertEqual(str(type(u)),"<type 'openlava.__userInfoEnt'>")
			self.assertIsInstance(u.user,unicode)
			methods=[
					'procJobLimit',
					'maxJobs',
					'numStartJobs',
					'numJobs',
					'numPEND',
					'numRUN',
					'numSSUSP',
					'numUSUSP',
					'numRESERVE',
					]
			for i in methods:
				self.assertGreaterEqual(getattr(u,i),0)
	def test_user(self):
		users=OpenLavaCAPI.lsb_userinfo(["default"])
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
		self.assertEqual( len(users), 1 )
	def test_job(self):
		num_jobs=OpenLavaCAPI.lsb_openjobinfo(job_id=1)
		self.assertEqual( num_jobs, -1)
		OpenLavaCAPI.lsb_closejobinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)

	def test_jobs(self):
		num_jobs=OpenLavaCAPI.lsb_openjobinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
		for i in range(num_jobs):
			job=OpenLavaCAPI.lsb_readjobinfo()
			self.check_job(job)
		OpenLavaCAPI.lsb_closejobinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)

	def check_job(self,job):
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
		self.assertEqual(str(type(job)), "<type 'openlava.__jobInfoEnt'>")
		ints=[
			'jobId',
			'status',
			'numReasons',
			'reasons',
			'subreasons',
			'jobPid',
			'submitTime',
			'reserveTime',
			'startTime',
			'predictedStartTime',
			'endTime',
			'umask',
			'numExHosts','nIdx',
			'exitStatus',
			'execUid',
			'jType',
			'port',
			'jobPriority',
			'jRusageUpdateTime'
			]
		for attr in ints:
			self.assertIsInstance(getattr(job,attr),int)
		for a in range(7):
			self.assertIsInstance(job.counter[a],int)

		for attr in ['cwd','subHomeDir','fromHost','execHome','execCwd','execUsername','parentGroup','jName',]:
			self.assertIsInstance(getattr(job,attr),unicode)
		
		self.assertIsInstance(job.exHosts,list)
		for host in job.exHosts:
			self.assertIsInstance(host, unicode)

		self.assertIsInstance(job.loadSched,list)
		self.assertIsInstance(job.loadStop,list)
		self.assertEqual(len(job.loadSched), job.nIdx)
		self.assertEqual(len(job.loadStop), job.nIdx)
		for l in job.loadSched:
			self.assertIsInstance(l,float)
		for l in job.loadStop:
			self.assertIsInstance(l,float)
		for a in [job.cpuFactor, job.cpuTime]:
			self.assertIsInstance(a,float)

		s=job.submit
		self.assertEqual(str(type(s)),"<type 'openlava.__submit'>")
		for attr in [
				'options',
				'options2',
				'numAskedHosts',
				'numProcessors',
				'sigValue',
				'nxf',
				'delOptions',
				'delOptions2',
				'maxNumProcessors',
				'userPriority',
				'beginTime',
				'termTime',
				'chkpntPeriod',
				]:
			self.assertIsInstance(getattr(s,attr),int)
		for attr in [
				'jobName',
				'queue',
				'resReq',
				'hostSpec',
				'dependCond',
				'inFile',
				'outFile',
				'errFile',
				'command',
				'chkpntDir',
				'preExecCmd',
				'mailUser',
				'projectName',
				'loginShell',]:
			self.assertIsInstance(getattr(s,attr),unicode)
		self.assertEqual(len(s.askedHosts),s.numAskedHosts)
		for h in s.askedHosts:
			self.assertIsInstance(h,unicode)
		for r in range(10):
			self.assertIsInstance(s.rLimits[r],int)
			self.assertGreaterEqual(s.rLimits[r],-1)
		xf=s.xf
		self.assertEqual(len(xf), s.nxf)
		self.assertIsInstance(xf,list)
		for a in xf:
			self.assertIsInstance(a.subFn,unicode)
			self.assertIsInstance(a.execFn,unicode)
			self.assertIsInstance(a.options,int)
		ru=job.runRusage
		for a in ['mem','swap','utime','stime','npids','npgids']:
			self.assertIsInstance(getattr(ru,a),int)
			self.assertGreaterEqual(getattr(ru,a),-1)
			inf=ru.pidInfo
			self.assertEqual(len(inf),ru.npids)
			for pi in inf:
				for a in ['pid','ppid','pgid','jobid']:
					self.assertGreaterEqual(getattr(pi,a),-1)
			for g in range(ru.npgids):
				self.assertGreaterEqual(ru.pgid[g],-1)

	def test_queues(self):
		queues=OpenLavaCAPI.lsb_queueinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)
	def test_hosts(self):
		hosts=OpenLavaCAPI.lsb_hostinfo()
		self.assertEqual( OpenLavaCAPI.lsberrno, OpenLavaCAPI.LSBE_NO_ERROR)


class HighLevel(unittest.TestCase):
	def test_users(self):
		users=OpenLava.get_user_list()
		for u in users:
			self.check_user(u)

	def test_user(self):
		user=User("irvined")
		self.check_user(user)

	def test_hosts(self):
		hosts=OpenLava.get_host_list()
		for h in hosts:
			self.check_host(h)
	def test_host(self):
		import socket
		host=Host(socket.gethostname())
		self.check_host(host)
		self.assertRaises(ValueError,Host,'23wf22f23f')

	def test_queues(self):
		queues=OpenLava.get_queue_list()
		for queue in queues:
			self.check_queue(queue)
		self.assertRaises(ValueError,Queue, '-123kjwld2o323f')



	def check_queue(self, queue):
		for i in queue.allowed_users:
			self.assertIsInstance(i,str)
		for i in queue.host_list:
			self.assertIsInstance(i,str)
		for i in queue.run_windows:
			self.assertIsInstance(i,str)
		for i in queue.queue_admins:
			self.assertIsInstance(i,str)
		for attr in queue.queue_attributes:
			self.check_status(attr)
		self.check_status(queue.status)
		self.check_load(queue.stop_job_load)
		self.check_load(queue.stop_scheduling_load)

		self.check_rlim(queue.soft_resource_limits)
		self.check_rlim(queue.hard_resource_limits)

		for attr in ['name','description','host_specification','dispatch_window','default_host_specification','pre_execution_command','post_execution_command','pre_post_username','requeue_exit_values','resource_request','resume_condition','stop_condition','job_starter','suspend_command','resume_command','terminate_command','checkpoint_directory']:
			self.assertIsInstance(getattr(queue,attr),unicode)
		self.assertIsInstance(queue.processor_job_limit,float)
		for attr in ['priority','nice','user_job_limit','max_jobs','num_jobs','num_pending_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','migration_threshold','scheduling_delay','accept_interval','dispatch_window','process_limit','host_job_limit','reserved_slots','slot_hold_time','checkpoint_period','min_processor_limit','default_processor_limit']:
			self.assertIsInstance(getattr(queue,attr),int)

	def check_rlim(self,r):
		for attr in ['cpu','file_size','data','stack','core','rss','run','process','swap','nofile','open_files']:
			self.assertIsInstance(getattr(r,attr),int)

	def check_host(self,host):
		self.assertIsInstance(host.name, unicode)
		self.assertIsInstance(host.run_windows, unicode)
		self.check_status(host.status)
		self.check_load(host.busy_schedule_load)
		self.check_load(host.busy_stop_load)
		self.check_load(host.load)
		self.assertIsInstance(host.cpu_factor,float)
		for i in ['user_job_limit','max_jobs','num_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','migration_threshold','num_reserved_slots','checkpoint_signal']:
			self.assertIsInstance(getattr(host,i), int)
		for attr in host.host_attributes:
			self.check_status(attr)
		self.assertIsInstance(host.to_dict(),dict)
	
	def check_load(self,load):
		for i in ['run_queue_15s','run_queue_1m','run_queue_15m','cpu_utilization','paging_rate','disk_io_rate','login_users', 'idle_time', 'tmp_space', 'mem_free']:
			self.assertIsInstance(getattr(load,i), float)
		self.assertIsInstance(load.to_dict(),dict)



	def check_status(self,status):
		for i in ['name','description','friendly']:
			self.assertIsInstance(getattr(status,i), unicode)
		self.assertIsInstance(status.status, int)
		self.assertIsInstance(status.to_dict(),dict)

	def check_user(self,user):
		self.assertIsInstance(user.name, unicode)
		self.assertIsInstance(user.process_job_limit, float)
		for i in ['max_jobs','num_started_jobs','num_jobs','num_pending_jobs','num_running_jobs','num_system_suspended_jobs','num_user_suspended_jobs','num_reserved_slots']:
			self.assertIsInstance(getattr(user,i),int)
	



class LSTests(unittest.TestCase):
	def test_ls(self):
		self.assertTrue(OpenLavaCAPI.ls_getclustername())
		self.assertTrue(OpenLavaCAPI.ls_getmastername())

unittest.main()






