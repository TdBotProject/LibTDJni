#!/usr/bin/env bash

apt update && apt install -y git make zlib1g-dev libssl-dev gperf cmake default-jdk clang libc++-dev libc++abi-dev

cd $1

git submodule update --init --recursive

cd td

mkdir build && cd build

export CXXFLAGS="-stdlib=libc++"

CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=.. \
  -DTD_ENABLE_JNI=ON .. || exit

cmake --build . --target install || exit

cd ../..

mkdir build && cd build

CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX:PATH=../td/tdlib \
  -DTd_DIR:PATH="$(readlink -e ../td/lib/cmake/Td)" .. || exit

cmake --build . --target install || exit

cd ..

mv build/libtdjni.so .
strip libtdjni.so

rm -rf build