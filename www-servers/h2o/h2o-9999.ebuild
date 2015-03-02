# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils user

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/h2o/${PN}.git
                   git://github.com/h2o/${PN}.git"
    inherit git-r3
else
	SRC_URI="https://github.com/h2o/h2o/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="An optimized HTTP server with support for HTTP/1.x and HTTP/2"
HOMEPAGE="https://github.com/h2o/h2o"
LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/libyaml
	>=dev-libs/libuv-1.0.0"

RDEPEND="${DEPEND}"

pkg_setup(){
	enewgroup h2o
	enewuser h2o -1 -1 /var/www/localhost/htdocs h2o
}

src_prepare(){
	cmake-utils_src_prepare
}

src_configure(){
	cmake-utils_src_configure
}

src_compile(){
	cmake-utils_src_compile
}

src_install(){
	cmake-utils_src_install

	# init script stuff
	newinitd "${FILESDIR}"/initd/h2o.initd h2o

	# configs
	insinto /etc/h2o
	doins "${FILESDIR}"/conf/h2o.conf

	keepdir /var/l{ib,og}/h2o /var/www/localhost/htdocs
	fowners h2o:h2o /var/l{ib,og}/h2o
	fperms 0750 /var/l{ib,og}/h2o
}
