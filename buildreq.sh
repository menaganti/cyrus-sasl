echo "starting build"
cp /home/buildUser/work/android/output/host/bin/makemd5 /home/buildUser/work/android/cyrus-sasl-2.1.26/build/include/
cd build
#cd include
#make
#cd ..
cd lib
#make SUBDIRS="lib java plugins saslauthd sasldb utils"
cd ..
cd java 
make all
cd ..
cd saslauthd 
make
cd ..
cd sasldb
make
cd ..
