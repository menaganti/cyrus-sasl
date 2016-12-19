#!/bin/bash

if [[ -z "${SVN_PATH}" || -z "${SVN_BRANCH_PATH}" ]]; then
    echo "SVN_PATH not set. source build_env.sh from the svn/trunk directory."
    exit -1
fi
HOST_DIRECTORY="/home/buildUser/work/dge200/cyrus-sasl/output/host"

NATIVE_DIRECTORY=native
if [[ ! -d ${NATIVE_DIRECTORY} ]]; then
  mkdir native
fi

# backout changes needed for target compiler
export CPPFLAGS="-DWHCHG"
export CFLAGS="-DWHCHG"
export CXXFLAGS="-DWHCHG"

cd native
echo "starting configure"
../configure --prefix=${HOST_DIRECTORY} --host=x86_64-unknown-linux-gnu --build=x86_64-unknown-linux-gnu --target=arm-linux

echo "starting build"
cd include
make
cd ..

cd ..

if [[ ! -d ${HOST_DIRECTORY}/bin ]]; then
  if [[ ! -d "/home/buildUser/work" ]]; then
      mkdir /home/buildUser/work
  fi
  if [[ ! -d "/home/buildUser/work/dge200" ]]; then
      mkdir /home/buildUser/work/dge200
  fi
  if [[ ! -d "/home/buildUser/work/dge200/cyrus-sasl" ]]; then
      mkdir /home/buildUser/work/dge200/cyrus-sasl
  fi
  if [[ ! -d "/home/buildUser/work/dge200/cyrus-sasl/output" ]]; then
      mkdir /home/buildUser/work/output
  fi
  if [[ ! -d "/home/buildUser/work/dge200/cyrus-sasl/output/host" ]]; then
      mkdir /home/buildUser/work/output/host
  fi
  mkdir ${HOST_DIRECTORY}/bin
fi
if [[ ! -d ${HOST_DIRECTORY}/lib ]]; then
  mkdir ${HOST_DIRECTORY}/lib
fi
cp native/include/makemd5 /home/buildUser/work/dge200/cyrus-sasl/output/host/bin/
