# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/mercesthub.com/merces/${PN}.git
                   git://github.com/merces/${PN}.git"
    EGIT_MASTER="master"
    inherit git-2
    EGIT_HAS_SUBMODULES=1
fi

DESCRIPTION="The PE file analysis toolkit"
HOMEPAGE="http://pev.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i \
		-e 's@\$(LDFLAGS)@-L../../lib/libpe \$(LDFLAGS)@' \
		src/plugins/Makefile || die "sed failed"
}

src_install(){
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
