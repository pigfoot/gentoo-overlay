# Copyright 1999-2012 Gentoo Foundation
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.
# $Header: $

EAPI=4

inherit git-2 eutils

DESCRIPTION="A fast and lightweight key/value database library by Google."
HOMEPAGE="http://code.google.com/p/leveldb/"
EGIT_REPO_URI="https://code.google.com/p/leveldb"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="+snappy"

DEPEND="snappy? ( app-arch/snappy )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use snappy && export EXTRA_EMAKE="${EXTRA_EMAKE} USE_SNAPPY=yes"
}

src_prepare(){
	sed -i -e 's:OPT ?=:OPT ?= -fPIC:g' "${S}/Makefile"
}

src_install(){
	insinto /usr/include/leveldb
	doins include/leveldb/*.h
	dolib libleveldb.a libleveldb.so libleveldb.so.*
}
