from openlava.connection import OpenLavaConnection

def get_all_queues():
	lava=OpenLavaConnection.get_connection()
	return lava.get_queue_info()
def get_queue_by_name(name):
	lava=OpenLavaConnection.get_connection()
	queues=lava.get_queue_info(queue_names=[name])
	if len(queues) != 1:
		raise ValueError("Queue Not Found")
	return queues[0]

