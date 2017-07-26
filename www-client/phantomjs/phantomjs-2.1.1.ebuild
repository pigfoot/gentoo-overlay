# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy{,3} )

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
EGIT_REPO_URI="https://github.com/ariya/${PN}.git"
EGIT_COMMIT="2.1.1"

inherit eutils toolchain-funcs pax-utils multiprocessing git-r3

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples fontconfig libressl truetype"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-libs/icu:=
	fontconfig? ( media-libs/fontconfig )
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	truetype? ( media-libs/freetype )
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	net-misc/openssh[-bindist]
	app-arch/unzip
	virtual/pkgconfig"

src_prepare() {
	# Respect CC, CXX, {C,CXX,LD}FLAGS in .qmake.cache
	sed -i \
		-e "/^SYSTEM_VARIABLES=/i \
		CC='$(tc-getCC)'\n\
		CXX='$(tc-getCXX)'\n\
		CFLAGS='${CFLAGS}'\n\
		CXXFLAGS='${CXXFLAGS}'\n\
		LDFLAGS='${LDFLAGS}'\n\
		QMakeVar set QMAKE_CFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CFLAGS_DEBUG\n\
		QMakeVar set QMAKE_CXXFLAGS_RELEASE\n\
		QMakeVar set QMAKE_CXXFLAGS_DEBUG\n\
		QMakeVar set QMAKE_LFLAGS_RELEASE\n\
		QMakeVar set QMAKE_LFLAGS_DEBUG\n"\
		src/qt/qtbase/configure \
		|| die

	# Respect CC, CXX, LINK and *FLAGS in config.tests
	find src/qt/qtbase/config.tests/unix -name '*.test' -type f -exec \
		sed -i -e "/bin\/qmake/ s: \"\$SRCDIR/: \
			'QMAKE_CC=$(tc-getCC)'    'QMAKE_CXX=$(tc-getCXX)'      'QMAKE_LINK=$(tc-getCXX)' \
			'QMAKE_CFLAGS+=${CFLAGS}' 'QMAKE_CXXFLAGS+=${CXXFLAGS}' 'QMAKE_LFLAGS+=${LDFLAGS}'&:" \
		{} + || die
	
	default
}

src_compile() {
	./build.py \
		--confirm \
		--jobs $(makeopts_jobs) \
		|| die
}

src_test() {
	./bin/phantomjs test/run-tests.js || die
}

src_install() {
	pax-mark m bin/phantomjs || die
	dobin bin/phantomjs
	dodoc ChangeLog README.md
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
