# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/rs/${PN}"
EGO_VENDOR=(
	"github.com/akamensky/argparse 99676ba18cd5"
	"github.com/jessevdk/go-flags v1.4.0"
	"golang.org/x/crypto 159ae71589f3 github.com/golang/crypto"
	"golang.org/x/sys 31355384c89b github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="The power of curl, the ease of use of httpie, written in GoLang"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
SRC_URI="${ARCHIVE_URI}"
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

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		CGO_ENABLED=0 \
		GO111MODULE=off \
		go install -v -work -x ${build_flags} ${EGO_PN}
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/*
}
