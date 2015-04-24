# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

GO_PN="github.com/astaxie/bat"

if [[ ${PV} == "9999" ]] ; then
    EGIT_REPO_URI="https://${GO_PN}.git
                   git://${GO_PN}.git"
    inherit git-r3
else
    SRC_URI="https://${GO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="~x86 ~amd64"

DESCRIPTION="Go implement CLI, cURL-like tool for humans"
HOMEPAGE="https://github.com/astaxie/bat/"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-lang/go"
RDEPEND=""

export GOPATH="${WORKDIR}"

src_unpack() {
    if [[ ${PV} == "9999" ]] ; then
        git-r3_src_unpack
    else
        default_src_unpack
    fi
    mkdir -p src/${GO_PN%/*} || die
    ln -sf "${S}" "src/${GO_PN%-*}"
}

src_compile() {
    go build -ldflags '-extldflags=-fno-PIC' -v -x -work ${GO_PN} || die
}

src_test() {
    go test -ldflags '-extldflags=-fno-PIC' ${GO_PN}/${PN} || die
}

src_install() {
    dobin ${PN}
    dodoc README.md
}
