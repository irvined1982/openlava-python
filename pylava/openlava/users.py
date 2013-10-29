from openlava.connection import OpenLavaConnection

def get_all_users():
	lava=OpenLavaConnection.get_connection()
	return lava.get_user_info()
def get_user_by_name(name):
	lava=OpenLavaConnection.get_connection()
	users=lava.get_user_info(user_names=[name])
	if len(users) != 1:
		raise ValueError("User Not Found")
	return users[0]

