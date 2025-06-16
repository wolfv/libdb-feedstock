#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./dist
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/odbc
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/jdbc
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/sqlite
cp $BUILD_PREFIX/share/gnuconfig/config.* ./lang/sql/sqlite/autoconf

if [[ $(uname) == Darwin ]]; then
  export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
fi

cd build_unix
../dist/configure --prefix=$PREFIX \
                  --enable-shared \
                  --disable-static \
                  --enable-cxx \
                  --enable-stl

make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check -j$CPU_COUNT
fi
make install DOCLIST=license

cd $PREFIX
find . -type f -name "*.la" -exec rm -rf '{}' \; -print

# On macOS ARM64, check that the library is built for ARM
if [[ $target_platform == "osx-arm64" ]]; then
  if [[ ! -f $PREFIX/lib/libdb.dylib ]]; then
    echo "libdb.dylib not found in $PREFIX/lib"
    exit 1
  fi
  lipo -info $PREFIX/lib/libdb.dylib | grep "arm64"
fi