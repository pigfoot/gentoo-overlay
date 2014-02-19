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

DESCRIPTION="Network message encapsulation library."
HOMEPAGE="https://github.com/farsightsec/nmsg"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="net-libs/libpcap:=
        dev-libs/protobuf:=
        dev-libs/protobuf-c:=
        dev-libs/wdns:=
        dev-libs/libxs:=
        sys-libs/zlib:="

RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes

src_prepare() {
    ./autogen.sh || die
}

src_install() {
    autotools-utils_src_install
}
