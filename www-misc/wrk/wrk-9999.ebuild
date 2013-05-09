# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/wg/${PN}.git
	               git://github.com/wg/${PN}.git"
	EGIT_MASTER="master"
	inherit git-2
fi

DESCRIPTION="Modern HTTP benchmarking tool"
HOMEPAGE="https://github.com/wg/wrk"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}"

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS} -std=gnu99 -Wall -Wno-implicit-function-declaration -D_REENTRANT" || die "Make failed!"
}

src_install() {
	dobin ${PN} || die
}
