# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )

inherit distutils-r1

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
IUSE="+python static-libs"

DEPEND=">=sys-devel/gcc-4.6"
RDEPEND="${DEPEND}
    python? (
        ${PYTHON_DEPS}
        dev-python/numpy[${PYTHON_USEDEP}]
        sci-libs/scipy[${PYTHON_USEDEP}]
    )
"

src_compile() {
    default
    use python && cd python-package && distutils-r1_src_compile
}

src_install() {
    insinto /usr/include
    doins -r {dmlc-core/,rabit/,}include/*
    dolib.so lib/libxgboost.so
    use static-libs && dolib.a lib/libxgboost.a
    dobin xgboost

    use python && cd python-package && distutils-r1_src_install
}
