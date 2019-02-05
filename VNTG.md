# Compile Me Script...

VNTG_PREFIX="/opt/vntg/"


######
PACKAGE_NAME="libressl"
PACKAGE_VERSION="2.9.0"
CONFIGURE_FLAGS="--enable-nc"
CONFIGURE_64="./configure --prefix=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION --libdir=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION/lib64 $CONFIGURE_FLAGS"
CONFIGURE_32="./configure --prefix=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION --libdir=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION/lib $CONFIGURE_FLAGS"

$CONFIGURE_64
make
make install

#####
PACKAGE_NAME="openssh"
PACKAGE_VERSION="7.9p1"
CONFIGURE_FLAGS="--with-ssl-dir=/opt/vntg/packages/libressl/2.9.0/ --with-pam --with-xauth"
CONFIGURE_64="./configure --prefix=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION --libdir=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION/lib64 $CONFIGURE_FLAGS"
CONFIGURE_32="./configure --prefix=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION --libdir=$VNTG_PREFIX/packages/$PACKAGE_NAME/$PACKAGE_VERSION/lib $CONFIGURE_FLAGS"



# SET 64-bit (n64) compiler options
# SET 32-bit (n32) compiler options

mkdir -p /opt/vntg/etc/
mkdir -p /opt/vntg/bin/
mkdir -p /opt/vntg/sbin/
mkdir -p /opt/vntg/lib/
mkdir -p /opt/vntg/lib/pkgconfig/
mkdir -p /opt/vntg/libexec/
mkdir -p /opt/vntg/include/
mkdir -p /opt/vntg/share/info/
mkdir -p /opt/vntg/share/aclocal/
mkdir -p /opt/vntg/share/man/man1/
mkdir -p /opt/vntg/share/man/man3/
mkdir -p /opt/vntg/share/man/man5/
mkdir -p /opt/vntg/share/man/man8/

export PKG_CONFIG="/opt/vntg/bin/pkg-config"
export LDFLAGS="-L/opt/vntg/lib/"
export CFLAGS="-I/opt/vntg/include/"
export CXXFLAGS=$CFLAGS
export LD_LIBRARY_PATH='/opt/vntg/lib'
export LDFLAGS='-L/opt/vntg/lib'

# package: pkg-config-0.29.2
# source: https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
# deps: NONE
export PACKAGE=pkg-config-0.29.2
mkdir -p /opt/vntg/packages/pkg-config-0.29.2
PKG_CONFIG=${PKG_CONFIG} LDFLAGS=${LDFLAGS} CFLAGS=${CFLAGS} ./configure --with-pc-path=/opt/vntg/lib/pkgconfig/
make 
make install
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/


# package: make-4.2.1
# source: https://ftp.gnu.org/gnu/make/make-4.2.1.tar.gz
# deps: NONE
export PACKAGE=make-4.2.1
mkdir -p /opt/vntg/packages/make-4.2.1
PKG_CONFIG=${PKG_CONFIG} LDFLAGS=${LDFLAGS} CFLAGS=${CFLAGS} ./configure --prefix=/opt/vntg/packages/${PACKAGE}
make
make install
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/

# package: zlib-1.2.11
# source: https://www.zlib.net/zlib-1.2.11.tar.gz
# deps: NONE
export PACKAGE=zlib-1.2.11
mkdir -p /opt/vntg/packages/zlib-1.2.11
PKG_CONFIG=${PKG_CONFIG} LDFLAGS=${LDFLAGS} CFLAGS=${CFLAGS} ./configure --prefix=/opt/vntg/packages/${PACKAGE}
make 
make install
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/


# package: libidn2-2.1.0
# source: https://ftp.gnu.org/gnu/libidn/libidn2-2.1.0.tar.gz
# deps: NONE
export PACKAGE=libidn2-2.1.0
mkdir -p /opt/vntg/packages/libidn2-2.1.0
PKG_CONFIG=${PKG_CONFIG} LDFLAGS=${LDFLAGS} CFLAGS=${CFLAGS} ./configure --prefix=/opt/vntg/packages/${PACKAGE}
make 
make install
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/


# package: sudo-1.8.27
# source: https://www.sudo.ws/dist/sudo-1.8.27.tar.gz
# deps: NONE
mkdir -p /opt/vntg/packages/sudo-1.8.27
./configure --prefix=/opt/vntg/packages/sudo-1.8.27
make
make install
export PACKAGE=sudo-1.8.27
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/

# package:libtasn1-4.13
# source: https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz
# deps: NONE
mkdir -p /opt/vntg/packages/libtasn1-4.13
./configure --prefix=/opt/vntg/packages/libtasn1-4.13
make 
make install
export PACKAGE=libtasn1-4.13
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/


# package: libressl-2.8.3
# source: https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.8.3.tar.gz
# deps: NONE
mkdir -p /opt/vntg/packages/libressl-2.8.3
./configure --prefix=/opt/vntg/packages/libressl-2.8.3
make
make install
export PACKAGE=libressl-2.8.3
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/


# package: openssh-7.9p1
# source: https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.9p1.tar.gz
# deps: libressl-2.8.3, zlib-1.2.11
mkdir -p /opt/vntg/packages/openssh-7.9p1
./configure --prefix=/opt/vntg/packages/openssh-7.9p1/ --with-zlib=/opt/vntg/packages/zlib-1.2.11/ --with-ssl-dir=/opt/vntg/packages/libressl-2.8.3
make 
make install
export PACKAGE=openssh-7.9p1
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/



# package: curl-7.63.0
# source: https://curl.haxx.se/download/curl-7.63.0.tar.gz
# deps: libressl-2.8.3, zlib-1.2.11, libidn2-2.1.0,
mkdir -p /opt/vntg/packages/curl-7.63.0
./configure --prefix=/opt/vntg/packages/curl-7.63.0 --enable-ipv6 --with-ssl=/opt/vntg/packages/libressl-2.8.3 --with-libssh2=/opt/vntg/packages/openssh-7.9p1 --with-zlib=/opt/vntg/packages/zlib-1.2.11/ --with-libidn2=/opt/vntg/packages/libidn2-2.1.0 --with-ca-bundle=/opt/vntg/packages/libressl-2.8.3/etc/ssl/cert.pem --enable-tls-srp
make
make install
export PACKAGE=curl-7.63.0
[ -d /opt/vntg/packages/${PACKAGE}/etc ]            && ln -s /opt/vntg/packages/${PACKAGE}/etc/*            /opt/vntg/etc/
[ -d /opt/vntg/packages/${PACKAGE}/bin ]            && ln -s /opt/vntg/packages/${PACKAGE}/bin/*            /opt/vntg/bin/
[ -d /opt/vntg/packages/${PACKAGE}/sbin ]           && ln -s /opt/vntg/packages/${PACKAGE}/sbin/*           /opt/vntg/sbin/
[ -d /opt/vntg/packages/${PACKAGE}/lib ]            && ln -s /opt/vntg/packages/${PACKAGE}/lib/*            /opt/vntg/lib/
[ -d /opt/vntg/packages/${PACKAGE}/lib/pkgconfig ]  && ln -s /opt/vntg/packages/${PACKAGE}/lib/pkgconfig/*  /opt/vntg/lib/pkgconfig/
[ -d /opt/vntg/packages/${PACKAGE}/libexec ]        && ln -s /opt/vntg/packages/${PACKAGE}/libexec/*        /opt/vntg/libexec/
[ -d /opt/vntg/packages/${PACKAGE}/share/info ]     && ln -s /opt/vntg/packages/${PACKAGE}/share/info/*     /opt/vntg/share/info/
[ -d /opt/vntg/packages/${PACKAGE}/share/aclocal ]  && ln -s /opt/vntg/packages/${PACKAGE}/share/aclocal/*  /opt/vntg/share/aclocal/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man1 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man1/* /opt/vntg/share/man/man1/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man3 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man3/* /opt/vntg/share/man/man3/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man5 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man5/* /opt/vntg/share/man/man5/
[ -d /opt/vntg/packages/${PACKAGE}/share/man/man8 ] && ln -s /opt/vntg/packages/${PACKAGE}/share/man/man8/* /opt/vntg/share/man/man8/



# package: git-2.20.1
# source: https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.20.1.tar.gz
# deps:
mkdir -p /opt/vntg/packages/git-2.20.1
./configure --prefix=/opt/vntg/packages/git-2.20.1








