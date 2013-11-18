from pylava import OpenLava
class OpenLavaConnection:
	connection=None
	@staticmethod
	def get_connection():
		if not OpenLavaConnection.connection:
			OpenLavaConnection.connection=OpenLava("openlava python")
		return OpenLavaConnection.connection
	def __init__(self):
		raise ValueError("Do not use this")

