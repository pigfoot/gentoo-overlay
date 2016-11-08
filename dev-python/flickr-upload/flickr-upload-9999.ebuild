# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )
inherit distutils-r1

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
RDEPEND="dev-python/flickr-api[${PYTHON_USEDEP}]
	     dev-python/phpserialize[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
