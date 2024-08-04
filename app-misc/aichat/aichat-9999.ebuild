# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES=""
fi

inherit cargo

DESCRIPTION="All-in-one AI CLI Tool"
HOMEPAGE="https://github.com/sigoden/aichat"
GITHUB_USER=sigoden
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

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="0BSD Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC LGPL-3+ MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
RESTRICT="mirror"

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
    cargo_src_configure
}

src_compile() {
    cargo_src_compile --bin=${PN}
}

src_install() {
    cargo_src_install --bin=${PN}
}
