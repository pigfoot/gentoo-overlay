# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..7} )
inherit distutils-r1

MY_PN="github.com/alexis-mignon/python-${PN}"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=()
else
	EGIT_COMMIT="${PV}"
	MY_P="python-${PN}-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Simple tool to upload photos to Flickr"
HOMEPAGE="https://github.com/alexis-mignon/python-flickr-api/"

LICENSE="BSD"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
