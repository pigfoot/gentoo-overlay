# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES="
	aho-corasick@1.1.3
	anstream@0.6.13
	anstyle@1.0.6
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anyhow@1.0.81
	autocfg@1.1.0
	autotools@0.2.6
	bindgen@0.69.4
	bitflags@1.3.2
	bitflags@2.5.0
	cc@1.0.90
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.7.0
	clap@4.5.3
	clap_builder@4.5.2
	clap_derive@4.5.3
	clap_lex@0.7.0
	colorchoice@1.0.0
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	either@1.10.0
	endian-type@0.1.2
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.1
	filedescriptor@0.8.2
	gag@1.0.0
	glob@0.3.1
	hashbrown@0.14.3
	heck@0.5.0
	home@0.5.9
	indexmap@2.2.5
	itertools@0.12.1
	itoa@1.0.10
	j9@0.1.2
	j9-sys@0.1.2
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.153
	libloading@0.8.3
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.21
	memchr@2.7.1
	minimal-lexical@0.2.1
	mio@0.8.11
	nibble_vec@0.1.0
	nom@7.1.3
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	prettyplease@0.2.16
	proc-macro2@1.0.79
	promkit@0.3.1
	quote@1.0.35
	radix_trie@0.2.1
	redox_syscall@0.4.1
	regex@1.10.3
	regex-automata@0.4.6
	regex-syntax@0.8.2
	rustc-hash@1.1.0
	rustix@0.38.32
	ryu@1.0.17
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	shlex@1.3.0
	signal-hook@0.3.17
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.1
	smallvec@1.13.1
	strsim@0.11.0
	syn@2.0.53
	tempfile@3.10.1
	thiserror@1.0.58
	thiserror-impl@1.0.58
	unicode-ident@1.0.12
	unicode-width@0.1.11
	utf8parse@0.2.1
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	which@4.4.2
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.4
	"
fi

inherit cargo

DESCRIPTION="interactive JSON filter using jq"
HOMEPAGE="https://github.com/ynqa/jnv"

if [[ ${PV} == *9999 ]]; then
    EGIT_REPO_URI="https://github.com/ynqa/${PN}"
    inherit git-r3
else
    [[ ${PV} == *_pre???????? ]] && COMMIT=""

    SRC_URI="https://github.com/ynqa/${PN}/archive/${COMMIT:-v${PV}}.tar.gz -> ${P}.tar.gz
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

src_install() {
    cargo_src_install

    dosym /usr/bin/"${PN}" /usr/bin/"${PN}s"
}
