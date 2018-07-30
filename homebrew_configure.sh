#!/bin/sh

# using static libtre.a requires adding an --enable-static flag to the tre
# formula in /usr/local/Library/Formula/tre.rb

rm -rf build
mkdir build
cd build

cmake \
  -DCMAKE_INSTALL_PREFIX:PATH=~/software/mglib \
  -DMARKDOWN_INCLUDE_DIR:PATH=/usr/local/include \
  -DMARKDOWN_LIBRARY:FILEPATH=/usr/local/lib/libmarkdown.a \
  -DTRE_INCLUDE_DIR:PATH=/usr/local/include \
  -DTRE_LIBRARY:FILEPATH=/usr/local/lib/libtre.a \
  -DGSL_INCLUDE_DIR:PATH=/usr/local/include \
  -DGSL_LIBRARY_DIR:FILEPATH=/usr/local/lib \
  -DZEROMQ_INCLUDE_DIR:PATH=/usr/local/include \
  -DZEROMQ_LIBRARY_DIR:PATH=/usr/local/lib \
  -DIDLdoc_DIR:PATH=~/projects/idldoc/src \
  -Dmgunit_DIR:PATH=~/projects/mgunit/src \
  -Didlwave_DIR:PATH=~/software/idlwave \
  -DPLASMA_INCLUDE_DIR:PATH=~/software/plasma/include \
  -DPLASMA_LIBRARY_DIR:PATH=~/software/plasma/lib \
  -DNETCDF_INCLUDE_DIR:PATH=/usr/local/include \
  -DNETCDF_LIBRARY:PATH=/usr/local/lib/libnetcdf.a \
  -DHDF5_LIBRARY:PATH=/usr/local/lib/libhdf5.a \
  -DHDF5_LA_LIBRARY:PATH=/usr/local/lib/libhdf5_hl.a \
  -DCURL_LIBRARY:PATH=/usr/lib/libcurl.dylib \
  -DSZ_LIBRARY:PATH=/usr/local/lib/libsz.a \
  -DZLIB_LIBRARY:PATH=/usr/lib/libz.dylib \
  ..

