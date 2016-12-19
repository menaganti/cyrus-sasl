#!/bin/bash

if [[ -z "${SVN_PATH}" || -z "${SVN_BRANCH_PATH}" ]]; then
    echo "SVN_PATH not set. source build_env.sh from the svn/trunk directory."
    exit -1
fi

export HOSTCC="/opt/omap_jb/src/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.7-4.6/bin/x86_64-linux-gcc"
export BERKELEY_DIR="/home/buildUser/work/output/berkeley"
export HEIMDAL_DIR="/home/buildUser/work/heimdal/build"
export GSSAPI_DIR="/home/buildUser/work/heimdal/build/include/gssapi"
export OPENSSL_INCLUDE="/home/buildUser/Android_omap_jb/trunk/customFiles/src/external/openssl/include"
export PATH="$PATH:${ANDROID_PARENT}/src/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin"
export ANDROID_SYSROOT="${ANDROID_PARENT}/src/prebuilts/ndk/8/platforms/android-14/arch-arm"

export CPPFLAGS="--sysroot=$ANDROID_SYSROOT -Dcrypt=DES_crypt -I$OPENSSL_INCLUDE -I/home/buildUser/work/android/output/berkeley/include -I../../../build/include -I/home/buildUser/work/heimdal/build/include"
export CFLAGS="--sysroot=$ANDROID_SYSROOT -Dcrypt=DES_crypt -I$OPENSSL_INCLUDE -I/home/buildUser/work/android/output/berkeley/include -I../../../build/include -I/home/buildUser/work/heimdal/build/include"
export CXXFLAGS="--sysroot=$ANDROID_SYSROOT -Dcrypt=DES_crypt -I$OPENSSL_INCLUDE -I/home/buildUser/work/android/output/berkeley/include -I../../../build/include -I/home/buildUser/work/heimdal/build/include"

export LDFLAGS="-L/opt/omap_jb/src/out/target/product/panda5/system/lib -L/home/buildUser/work/android/output/berkeley/lib -L/home/buildUser/work/output/target/lib"
#export LIBS="-L/opt/omap_jb/src/out/target/product/panda5/system/lib -lcrypto -L/home/buildUser/work/android/output/berkeley/lib -L/home/buildUser/work/output/target/libi -lgssapi"
export LIBS="-lcrypto -lgssapi"

echo $PATH
echo $ANDROID_SYSROOT
echo $CPPFLAGS
echo $CFLAGS
echo $CXXFLAGS

BUILD_DIRECTORY=build
ifeq "$(wildcard $(BUILD_DIRECTORY) )" ""
  mkdir build
endif
cd build

#../configure --prefix=/home/buildUser/work/android/output/target  --disable-cram --disable-digest --disable-otp --disable-krb4 --enable-gssapi --enable-ntlm --with-dblib=berkeley --enable-pthread-support=no --enable-littleendian --disable-privsep --enable-hardening=no --host=arm-linux-androideabi --build=x86_64-unknown-linux-gnu --target=arm-linux-androideabi --with-xml=no --with-sysroot=$ANDROID_SYSROOT --with-lib-subdir=/opt/omap_jb/src/out/target/product/panda5/system/lib

../configure --prefix=/home/buildUser/work/android/output/target --enable-pthread-support=no --enable-littleendian --disable-privsep --enable-hardening=no --host=arm-linux-androideabi --build=x86_64-unknown-linux-gnu --with-xml=no --with-sysroot=$ANDROID_SYSROOT --with-lib-subdir=/opt/omap_jb/src/out/target/product/panda5/system/lib --enable-digest=no --enable-gssapi=yes --enable-ntlm=yes --without-saslauthd
#cp ../native/include/makemd5 /home/buildUser/work/android/cyrus-sasl-2.1.26/build/include/
#Compile
make

make install

cd ..

