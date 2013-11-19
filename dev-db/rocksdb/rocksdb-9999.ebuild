# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/facebook/${PN}.git
                   git://github.com/facebook/${PN}.git"
    EGIT_MASTER="master"
    inherit git-2
fi

DESCRIPTION="RocksDB is an embeddable persistent key-value store for fast storage."
HOMEPAGE="http://rocksdb.org/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+snappy +zlib +bzip2"

DEPEND="dev-cpp/gflags
        snappy? ( app-arch/snappy )
        zlib? ( sys-libs/zlib )
        bzip2? ( app-arch/bzip2 )"

RDEPEND="${DEPEND}"

src_install() {
    insinto /usr/include/rocksdb
    doins include/rocksdb/*.h
    dolib librocksdb.a
}
