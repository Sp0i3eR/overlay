# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PPD description files for Kyocera ECOSYS Printers"
HOMEPAGE="http://www.kyoceradocumentsolutions.eu/"
SRC_URI="LinuxDrv_8.1709...idn_35x0idn.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de +l10n_en l10n_es l10n_fr l10n_it l10n_pt"
REQUIRED_USE="|| ( l10n_de l10n_en l10n_es l10n_fr l10n_it l10n_pt )"
RESTRICT="fetch bindist"

RDEPEND="net-print/cups"
DEPEND="app-arch/unzip"

S="${WORKDIR}/Linux"

pkg_nofetch() {
	einfo "Please download ${A} from the following URL:"
	einfo "https://www.kyoceradocumentsolutions.eu/index/service/dlc.false.driver.ECOSYSM3040DN._.EN.html"
}

src_install() {
	insinto /usr/share/cups/model/KyoceraEcoSys

	inslanguage() {
		if use l10n_$1; then
			doins Global/$2/*.ppd || die "failed to install $2 ppds"
		fi
	}

	inslanguage en English

	docinto html
	dodoc ReadMe.htm
}
