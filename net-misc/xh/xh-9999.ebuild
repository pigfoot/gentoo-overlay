# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES=""
fi

inherit cargo

DESCRIPTION="Friendly and fast tool for sending HTTP requests"
HOMEPAGE="https://github.com/ducaale/xh"
GITHUB_USER=ducaale
GITHUB_REPO=${PN}

if [[ ${PV} == *9999 ]]; then
    EGIT_REPO_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
    inherit git-r3
else
    [[ ${PV} == *_pre???????? ]] && COMMIT=""

    SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${COMMIT:-v${PV}}.tar.gz -> ${P}.tar.gz
        ${CARGO_CRATE_URIS}"
    S="${WORKDIR}/${PN}-${COMMIT:-${PV}}"
    KEYWORDS="amd64 x86 arm arm64 ~ppc64 ~riscv"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
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

src_compile() {
    cargo_src_compile --bin=${PN}
}

src_install() {
    cargo_src_install --bin=${PN}

    dosym /usr/bin/"${PN}" /usr/bin/"${PN}s"
}
