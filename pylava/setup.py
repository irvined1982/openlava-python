from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
	name="python-lava",
	version="0.1",
	description="Bindings for OpenLava",
	author="David Irvine",
	author_email="irvined@gmail.com",
    cmdclass = {'build_ext': build_ext},
	packages=['openlava'],
    ext_modules = [
		Extension("pylava", ["pylava.pyx"],
			extra_objects=['/opt/openlava/lib/liblsf.a','/opt/openlava/lib/liblsbatch.a'],
			libraries=['lsf','lsbatch','nsl']
			)
		]
)


