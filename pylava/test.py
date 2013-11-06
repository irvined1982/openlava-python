from pylava import OpenLava,JobList
import pylava

f=OpenLava("Masdf")
print "Cluster name: %s" % f.get_cluster_name()
print "Master host name: %s" %f.get_master_name()
print  f.get_jobs(job_id=2836)

