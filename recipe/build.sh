cp $BUILD_PREFIX/share/gnuconfig/config.* ./dist
export CFLAGS="${CFLAGS} -Wno-implicit-function-declaration"

# BerkeleyDB requires you to build everything from the build_unix subdirectory
cd build_unix
../dist/configure \
    --disable-static \
    --prefix=$PREFIX \
    --mandir=$PREFIX/share/man \
    --enable-cxx \
    --enable-dbm

make
make install DOCLIST=license

# use the standard docs location
mkdir -p $PREFIX/share/doc
mv $PREFIX/docs $PREFIX/share/doc/berkeley-db