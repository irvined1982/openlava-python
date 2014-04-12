# Copyright 2013 David Irvine
#
# This file is part of openlava-python
#
# openlava-python is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# openlava-python is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with openlava-python.  If not, see <http://www.gnu.org/licenses/>.
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


def scandir(dir, files=[]):
	for file in os.listdir(dir):
		path = os.path.join(dir, file)
		if os.path.isfile(path) and path.endswith(".pyx"):
			files.append(path.replace(os.path.sep, ".")[:-4])
		elif os.path.isdir(path):
			scandir(path, files)
	return files

def makeExtension(extName):
	extPath = extName.replace(".", os.path.sep)+".pyx"
	return Extension(
			extName,
			[extPath],
			extra_compile_args = ["-O3", "-Wall"],
			extra_link_args = ['-g'],
			extra_objects=[lsf, lsbatch],
			libraries=['lsf','lsbatch','nsl'],
			include_dirs=[inc_dir,"."],
			library_dirs=[lib_dir],
			)




setup(
	extra_compile_args=["-g"],
	name="openlava-bindings",
	version="1.0",
	description="Bindings for OpenLava",
	author="David Irvine",
	author_email="irvined@gmail.com",
	url="https://github.com/irvined1982/openlava-python",
	license="GPL 3",
    cmdclass = {'build_ext': build_ext},
    ext_modules = [makeExtension(name) for name in scandir("openlava")],
	packages=['openlava'],
	classifiers=[
			'Programming Language :: Python',
			'Programming Language :: Python :: 2',
			'Programming Language :: Python :: 2.7',
			'Intended Audience :: Science/Research',
			'Intended Audience :: System Administrators',
			'Topic :: Scientific/Engineering',
			],
)

