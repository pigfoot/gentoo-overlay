# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/rs/${PN}"
EGO_VENDOR=(
	"github.com/akamensky/argparse 99676ba18cd5c0c3b331a13801ccd2b5c16a9259"
	"github.com/jessevdk/go-flags c6ca198ec95c841fdb89fc0de7496fed11ab854e"
	"golang.org/x/crypto 159ae71589f303f9fbfd7528413e0fe944b9c1cb github.com/golang/crypto"
	"golang.org/x/sys 31355384c89b50e6faeffdb36f64a77a8210188e github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="The power of curl, the ease of use of httpie, written in GoLang"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
SRC_URI="${ARCHIVE_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="+pie"

src_compile() {
	use pie && local build_pie="-buildmode=pie"
	local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
        GOCACHE="${T}/go-cache" \
        CGO_ENABLED=0 \
        go build -v -work -x ${build_flags} ${EGO_PN}
	echo "$@"
	"$@" || die
}

src_install() {
	dobin ${PN}
}
