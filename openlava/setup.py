import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

# Find lsbatch
try:
	lsfdir=os.environ['LSF_ENVDIR']
	lsfdir=os.path.join(libdir,"..")

except:
	lsfdir='/opt/openlava'

lsf=os.path.join(lsfdir, "lib", "liblsf.a")
lsbatch=os.path.join(lsfdir, "lib", "liblsbatch.a")

inc_dir=os.path.join(lsfdir,"include")
lib_dir=os.path.join(lsfdir,"lib")

if not os.path.exists(lsf):
	raise ValueError("Cannot find liblsf.a")
if not os.path.exists(lsbatch):
	raise ValueError("Cannot find lsbatch.a")


setup(
	name="openlava",
	version="1.0",
	description="Bindings for OpenLava",
	author="David Irvine",
	author_email="irvined@gmail.com",
    cmdclass = {'build_ext': build_ext},
    ext_modules = [
		Extension("openlava", ["openlava.pyx"],
			extra_objects=[lsf, lsbatch],
			libraries=['lsf','lsbatch','nsl'],
			include_dirs=[inc_dir],
			library_dirs=[lib_dir],
			)
		]
)


