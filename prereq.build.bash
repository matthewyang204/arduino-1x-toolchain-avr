#!/bin/bash -ex
# Copyright (c) 2014-2015 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

source build.conf

if [[ ! -d toolsdir  ]] ;
then
	echo "You must first build the tools: run build_tools.bash"
	exit 1
fi

cd toolsdir/bin
TOOLS_BIN_PATH=`pwd`
cd -

export PATH="$TOOLS_BIN_PATH:$PATH"

HOST="aarch64-apple-darwin"

mkdir -p hostlibs
cd hostlibs
HOSTLIBS=`pwd`
cd ..


if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi


if [[ ! -f gmp-${GMP_VERSION}.tar.bz2  ]] ;
then
	wget ${GMP_SOURCE}
fi

rm -rf gmp gmp-build
tar xf gmp-${GMP_VERSION}.tar.bz2
mv gmp-${GMP_VERSION} gmp

GMPARGS=" \
	--prefix=$HOSTLIBS \
	--host=$HOST \
	--build=$HOST \
	--disable-shared"


mkdir -p gmp-build
cd gmp-build
../gmp/configure $GMPARGS
make -j $MAKE_JOBS
make install
cd ..






if [[ ! -f mpfr-${MPFR_VERSION}.tar.bz2  ]] ;
then
	wget ${MPFR_SOURCE}
fi

rm -rf mpfr mpfr-build
tar xf mpfr-${MPFR_VERSION}.tar.bz2
mv mpfr-${MPFR_VERSION} mpfr

MPFRARGS=" \
	--with-gmp=$HOSTLIBS \
	--prefix=$HOSTLIBS \
	--host=$HOST \
	--build=$HOST \
	--disable-shared"


mkdir -p mpfr-build
cd mpfr-build
../mpfr/configure $MPFRARGS
make -j $MAKE_JOBS
make install
cd ..





if [[ ! -f mpc-${MPC_VERSION}.tar.gz  ]] ;
then
	wget ${MPC_SOURCE}
fi

rm -rf mpc mpc-build
tar xf mpc-${MPC_VERSION}.tar.gz
mv mpc-${MPC_VERSION} mpc


MPCARGS=" \
	--with-gmp=$HOSTLIBS \
	--with-mpfr=$HOSTLIBS \
	--prefix=$HOSTLIBS \
	--host=$HOST \
	--build=$HOST \
	--disable-shared"


mkdir -p mpc-build
cd mpc-build
../mpc/configure $MPCARGS
make -j $MAKE_JOBS
make install
cd ..




