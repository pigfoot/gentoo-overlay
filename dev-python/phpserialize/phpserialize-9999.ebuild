# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )
inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mitsuhiko/${PN}.git
	               git://github.com/mitsuhiko/${PN}.git"
	EGIT_MASTER="master"
	inherit git-2
	KEYWORDS="~x86 ~amd64"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="x86 amd64"
fi

DESCRIPTION="A small library for extracting rich content from urls"
HOMEPAGE="http://github.com/mitsuhiko/phpserialize"
LICENSE="BSD"
SLOT="0"
RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
