# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Citrix XenServer daemon and tools"
HOMEPAGE="http://www.xensource.com/"
SRC_URI="http://updates.xensource.com/XenServer/5.5.0/debian/pool/main/x/xe-guest-utilities/xe-guest-utilities_5.5.0-458.tar.gz"

MY_PV="${PV/_p*}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="bin custom-cflags static"

DEPEND="sys-devel/gcc
	dev-lang/python
	sys-libs/zlib"

RDEPEND="${CDEPEND}
	|| ( sys-fs/udev sys-apps/hotplug )"

pkg_setup() {
	if [[ -z ${XEN_TARGET_ARCH} ]] ; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64 ; then
			export XEN_TARGET_ARCH="x86_64"
		else
			die "Unsupported architecture!"
		fi
	fi
}

src_prepare() {
	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
	fi
}

src_unpack() {
	unpack ${A}
        cd "${S}"
        epatch "${FILESDIR}/${MY_P}-gentoo.patch"
	if use bin; then
		unpack ../work/"${MY_P}"/xenstore.tar.bz2
	else
		unpack ../work/"${MY_P}"/xenstore-sources.tar.bz2
	fi
}

src_compile() {
	if ! use bin ; then
		local myopt
		use static && myopt="${myopt} XENSTORE_STATIC_CLIENTS=y"

		emake -C "${S}"/uclibc-sources/tools/include || die "compile failed"
		emake -C "${S}"/uclibc-sources/tools/libxc || die "compile failed"
		emake -C "${S}"/uclibc-sources/tools/xenstore ${myopt} || die "compile failed"
	fi
}

src_install() {
	insinto /usr
	if use bin; then
		dobin "${S}"/usr/bin/xenstore*
	else
		emake -C "${S}"/uclibc-sources/tools/xenstore DESTDIR="${D}" client-install || die "instal failed"
		if ! use static ; then
			dolib.so "${S}"/uclibc-sources/tools/xenstore/libxenstore.so.3.0.0
			dosym libxenstore.so.3.0.0 /usr/lib/libxenstore.so.3
			dosym libxenstore.so.3.0.0 /usr/lib/libxenstore.so
		fi
	fi

	dosbin "${S}"/xe-daemon
	dosbin "${S}"/xe-linux-distribution
	dosbin "${S}"/xe-update-guest-attrs

	newinitd "${S}"/gentoo/xe-daemon.init xe-daemon

#	mkdir -p "${D}"/etc/udev/rules.d
#	mv -f "${S}"/xen-vbd-cdrom.rules "${D}"/etc/udev/rules.d/z10-xen-vbd-cdrom.rules
#	mv -f "${S}"/xen-vcpu-hotplug.rules "${D}"/etc/udev/rules.d/z10-xen-vcpu-hotplug.rules

	dodoc "${S}"/COPYING
	dodoc "${S}"/COPYING.LGPL
}
