# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/OWASP/Amass"

inherit go-module

if [[ ${PV} == *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://${EGO_PN}.git"

    src_unpack() {
        git-r3_src_unpack
        go-module_live_vendor
    }
else
    EGO_VER="v${PV}"
    #SRC_URI="https://${EGO_PN}/archive/${EGO_VER}.tar.gz -> ${P}.tar.gz"

    #SRC_URI+="${EGO_SUM_SRC_URI}"
    #S="${WORKDIR}/Amass-${PV}"
    inherit git-r3
    EGIT_REPO_URI="https://${EGO_PN}.git"
    EGIT_COMMIT="${EGO_VER}"

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}

    KEYWORDS="~amd64 ~x86 ~arm64 ~arm"
fi

DESCRIPTION="In-depth Attack Surface Mapping and Asset Discovery"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
RESTRICT="mirror"
IUSE="+pie"

src_compile() {
    # -buildmode=pie forces external linking mode, even CGO_ENABLED=0
    # https://github.com/golang/go/issues/18968
    use pie && local build_pie="-buildmode=pie"

    local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

    set -- env \
        CGO_ENABLED=0 \
        go build -o "bin/${PN}" -mod=vendor -v -work -x ${build_flags} \
            ./cmd/${PN}
    echo "$@"
    "$@" || die
}

src_install() {
    dobin bin/${PN}

    insinto /etc/amass
    doins "${S}"/examples/config.ini
}
