from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = [
		Extension("pylava", ["pylava.pyx"],
			extra_objects=['/opt/openlava/lib/liblsf.a','/opt/openlava/lib/liblsbatch.a'],
			libraries=['lsf','lsbatch','nsl']
			)
		]
)


