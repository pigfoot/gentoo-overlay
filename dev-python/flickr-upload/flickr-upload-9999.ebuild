# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/beaufour/${PN}.git
	               git://github.com/beaufour/${PN}.git"
	EGIT_MASTER="master"
	inherit git-2
fi

DESCRIPTION="Simple tool to upload photos to Flickr"
HOMEPAGE="https://github.com/beaufour/flickr-upload"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"

src_compile(){
	python setup.py build || die
}

src_install(){
	 python setup.py install --root="${D}" || die
}
