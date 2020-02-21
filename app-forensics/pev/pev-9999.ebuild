# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="github.com/merces/${PN}"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=( lib/libpe )
else
	EGIT_COMMIT="8ca94a91a546c92fc1c34f12acb1f3123bfe4fb6"
	EGIT_COMMIT_LIBPE="e1c3c43414480ebde8391cfd32aebc4c24e6622e"
	MY_P="${PN}-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/merces/libpe/archive/${EGIT_COMMIT_LIBPE}.tar.gz -> libpe-${EGIT_COMMIT_LIBPE}.tar.gz"
fi

DESCRIPTION="The PE file analysis toolkit"
HOMEPAGE="http://pev.sf.net"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default

	if [[ "${PV}" == "9999" ]]; then
        git-r3_src_unpack
    else
    	unpack ${P}.tar.gz
        unpack libpe-${EGIT_COMMIT_LIBPE}.tar.gz
        set -- env \
        cp -rp libpe-${EGIT_COMMIT_LIBPE}/* ${MY_P}/lib/libpe
		echo "$@"
		"$@" || die
    fi
}

src_prepare() {
	default

	local MY_PREFIX=${EPREFIX}/usr
	local MY_LIBDIR=$(get_libdir)

	set -- env \
	sed -i -E \
		-e "/^prefix/ s#(.*=[[:space:]]*).*#\1${MY_PREFIX}#" \
		-e "/^libdir/ s#(.*=[[:space:]]*).*#\1\$(exec_prefix)/${MY_LIBDIR}#" \
		lib/libpe/Makefile
	echo "$@"
	"$@" || die

	set -- env \
	sed -i -E \
		-e "/^prefix/ s#(.*=[[:space:]]*).*#\1${MY_PREFIX}#" \
		-e "/^libdir/ s#(.*=[[:space:]]*).*#\1\$(exec_prefix)/${MY_LIBDIR}#" \
		src/Makefile
	echo "$@"
	"$@" || die
}
