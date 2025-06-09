#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./dist

if [[ $(uname) == Darwin ]]; then
    export CFLAGS="$CFLAGS -include stddef.h"
    export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
fi

cd build_unix
../dist/configure --prefix=$PREFIX \
                  --enable-shared \
                  --disable-static \
                  --disable-debug \
                  --enable-cxx \
                  --enable-stl \
                  --enable-compat185 \
                  --enable-sql \
                  --enable-sql_codegen \
                  --enable-dbm \


make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
    make check -j${CPU_COUNT}
fi
make install -j${CPU_COUNT} DOCLIST=license

cd $PREFIX
find . -type f -name "*.la" -exec rm -rf '{}' \; -print