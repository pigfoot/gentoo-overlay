# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Scalable, Portable and Distributed Gradient Boosting."
HOMEPAGE="https://github.com/dmlc/xgboost"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="git://github.com/dmlc/xgboost.git"
	inherit git-r3
else
    EGIT_COMMIT=v${PV}
    SRC_URI="https://github.com/dmlc/xgboost/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
    inherit vcs-snapshot
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs"

DEPEND=">=sys-devel/gcc-4.6"
RDEPEND="${DEPEND}"

src_install() {
    insinto /usr/include
    doins -r {dmlc-core/,rabit/,}include/*
    dolib.so lib/libxgboost.so
    use static-libs && dolib.a lib/libxgboost.a
    dobin xgboost
}
