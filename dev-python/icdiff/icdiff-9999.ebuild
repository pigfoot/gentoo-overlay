# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )
inherit eutils

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://github.com/jeffkaufman/${PN}.git
                   git://github.com/jeffkaufman/${PN}.git"
    EGIT_MASTER="master"
    inherit git-2
fi

DESCRIPTION="Improved colored diff"
HOMEPAGE="http://www.jefftk.com/icdiff"
LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"

src_compile(){
	python setup.py build || die
}

src_install(){
	 python setup.py install --root="${D}" || die
}
