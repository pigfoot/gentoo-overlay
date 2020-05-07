# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="github.com/fnogcps/tg"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=( tgl )
else
	EGIT_COMMIT="20200106"
	EGIT_COMMIT_TGL="57f1bc41ae13297e6c3e23ac465fd45ec6659f50"
	MY_P="tg-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/kenorb-contrib/tgl/archive/${EGIT_COMMIT_TGL}.tar.gz -> tgl-${EGIT_COMMIT_TGL}.tar.gz"
fi

DESCRIPTION="telegram-cli for Telegram IM"
HOMEPAGE="https://github.com/fnogcps/tg"

LICENSE="GPL-2"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE="json libressl lua luajit"
RESTRICT="mirror"

DEPEND="sys-libs/zlib
		sys-libs/readline:0=
		dev-libs/libconfig
		dev-libs/libevent
		json? ( dev-libs/jansson )

		lua? (
			!luajit? ( >=dev-lang/lua-5.1:= )
			luajit? ( dev-lang/luajit:2 )
		)

		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	default

	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
		unpack tgl-${EGIT_COMMIT_TGL}.tar.gz
		set -- env \
		cp -rp tgl-${EGIT_COMMIT_TGL}/* ${MY_P}/tgl
		echo "$@"
		"$@" || die
	fi
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		$(usex lua "--enable-liblua") \
		$(use_enable json)
}

src_install() {
	dobin bin/telegram-cli

	insinto /etc/telegram-cli/
	newins tg-server.pub server.pub
}
