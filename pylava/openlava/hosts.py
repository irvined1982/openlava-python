from openlava.connection import OpenLavaConnection

def get_all_hosts():
	lava=OpenLavaConnection.get_connection()
	return lava.get_host_info()
def get_host_by_name(name):
	lava=OpenLavaConnection.get_connection()
	hosts=lava.get_host_info(host_names=[name])
	if len(hosts) != 1:
		raise ValueError("Host Not Found")
	return hosts[0]

