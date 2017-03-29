# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Programs to interact with a mediafire account"
HOMEPAGE="https://github.com/MediaFire/mediafire-fuse"
IUSE="+ssl libressl"

if [[ ${PV} == *9999* ]] ; then
    EGIT_REPO_URI="https://github.com/MediaFire/mediafire-fuse.git\
    	git://github.com/MediaFire/mediafire-fuse.git"
    KEYWORDS="~x86 ~amd64"
    inherit git-r3
else
    EGIT_COMMIT=${PV}
    SRC_URI="https://github.com/MediaFire/mediafire-fuse/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
    inherit vcs-snapshot
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="net-misc/curl[ssl]
	!libressl? ( >=dev-libs/openssl-1.0.2g:0=[-bindist] )
	libressl? ( dev-libs/libressl )
	sys-fs/fuse
	dev-libs/jansson"

DEPEND="${RDEPEND}"

src_configure() {
	cmake-utils_src_configure
}

