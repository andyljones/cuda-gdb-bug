#!/bin/bash

# Should run fine
cuda-gdb good -ex run -ex quit

# Should crash
cuda-gdb bad -ex run -ex quit
