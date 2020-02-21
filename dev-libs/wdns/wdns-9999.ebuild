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

DESCRIPTION="Low-level DNS library."
HOMEPAGE="https://github.com/farsightsec/wdns"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="net-libs/libpcap:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	eautoreconf
}
