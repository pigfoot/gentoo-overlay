# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="github.com/trendmicro/${PN}"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=()
else
	EGIT_COMMIT=${PV}
	MY_P="${PN}-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Trend Micro Locality Sensitive Hash"
HOMEPAGE="https://github.com/trendmicro/tlsh"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

CMAKE_BUILD_TYPE=Release

src_compile() {
	sh ./make.sh -notest
}

src_install() {
	cmake_src_install

	# Manually install supporting files that conflict with other packages
	# but are needed for galera and initial installation
	exeinto /usr/bin
	newexe "${S}/bin/tlsh_unittest" tlsh
}
