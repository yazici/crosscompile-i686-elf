# escape=`

FROM ubuntu

#Add necessary files to image
ADD toolchain/binutils-2.29.tar.gz /root/src/
ADD toolchain/gcc-7.2.0.tar.gz /root/src/

RUN apt-get update && apt-get upgrade; `
apt-get -y install make; `
apt-get -y install texinfo; `
apt-get -y install build-essential; `
apt-get -y install nasm; `
apt-get -y install gcc; `
apt-get -y install g++; `
apt-get -y install bison; `
apt-get -y install flex; `
apt-get -y install gmp; `
apt-get -y install mpfr; `
apt-get -y install mpc; `
apt-get -y install libisl15; `
apt-get -y install cloog-isl; `
apt-get -y install libgmp3-dev; `
apt-get -y install libgmp-dev; `
apt-get -y install libisl-dev; `
apt-get -y install libcloog-isl-dev; `
apt-get -y install libmpc-dev; `
apt-get -y install grub2; `
apt-get -y install xorriso

#Preparation
ENV PREFIX $HOME/opt/cross
ENV TARGET i686-elf
ENV PATH $PREFIX/bin:$PATH

#Binutils
RUN echo Building binutils; `
cd $HOME/src; `
mkdir build-binutils; `
cd build-binutils; `
../binutils-2.29/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror; `
make; `
make install; `

#GCC
cd $HOME/src; `
 
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH; `
 
mkdir build-gcc; `
cd build-gcc; `
../gcc-7.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers; `
make all-gcc; `
make all-target-libgcc; `
make install-gcc; `
make install-target-libgcc

RUN echo Removing source files...; `
rm -rf /root/src