from pylava import OpenLava

f=OpenLava("Masdf")
print "Cluster name: %s" % f.get_cluster_name()
print "Master host name: %s" %f.get_master_name()
f.open_job_info(job_id=2838)
job= f.read_job_info()
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
