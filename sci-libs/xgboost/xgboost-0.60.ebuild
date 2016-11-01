# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )
inherit distutils-r1

DESCRIPTION="Scalable, Portable and Distributed Gradient Boosting."
HOMEPAGE="https://github.com/dmlc/xgboost"

if [[ ${PV} == *9999* ]] ; then
    EGIT_REPO_URI="git://github.com/dmlc/xgboost.git"
    inherit git-r3
else
    EGIT_COMMIT="4a8d63b6c8711fb839c71e26c659936252df1eb5"
    EGIT_REPO_URI="git://github.com/dmlc/xgboost.git"
    KEYWORDS="~amd64 ~x86"
    inherit git-r3
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
