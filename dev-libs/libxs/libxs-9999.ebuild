# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools-utils

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/crossroads-io/${PN}.git
                   git://github.com/crossroads-io/${PN}.git"
    EGIT_MASTER="master"
    inherit git-2
fi

DESCRIPTION="libxs is a library for building scalable and high performance distributed applications."
HOMEPAGE="https://github.com/crossroads-io/libxs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes

src_prepare() {
    ./autogen.sh || die
}

src_install() {
    autotools-utils_src_install
}
