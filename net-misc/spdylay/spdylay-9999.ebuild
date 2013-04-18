# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tatsuhiro-t/${PN}.git
	               git://github.com/tatsuhiro-t/${PN}.git"
    EGIT_MASTER="master"
	inherit git-2
else
	SRC_URI="mirror://sourceforge/spdylay/${P}.tar.xz"
fi

DESCRIPTION="The experimental SPDY protocol version 2 and 3 implementation in C"
HOMEPAGE="https://github.com/tatsuhiro-t/spdylay"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="xml"

DEPEND=">=sys-libs/zlib-1.2.3
        >=dev-libs/openssl-1.0.1
		xml? ( >=dev-libs/libxml2-2.7.7 )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	# disable everything, enable selectively
	local myconf="--disable-xmltest --without-libxml2"

	if use xml; then
		myconf+=" --with-xml-prefix=/usr"
	fi

	econf \
		${myconf}
}
