from pylava import OpenLava

f=OpenLava("Masdf")
print "Cluster name: %s" % f.get_cluster_name()
print "Master host name: %s" %f.get_master_name()
for job in f.get_all_jobs():
	print "User: %s" % job.user
	print "Status: %s" % job.status
	print "Status Name: %s" % job.status.name
	print "Status Description: %s" % job.status.description
	print "Status ID: %d" % job.status
	print "Status ID explicit: %d" % job.status.status
	print "Job PID: %d" % job.pid
	print "CPU Time (raw): %f" % job.cpu_time
	print "CPU Time (timedelta): %s" % job.cpu_time_timedelta
	print "CWD: %s" % job.cwd
	print "Submission Home Directory: %s" % job.submit_home_dir
	print "Submission Host: %s" % job.submission_host
	print "Execution Hosts: %s" % job.execution_hosts
	print "CPU Factor: %f" % job.cpu_factor
	print "Execution User ID: %s" % job.execution_user_id
	print "Execution User Name: %s" % job.execution_user_name
	print "Execution Home Directory: %s" % job.execution_home_dir
	print "Execution Current Working Directory: %s" % job.execution_cwd
	print "Job Parent Group: %s" % job.parent_group
	print "Job Name: %s" % job.name
	print "Job ID: %d" % job.job_id
	print "Service Port: %s" % job.service_port
	print "Job Priority: %s" % job.priority
	print "Job Submit Time: %s" % job.submit_time
	print "Job Submit Time (Local): %s" % job.submit_time_datetime_local
	print "Job Submit Time (Zulu): %s" % job.submit_time_datetime_utc
	print "Job Reservation Time: %s" % job.reservation_time
	print "Job Reservation Time (Local): %s" % job.reservation_time_datetime_local
	print "Job Reservation Time (Zulu): %s" % job.reservation_time_datetime_utc
	print "Job Start Time: %s" % job.start_time
	print "Job Start Time (Local): %s" % job.start_time_datetime_local
	print "Job Start Time (Zulu): %s" % job.start_time_datetime_utc
	print "Job Predicted Start Time: %s" % job.predicted_start_time
	print "Job Predicted Start Time (Local): %s" % job.predicted_start_time_datetime_local
	print "Job Predicted Start Time (Zulu): %s" % job.predicted_start_time_datetime_utc
	print "Job End Time: %s" % job.end_time
	print "Job End Time (Local): %s" % job.end_time_datetime_local
	print "Job End Time (Zulu): %s" % job.end_time_datetime_utc
	print "Job Resource Usage Last Update Time: %s" % job.resource_usage_last_update_time
	print "Job Resource Usage Last Update Time (Local): %s" % job.resource_usage_last_update_time_datetime_local
	print "Job Resource Usage Last Update Time (Zulu): %s" % job.resource_usage_last_update_time_datetime_utc
	print "Residual Memory: %sKB" % job.resource_usage.resident_memory_usage
	print "Swap: %sKB" % job.resource_usage.virtual_memory_usage
	print "User Time: %s Seconds" % job.resource_usage.user_time
	print "User Time: (timedelta) %s" % job.resource_usage.user_time_timedelta
	print "System Time: %s Seconds" % job.resource_usage.system_time
	print "System Time: (timedelta) %s" % job.resource_usage.system_time_timedelta
	print "Number of active processes %s" % job.resource_usage.num_active_processes
	for p in job.resource_usage.active_processes:
		print "Process ID: %d" % p.process_id
		print "Parent Process ID: %d" % p.parent_process_id
		print "Process Group ID: %d" % p.group_id
		print "Cray Job ID: %d" % p.cray_job_id
	print "Number of active process groups %s" % job.resource_usage.num_active_process_groups
	for g in job.resource_usage.active_process_groups:
		print "Process Group: %d" % g
	
	print "Submit Options: %d" % job.submit.options
	print "Submit Options2: %d" % job.submit.options2
	print "Submit Job Name: %s" % job.submit.job_name
	print "Submit Queue Name: %s" % job.submit.queue_name
	print "Submit Num Asked Hosts: %s" % job.submit.num_asked_hosts
	for i in job.submit.asked_hosts:
		print "Asked for host: %s" % i
	print "Submit Requested Resources : %s" % job.submit.requested_resources
	print "Submit Host Spec: %s" % job.submit.host_specification
	print "Submit num procs: %s" % job.submit.num_processors
	print "Submit Dependency Conditions: %s" % job.submit.dependency_condition
	print "Submit Begin Time: %s" % job.submit.begin_time
	print "Submit Begin Time Local: %s" % job.submit.begin_time_datetime_local
	print "Submit Begin Time Zulu: %s" % job.submit.begin_time_datetime_utc
	print "Submit Termination Time: %s" % job.submit.termination_time
	print "Submit Termination Time Local: %s" % job.submit.termination_time_datetime_local
	print "Submit Termination Time Zulu: %s" % job.submit.termination_time_datetime_utc
	print "Submit Signal Value: %s" % job.submit.signal_value
	print "Submit Input File: %s" % job.submit.input_file
	print "Submit Output File: %s" % job.submit.output_file
	print "Submit Error File: %s" % job.submit.error_file
	print "Submit Command: %s" % job.submit.command
	#print "Submit New Command: %s" % job.submit.new_command
	print "Submit Checkpoint Period: %s" % job.submit.checkpoint_period
	print "Submit Checkpoint Directory: %s" % job.submit.checkpoint_dir
	print "Submit Num Files to Transfer: %s" % job.submit.num_transfer_files
	for f in job.submit.transfer_files:
		print "Transfer: %s to %s with options %s" % (f.submission_file_name, f.execution_file_name, f.options)
	print "Submit Pre Execution Command: %s" % job.submit.pre_execution_command
	print "Submit Email User: %s" % job.submit.email_user
	print "Submit Delete Options: %s" % job.submit.delete_options
	print "Submit Delete Options 2:: %s" % job.submit.delete_options2
	print "Submit Project Name: %s" % job.submit.project_name
	print "Submit Max Num Processors: %s" % job.submit.max_num_processors
	print "Submit login shell: %s" % job.submit.login_shell
	print "Submit user priority: %s" % job.submit.user_priority
	for r in job.pend_reasons:
		print "Pending due to: %d: %s on %d hosts" % (r,r,r.count)

