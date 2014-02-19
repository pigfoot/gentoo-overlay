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

DESCRIPTION="Low-level DNS library."
HOMEPAGE="https://github.com/farsightsec/wdns"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="net-libs/libpcap:="

RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes

src_prepare() {
    sed -i \
        -e "/\$(AM_V_GEN)wdns\/gen_rrclass_to_str/s#wdns\/#${S}\/wdns\/#g" \
        -e "/\$(AM_V_GEN)wdns\/gen_rrtype_to_str/s#wdns\/#${S}\/wdns\/#g" \
        Makefile.am || die "sed failed"

    ./autogen.sh || die
}

src_install() {
    autotools-utils_src_install
}
