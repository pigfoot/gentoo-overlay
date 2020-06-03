# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/mrichman/${PN}"
EGO_VENDOR=(
	"github.com/blang/semver v3.5.1"
	"github.com/influxdata/influxdb1-client fc22c7df067e"
	"github.com/sirupsen/logrus v1.4.2"
	"github.com/urfave/cli v1.21.0"
	"golang.org/x/net ba9fcec4b297 github.com/golang/net"
	"golang.org/x/sys 953cdadca894 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="A command line utility that parses HAR files, written in GoLang"
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
		go install -v -work -x ${build_flags} ${EGO_PN}/cmd/hargo
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/*
}
