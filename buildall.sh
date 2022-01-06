#!/bin/sh
# Copyright (C) 2022 Free Software Foundation, Inc.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

# Helper script to check if everything builds for the supported
# architectures.  To use either set TOOLCHAIN to a path containing the
# toolchain built with build-many-glibcs.py from GLIBC.

ARCHS="\
aarch64
alpha
arc
arm
csky
hppa
i386
ia64
m68k
microblaze
mips64
nios2
powerpc64le
powerpc
or1k
riscv32
riscv64
s390
s390x
sh
sparcv9
sparc64
x86_64"

P=$PWD
TOOLCHAIN=${TOOCHAIN:-$HOME/toolchain/install/compilers}

rm -rf $P/build

for arch in $ARCHS; do
  origarch=$arch
  cflags=""
  suffix=""
  case "$arch" in
  arc)     target=arc-linux-gnuhf
           suffix=gnuhf ;;
  arm)     target=arm-linux-gnueabihf
	   suffix=gnueabihf ;;
  csky)    target=csky-linux-gnuabiv2
	   suffix=gnuabiv2 ;;
  i386)    target=x86_64-linux-gnu
	   clags="-m32"
	   suffix=gnu
	   arch=x86_64 ;;
  s390)    target=s390x-linux-gnu
	   cflags="-m31"
	   suffix=gnu
	   arch=s390x ;;
  or1k)    target=or1k-linux-gnu-soft
	   suffix=gnu ;;
  sh)      target=sh4-linux-gnu
	   suffix=gnu
           arch=sh4 ;;
  sparcv9) target=sparc64-linux-gnu
           cflags="-m32"
	   suffix=gnu
	   arch=sparc64 ;;
  riscv32) target=riscv32-linux-gnu-rv32imafdc-ilp32d
  	   suffix=gnu ;;
  riscv64) target=riscv64-linux-gnu-rv64imafdc-lp64d
	   suffix=gnu ;;
  *)       target=$arch-linux-gnu
	   suffix=gnu ;;
  esac

  mkdir -p $P/build/$origarch && cd $P/build/$origarch
  $P/configure \
    --target=$target \
    CFLAGS=$cflags \
    CROSS_COMPILE=$TOOLCHAIN/$target/bin/$arch-glibc-linux-$suffix- \
    2>&1 > configure.log
  if [ $? -ne 0 ]; then
    echo "FAIL: configure: $origarch"
  fi

  make 2>&1 > make.log
  if [ $? -ne 0 ]; then
    echo "FAIL: make: $origarch"
    exit 1
  fi
done
