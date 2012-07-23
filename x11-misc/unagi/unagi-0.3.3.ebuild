# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://rcs-git.duckcorp.org/projects/unagi/unagi.git"
	AUTOTOOLS_AUTORECONF="1"
	SRC_URI=""
	git_eclass="git-2"
else
	MY_AID="111"
	SRC_URI="http://projects.mini-dweeb.org/attachments/download/${MY_AID}/${P}.tar.gz"
	git_eclass=""
fi

inherit ${git_eclass} autotools-utils

DESCRIPTION="Modular compositing manager"
HOMEPAGE="http://projects.mini-dweeb.org/projects/unagi"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

COMMON_DEPEND="
	dev-libs/libxdg-basedir
	dev-libs/libev
	dev-libs/confuse
	x11-misc/xcb"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto"
RDEPEND="${COMMON_DEPEND}"

