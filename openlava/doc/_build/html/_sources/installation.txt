Installation
============
Installation is done as follows:

#. Download or Clone the repository:

   #. `Download Zip <https://github.com/irvined1982/openlava-python/archive/master.zip>`_
   #. git clone https://github.com/irvined1982/openlava-python.git::

        $ git clone https://github.com/irvined1982/openlava-python.git
        Cloning into 'openlava-python'...
        remote: Reusing existing pack: 412, done.
        remote: Total 412 (delta 0), reused 0 (delta 0)
        Receiving objects: 100% (412/412), 2.22 MiB | 317 KiB/s, done.
        Resolving deltas: 100% (282/282), done.
        $

#. Enter the openlava directory::

   $ cd openlava-python/openlava/

#. Run setup install::

    $ python setup.py install
    running install
    running build
    running build_py
    creating build
    creating build/lib.linux-x86_64-2.7
    creating build/lib.linux-x86_64-2.7/openlava
    copying openlava/__init__.py -> build/lib.linux-x86_64-2.7/openlava
    running build_ext
    skipping 'openlava/lslib.c' Cython extension (up-to-date)
    building 'openlava.lslib' extension
    creating build/temp.linux-x86_64-2.7
    creating build/temp.linux-x86_64-2.7/openlava
    gcc -pthread -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fPIC -I/opt/openlava/include -I. -I/usr/include/python2.7 -c openlava/lslib.c -o build/temp.linux-x86_64-2.7/openlava/lslib.o -O3 -Wall
    gcc -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-Bsymbolic-functions -Wl,-z,relro build/temp.linux-x86_64-2.7/openlava/lslib.o /opt/openlava/lib/liblsf.a /opt/openlava/lib/liblsbatch.a -L/opt/openlava/lib -llsf -llsbatch -lnsl -o build/lib.linux-x86_64-2.7/openlava/lslib.so -g
    skipping 'openlava/lsblib.c' Cython extension (up-to-date)
    building 'openlava.lsblib' extension
    gcc -pthread -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fPIC -I/opt/openlava/include -I. -I/usr/include/python2.7 -c openlava/lsblib.c -o build/temp.linux-x86_64-2.7/openlava/lsblib.o -O3 -Wall
    openlava/lsblib.c: In function ‘__pyx_pf_8openlava_6lsblib_6Submit_1_modify’:
    openlava/lsblib.c:13338:13: warning: variable ‘__pyx_v_reply’ set but not used [-Wunused-but-set-variable]
    openlava/lsblib.c: In function ‘__pyx_pf_8openlava_6lsblib_11JobInfoHead_6jobIds___get__’:
    openlava/lsblib.c:19465:3: warning: statement with no effect [-Wunused-value]
    openlava/lsblib.c: In function ‘__pyx_pf_8openlava_6lsblib_11JobInfoHead_9hostNames___get__’:
    openlava/lsblib.c:19627:3: warning: statement with no effect [-Wunused-value]
    gcc -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-Bsymbolic-functions -Wl,-z,relro build/temp.linux-x86_64-2.7/openlava/lsblib.o /opt/openlava/lib/liblsf.a /opt/openlava/lib/liblsbatch.a -L/opt/openlava/lib -llsf -llsbatch -lnsl -o build/lib.linux-x86_64-2.7/openlava/lsblib.so -g
    running install_lib
    copying build/lib.linux-x86_64-2.7/openlava/lsblib.so -> /usr/local/lib/python2.7/dist-packages/openlava
    copying build/lib.linux-x86_64-2.7/openlava/__init__.py -> /usr/local/lib/python2.7/dist-packages/openlava
    copying build/lib.linux-x86_64-2.7/openlava/lslib.so -> /usr/local/lib/python2.7/dist-packages/openlava
    byte-compiling /usr/local/lib/python2.7/dist-packages/openlava/__init__.py to __init__.pyc
    running install_egg_info
    Removing /usr/local/lib/python2.7/dist-packages/openlava_bindings-1.0.egg-info
    Writing /usr/local/lib/python2.7/dist-packages/openlava_bindings-1.0.egg-info
    $

#. Test that openlava-python is working correctly::

    $ python
    Python 2.7.3 (default, Sep 26 2013, 20:03:06) 
    [GCC 4.6.3] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>> from openlava import lslib
    >>> lslib.ls_getclustername()
    u'openlava'
    >>> 

