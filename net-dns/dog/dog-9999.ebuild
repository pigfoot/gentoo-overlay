# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES=""
	declare -A GIT_CRATES=(
	)
fi

inherit cargo

DESCRIPTION="A command-line DNS client"
HOMEPAGE="https://dns.lookup.dog/"

if [[ ${PV} == *9999 ]]; then
    EGIT_REPO_URI="https://github.com/ogham/${PN}"
    inherit git-r3
else
    [[ ${PV} == *_pre???????? ]] && COMMIT="721440b12ef01a812abe5dc6ced69af6e221fad5"

    SRC_URI="https://github.com/ogham/${PN}/archive/${COMMIT:-${PV}}.tar.gz -> ${P}.tar.gz
        ${CARGO_CRATE_URIS}"
    S="${WORKDIR}/${PN}-${COMMIT:-${PV}}"
    KEYWORDS="amd64 x86 arm arm64 ~ppc64 ~riscv"
fi

LICENSE="EUPL-1.2"
SLOT="0"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
    if [[ ${PV} == *9999* ]]; then
        git-r3_src_unpack
		rm -f "${S}"/Cargo.lock
        cargo_live_src_unpack
    else
        cargo_src_unpack
    fi
}
