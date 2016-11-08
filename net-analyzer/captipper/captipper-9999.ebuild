# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )

EGIT_REPO_URI="https://github.com/pigfoot/CapTipper.git"
EGIT_BRANCH="pf-patch"
inherit git-r3 distutils-r1

DESCRIPTION="Malicious HTTP traffic explorer"
HOMEPAGE="https://github.com/omriher/CapTipper"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
