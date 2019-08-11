This repo has a minimal example of a cuda-gdb/PyTorch bug. The bug is that when running a PyTorch program in cuda-gdb, it crashes with a 
```
cuda-gdb/7.12/gdb/block.c:456: internal-error: set_block_compunit_symtab: Assertion `gb->compunit_symtab == NULL' failed.
```
error. This is demonstrated by the `bad.cu` program. As a contrast, `good.cu` is straight CUDA and works fine.

The minimal example is all in the root folder. The `k8s` subfolder is some scripts I use to run this on my kubernetes cluster, and won't be of use to anyone else.

### Instructions
* (The instructions to build and run the container are the docker equivalents of the kubernetes commands I run. They might be slightly wrong; I don't have the bare-metal access to a GPU needed to test them directly)
* Build the container: `docker build . -t cuda-gdb-bug`
* SSH in: `docker exec -it cuda-gdb-bug /bin/bash`
* Build the example: `ninja`
* Run the example: `./run.sh`
* Expected output:
```
root@driver-5ff8b79c79-l8nqw:/code# ./run.sh 
NVIDIA (R) CUDA Debugger
10.0 release
Portions Copyright (C) 2007-2018 NVIDIA Corporation
GNU gdb (GDB) 7.12
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from good...(no debugging symbols found)...done.
Starting program: /code/good 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7fffef441700 (LWP 96)]
[New Thread 0x7fffeec40700 (LWP 97)]
[New Thread 0x7fffee3be700 (LWP 98)]
(good) x[0]: 2.000000
[Thread 0x7fffee3be700 (LWP 98) exited]
[Thread 0x7fffeec40700 (LWP 97) exited]
[Thread 0x7fffef441700 (LWP 96) exited]
[Inferior 1 (process 87) exited normally]
NVIDIA (R) CUDA Debugger
10.0 release
Portions Copyright (C) 2007-2018 NVIDIA Corporation
GNU gdb (GDB) 7.12
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from bad...(no debugging symbols found)...done.
Starting program: /code/bad 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7fffa6fd5700 (LWP 110)]
[New Thread 0x7fffa67d4700 (LWP 111)]
[New Thread 0x7fffa5f52700 (LWP 112)]
cuda-gdb/7.12/gdb/block.c:456: internal-error: set_block_compunit_symtab: Assertion `gb->compunit_symtab == NULL' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
Quit this debugging session? (y or n) y

This is a bug, please report it.  For instructions, see:
<http://www.gnu.org/software/gdb/bugs/>.

cuda-gdb/7.12/gdb/block.c:456: internal-error: set_block_compunit_symtab: Assertion `gb->compunit_symtab == NULL' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
Create a core file of GDB? (y or n) n
```

### Specs
* Guest: see dockerfile
* Host: Ubuntu 19.04, 2080 Ti RTX

