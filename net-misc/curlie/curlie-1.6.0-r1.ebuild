# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_PN="github.com/rs/${PN}"

EGO_SUM=(
	"github.com/akamensky/argparse v0.0.0-20180518035907-99676ba18cd5/go.mod"
	"github.com/jessevdk/go-flags v1.4.0/go.mod"
	"golang.org/x/crypto v0.0.0-20180524125353-159ae71589f3"
	"golang.org/x/crypto v0.0.0-20180524125353-159ae71589f3/go.mod"
	"golang.org/x/sys v0.0.0-20180525062015-31355384c89b/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
)

go-module_set_globals

DESCRIPTION="The power of curl, the ease of use of httpie, written in GoLang"
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
		go build -mod=readonly -v -work -x ${build_flags} -o "bin/${PN}" ${EGO_PN}
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/*
}
