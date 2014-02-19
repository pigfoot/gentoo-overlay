# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-utils

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/farsightsec/${PN}.git
                   git://github.com/farsightsec/${PN}.git"
    EGIT_MASTER="master"
    inherit git-2
fi

DESCRIPTION="mtbl is a C library implementation of the Sorted String Table (SSTable) data structure."
HOMEPAGE="https://github.com/farsightsec/mtbl"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/snappy:=
        sys-libs/zlib:="

RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes

src_prepare() {
    ./autogen.sh || die
}

src_install() {
    dodoc README* ChangeLog*

    autotools-utils_src_install
}
