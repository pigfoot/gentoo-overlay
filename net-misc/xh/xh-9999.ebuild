# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES=""
fi

inherit cargo

DESCRIPTION="Friendly and fast tool for sending HTTP requests"
HOMEPAGE="https://github.com/ducaale/xh"

if [[ ${PV} == *9999 ]]; then
    EGIT_REPO_URI="https://github.com/ducaale/${PN}"
    inherit git-r3
else
    [[ ${PV} == *_pre???????? ]] && COMMIT="0e4a87baf18652bb982df3fd2362fad0596ad12d"

    SRC_URI="https://github.com/ducaale/${PN}/archive/${COMMIT:-v${PV}}.tar.gz -> ${P}.tar.gz
        ${CARGO_CRATE_URIS}"
    S="${WORKDIR}/${PN}-${COMMIT:-${PV}}"
    KEYWORDS="amd64 x86 arm arm64 ~ppc64 ~riscv"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
RESTRICT="mirror"
IUSE="+rustls"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
    if [[ ${PV} == *9999* ]]; then
        git-r3_src_unpack
        cargo_live_src_unpack
    else
        cargo_src_unpack
    fi
}

src_configure() {
    myfeatures=(
        $(usex rustls rustls native-tls)
    )

    cargo_src_configure --no-default-features
}

src_install() {
    cargo_src_install

    dosym /usr/bin/"${PN}" /usr/bin/"${PN}s"
}
