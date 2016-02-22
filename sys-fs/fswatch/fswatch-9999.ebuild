# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/emcrisostomo/${PN}.git"
	inherit git-r3
	KEYWORDS="~x86 ~amd64"
else
	SRC_URI="https://github.com/emcrisostomo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="x86 amd64"
fi

DESCRIPTION="A cross-platform file change monitor with multiple backends"
HOMEPAGE="http://emcrisostomo.github.io/fswatch/"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=""

DEPEND="${RDEPEND}"

src_prepare() {
	./autogen.sh || die
	eapply_user
}
