#!/bin/bash

if [[ -z "${SVN_PATH}" || -z "${SVN_BRANCH_PATH}" ]]; then
    echo "SVN_PATH not set. source build_env.sh from the svn/trunk directory."
    exit -1
fi

#export CC="/opt/buildroot/output/host/usr/bin/arm-linux-gcc"

export OUTPUT_DIRECTORY="/home/buildUser/work/dge200/output/arm-linux"

export BUILDROOT_OUTPUT="/opt/buildroot/output"
export ARM_SYSROOT="$BUILDROOT_OUTPUT/host/usr/arm-buildroot-linux-gnueabi/sysroot"
#export OPENSSL_INCLUDE="$ARM_SYSROOT/usr/include/openssl"
export GSSAPI_INCLUDE="/home/buildUser/work/dge200/krb5-1.14.4/build-arm-linux/include"

export PATH="$BUILDROOT_OUTPUT/host/usr/bin:$PATH"

export CPPFLAGS="--sysroot=$ARM_SYSROOT -I$OUTPUT_DIRECTORY/include -I$GSSAPI_INCLUDE -I$GSSAPI_INCLUDE/gssapi"
export CFLAGS="--sysroot=$ARM_SYSROOT -I$OUTPUT_DIRECTORY/include -I$GSSAPI_INCLUDE -I$GSSAPI_INCLUDE/gssapi"
export CXXFLAGS="--sysroot=$ARM_SYSROOT -I$OUTPUT_DIRECTORY/include -I$GSSAPI_INCLUDE -I$GSSAPI_INCLUDE/gssapi"

#export LDFLAGS="-L$OUTPUT_DIRECTORY/lib -L$BUILDROOT_OUTPUT/target/usr/lib"
#export LIBS="-L$BUILDROOT_OUTPUT/target/usr/lib -L$OUTPUT_DIRECTORY/lib -lcrypto -ldb-6.1"
export LIBS="-L$BUILDROOT_OUTPUT/target/usr/lib -L$OUTPUT_DIRECTORY/lib -lgssapi_krb5 -lkrb5 -lk5crypto -lkrb5support -lcom_err -Wl,-rpath-link,$OUTPUT_DIRECTORY/lib -Wl,-rpath,/lib -Wl,-Map=output.map"

echo $PATH
echo $ARM_SYSROOT
echo $CPPFLAGS
echo $CFLAGS
echo $CXXFLAGS
echo $LDFLAGS
echo $LIBS

export BUILD_DIRECTORY=build-arm-linux
ifeq "$(wildcard $(BUILD_DIRECTORY) )" ""
  mkdir build-arm-linux
endif

cd $BUILD_DIRECTORY
echo "Start configure..."
#../configure --prefix=${OUTPUT_DIRECTORY} --host=arm-linux-gnueabi --build=x86_64-unknown-linux-gnu --enable-gssapi --enable-ntlm --with-dblib=berkeley
../configure --enable-ntlm --prefix=${OUTPUT_DIRECTORY} --enable-shared=yes --enable-pthread-support=no --enable-littleendian --disable-privsep --enable-hardening=no --host=arm-linux --build=x86_64-unknown-linux-gnu --with-xml=no --with-sysroot=$ARM_SYSROOT --with-lib-subdir=$BUILDROOT_OUTPUT/target/usr/lib --with-lib-subdir=$OUTPUT_DIRECTORY/lib

if [[ ! -d ${OUTPUT_DIRECTORY}/bin ]]; then
  if [[ ! -d "/home/buildUser/work/dge200/output" ]]; then
      mkdir /home/buildUser/work/dge200/output
  fi
  if [[ ! -d "/home/buildUser/work/dge200/output/arm-linux" ]]; then
      mkdir /home/buildUser/work/dge200/output/arm-linux
  fi
  mkdir ${OUTPUT_DIRECTORY}/bin
fi
if [[ ! -d ${OUTPUT_DIRECTORY}/lib ]]; then
  mkdir ${OUTPUT_DIRECTORY}/lib
fi


echo "Start build...."
make

echo "Start install...."
make install

cd ..
