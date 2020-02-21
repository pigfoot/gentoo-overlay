# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN="github.com/farsightsec/${PN}"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=()
else
	EGIT_COMMIT="v${PV}"
	MY_P="${PN}-tags-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/tags/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Encoding format, library, and utilities for passive DNS data."
HOMEPAGE="https://github.com/farsightsec/dnstable"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/jansson:=
		dev-libs/mtbl:=
		dev-libs/nmsg:=
		dev-libs/sie-nmsg:=
		dev-libs/wdns:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	eautoreconf
}
