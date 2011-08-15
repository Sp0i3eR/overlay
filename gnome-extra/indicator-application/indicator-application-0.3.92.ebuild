# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools gnome2 eutils versionator

DESCRIPTION="Application Indicators"
HOMEPAGE="http://launchpad.net/indicator-application"
SRC_URI="http://launchpad.net/${PN}/0.4/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.12:2
	>=x11-libs/cairo-1.2.4
	>=x11-libs/pango-1.14.0
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	>=dev-libs/libindicator-0.3
	gnome-extra/indicator-applet"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/gtk-doc
	dev-util/intltool"


DOCS="AUTHORS ChangeLog COPYING README"

src_prepare() {
	gnome2_src_prepare

	# disable Mono bindings
	sed -i -e '59,111s|^|#|g' -e '183,187d' \
		configure.ac || die
	sed -i -e '2d' bindings/Makefile.am

	(./autogen.sh) || die
}