# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/monasticacademy/${PN}"

inherit go-module

if [[ ${PV} == *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://${EGO_PN}.git"
    EGO_VER="devel"

    src_unpack() {
        git-r3_src_unpack
        go-module_live_vendor
    }
else
    EGO_VER="${PV}"
    #SRC_URI="https://${EGO_PN}/archive/v${EGO_VER}.tar.gz -> ${P}.tar.gz"
    inherit git-r3
    EGIT_REPO_URI="https://${EGO_PN}.git"
    EGIT_COMMIT=v"${EGO_VER}"

    src_unpack() {
        git-r3_src_unpack
        go-module_live_vendor
    }

    KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
fi

DESCRIPTION="View HTTP/HTTPS requests made by any Linux program"
LICENSE="MIT"
SLOT="0/${PVR}"
RESTRICT="mirror"
IUSE="+pie"

src_compile() {
    # -buildmode=pie forces external linking mode, even CGO_ENABLED=0
    # https://github.com/golang/go/issues/18968
    use pie && local build_pie="-buildmode=pie"

    local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"
    local ld_flags="$( echo "-s -w -X 'main.Version=${EGO_VER}'" )"

    set -- env \
        CGO_ENABLED=0 \
        go build -o "bin/${PN}" -mod=vendor -v -work -x ${build_flags} -ldflags "${ld_flags}" \
            .
    echo "$@"
    "$@" || die
}

src_install() {
    dobin bin/*
}
