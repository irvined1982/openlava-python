#cdef extern from "lsf.h":
#	extern int lserrno

cdef extern from "lsbatch.h":
	extern int lsb_init (char *appName)
	extern char *ls_getclustername()
	extern char *ls_getmastername()
	extern int lsb_openjobinfo (long, char *, char *, char *, char *,int)
	

