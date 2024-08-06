# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	anstream@0.6.13
	anstyle@1.0.6
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anyhow@1.0.82
	autocfg@1.2.0
	base64@0.21.7
	bincode@1.3.3
	bitflags@1.3.2
	bitflags@2.5.0
	cfg-if@1.0.0
	chumsky@0.9.3
	clap@4.5.4
	clap_builder@4.5.2
	clap_derive@4.5.4
	clap_lex@0.7.0
	colorchoice@1.0.0
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	deranged@0.3.11
	dyn-clone@1.0.17
	endian-type@0.1.2
	equivalent@1.0.1
	filedescriptor@0.8.2
	getrandom@0.2.14
	hashbrown@0.14.3
	heck@0.5.0
	hifijson@0.2.1
	indexmap@2.2.6
	itoa@1.0.11
	jaq-core@1.2.1
	jaq-interpret@1.2.1
	jaq-parse@1.0.2
	jaq-std@1.2.1
	jaq-syn@1.1.0
	libc@0.2.153
	libm@0.2.8
	lock_api@0.4.11
	log@0.4.21
	memchr@2.7.2
	mio@0.8.11
	nibble_vec@0.1.0
	num-conv@0.1.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	powerfmt@0.2.0
	proc-macro2@1.0.81
	promkit@0.4.3
	quote@1.0.36
	radix_trie@0.2.1
	redox_syscall@0.4.1
	regex@1.10.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	ryu@1.0.17
	scopeguard@1.2.0
	serde@1.0.198
	serde_derive@1.0.198
	serde_json@1.0.116
	signal-hook@0.3.17
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.2
	smallvec@1.13.2
	strsim@0.11.1
	syn@2.0.60
	thiserror@1.0.59
	thiserror-impl@1.0.59
	time@0.3.36
	time-core@0.1.2
	time-macros@0.2.18
	unicode-ident@1.0.12
	unicode-width@0.1.11
	urlencoding@2.1.3
	utf8parse@0.2.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	zerocopy@0.7.32
	zerocopy-derive@0.7.32
	"
fi

inherit cargo

DESCRIPTION="JSON navigator and interactive filter leveraging jq"
HOMEPAGE="https://github.com/ynqa/jnv"
GITHUB_USER=ynqa
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
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC Unicode-DFS-2016 Unlicense"
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

src_compile() {
    cargo_src_compile --bin=${PN}
}

src_install() {
    cargo_src_install --bin=${PN}
}
