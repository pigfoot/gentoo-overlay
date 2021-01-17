# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_PN="github.com/felixonmars/${PN}"

DESCRIPTION="BaiDu PCS client, written in GoLang"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+="${EGO_SUM_SRC_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="+pie"

src_compile() {
	# -buildmode=pie forces external linking mode, even CGO_ENABLED=0
	# https://github.com/golang/go/issues/18968
	use pie && local build_pie="-buildmode=pie"

	local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

	set -- env \
		GOCACHE="${T}/go-cache" \
		CGO_ENABLED=0 \
		go build -mod=vendor -v -work -x ${build_flags} -o "bin/${PN}" .
	echo "$@"
	"$@" || die
}

src_install() {
	newbin bin/${PN} baidu-pcs
}
