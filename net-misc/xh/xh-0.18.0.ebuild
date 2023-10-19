# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999 ]]; then
	CRATES="
	adler@1.0.2
	aho-corasick@0.7.18
	alloc-no-stdlib@2.0.3
	alloc-stdlib@0.2.1
	anyhow@1.0.44
	assert_cmd@2.0.2
	atty@0.2.14
	autocfg@1.0.1
	base-x@0.2.8
	base64@0.13.0
	bincode@1.3.3
	bitflags@1.3.2
	block-buffer@0.9.0
	brotli@3.3.3
	brotli-decompressor@2.3.2
	bstr@0.2.16
	bumpalo@3.7.0
	byteorder@1.4.3
	bytes@1.1.0
	cc@1.0.70
	cfg-if@1.0.0
	chardetng@0.1.15
	chrono@0.4.19
	clap@3.1.0
	clap_complete@3.1.0
	clap_derive@3.1.0
	console@0.14.1
	const_fn@0.4.8
	cookie@0.15.1
	cookie_store@0.15.0
	core-foundation@0.9.1
	core-foundation-sys@0.8.2
	cpufeatures@0.2.1
	crc32fast@1.2.1
	difflib@0.4.0
	digest@0.9.0
	digest_auth@0.3.0
	dirs@3.0.2
	dirs-sys@0.3.6
	discard@1.0.4
	doc-comment@0.3.3
	either@1.6.1
	encode_unicode@0.3.6
	encoding_rs@0.8.29
	encoding_rs_io@0.1.7
	flate2@1.0.22
	float-cmp@0.9.0
	fnv@1.0.7
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	form_urlencoded@1.0.1
	futures-channel@0.3.17
	futures-core@0.3.17
	futures-io@0.3.17
	futures-sink@0.3.17
	futures-task@0.3.17
	futures-util@0.3.17
	generic-array@0.14.4
	getopts@0.2.21
	getrandom@0.2.3
	h2@0.3.13
	hashbrown@0.11.2
	heck@0.4.0
	hermit-abi@0.1.19
	hex@0.4.3
	http@0.2.4
	http-body@0.4.3
	httparse@1.5.1
	httpdate@1.0.1
	hyper@0.14.12
	hyper-rustls@0.23.0
	hyper-tls@0.5.0
	idna@0.2.3
	indexmap@1.7.0
	indicatif@0.16.2
	indoc@1.0.7
	ipnet@2.3.1
	itertools@0.10.1
	itoa@0.4.8
	itoa@1.0.1
	js-sys@0.3.54
	jsonxf@1.1.1
	lazy_static@1.4.0
	lazycell@1.3.0
	libc@0.2.101
	line-wrap@0.1.1
	linked-hash-map@0.5.4
	log@0.4.14
	matches@0.1.9
	md-5@0.9.1
	memchr@2.4.1
	mime@0.3.16
	mime2ext@0.1.49
	mime_guess@2.0.3
	miniz_oxide@0.4.4
	mio@0.7.13
	miow@0.3.7
	native-tls@0.2.8
	normalize-line-endings@0.3.0
	ntapi@0.3.6
	num-integer@0.1.44
	num-traits@0.2.14
	num_cpus@1.13.0
	number_prefix@0.4.0
	once_cell@1.8.0
	onig@6.2.0
	onig_sys@69.7.0
	opaque-debug@0.3.0
	openssl@0.10.36
	openssl-probe@0.1.4
	openssl-sys@0.9.66
	os_display@0.1.3
	os_str_bytes@6.0.0
	pem@0.8.3
	percent-encoding@2.1.0
	pin-project-lite@0.2.7
	pin-utils@0.1.0
	pkg-config@0.3.19
	plist@1.2.1
	ppv-lite86@0.2.10
	predicates@2.1.1
	predicates-core@1.0.2
	predicates-tree@1.0.3
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro-hack@0.5.19
	proc-macro2@1.0.29
	psl-types@2.0.7
	publicsuffix@2.1.1
	quote@1.0.9
	rand@0.8.4
	rand_chacha@0.3.1
	rand_core@0.6.3
	rand_hc@0.3.1
	redox_syscall@0.2.10
	redox_users@0.4.0
	regex@1.5.4
	regex-automata@0.1.10
	regex-syntax@0.6.25
	remove_dir_all@0.5.3
	reqwest@0.11.10
	ring@0.16.20
	roff@0.2.1
	rpassword@5.0.1
	rustc_version@0.2.3
	rustls@0.20.4
	rustls-native-certs@0.6.2
	rustls-pemfile@0.3.0
	rustls-pemfile@1.0.0
	ryu@1.0.5
	safemem@0.3.3
	same-file@1.0.6
	schannel@0.1.19
	sct@0.7.0
	security-framework@2.4.2
	security-framework-sys@2.4.2
	semver@0.9.0
	semver-parser@0.7.0
	serde@1.0.130
	serde_derive@1.0.130
	serde_json@1.0.67
	serde_urlencoded@0.7.1
	sha1@0.6.0
	sha2@0.9.8
	slab@0.4.4
	socket2@0.4.1
	spin@0.5.2
	standback@0.2.17
	stdweb@0.4.20
	stdweb-derive@0.5.3
	stdweb-internal-macros@0.2.9
	stdweb-internal-runtime@0.1.5
	strsim@0.10.0
	syn@1.0.76
	syntect@4.6.0
	tempfile@3.2.0
	termcolor@1.1.2
	terminal_size@0.1.17
	textwrap@0.14.2
	thiserror@1.0.29
	thiserror-impl@1.0.29
	time@0.2.27
	time-macros@0.1.1
	time-macros-impl@0.1.2
	tinyvec@1.4.0
	tinyvec_macros@0.1.0
	tokio@1.11.0
	tokio-native-tls@0.3.0
	tokio-rustls@0.23.3
	tokio-socks@0.5.1
	tokio-util@0.7.1
	tower-service@0.3.1
	tracing@0.1.26
	tracing-attributes@0.1.20
	tracing-core@0.1.19
	treeline@0.1.0
	try-lock@0.2.3
	typenum@1.14.0
	unicase@2.6.0
	unicode-bidi@0.3.6
	unicode-normalization@0.1.19
	unicode-width@0.1.9
	unicode-xid@0.2.2
	untrusted@0.7.1
	url@2.2.2
	vcpkg@0.2.15
	version_check@0.9.3
	wait-timeout@0.2.0
	walkdir@2.3.2
	want@0.3.0
	wasi@0.10.2+wasi-snapshot-preview1
	wasm-bindgen@0.2.77
	wasm-bindgen-backend@0.2.77
	wasm-bindgen-futures@0.4.27
	wasm-bindgen-macro@0.2.77
	wasm-bindgen-macro-support@0.2.77
	wasm-bindgen-shared@0.2.77
	web-sys@0.3.54
	webpki@0.22.0
	webpki-roots@0.22.3
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winreg@0.10.1
	xml-rs@0.8.4
	yaml-rust@0.4.5
	"
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
