# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_PN="github.com/ipinfo/cli"

EGO_SUM=(
	"github.com/fatih/color v1.10.0"
	"github.com/fatih/color v1.10.0/go.mod"
	"github.com/ipinfo/go/v2 v2.4.0"
	"github.com/ipinfo/go/v2 v2.4.0/go.mod"
	"github.com/jszwec/csvutil v1.4.0"
	"github.com/jszwec/csvutil v1.4.0/go.mod"
	"github.com/mattn/go-colorable v0.1.8"
	"github.com/mattn/go-colorable v0.1.8/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/patrickmn/go-cache v2.1.0+incompatible"
	"github.com/patrickmn/go-cache v2.1.0+incompatible/go.mod"
	"github.com/pkg/browser v0.0.0-20210115035449-ce105d075bb4"
	"github.com/pkg/browser v0.0.0-20210115035449-ce105d075bb4/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"golang.org/x/sync v0.0.0-20201207232520-09787c993a3a"
	"golang.org/x/sync v0.0.0-20201207232520-09787c993a3a/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210420205809-ac73e9fd8988"
	"golang.org/x/sys v0.0.0-20210420205809-ac73e9fd8988/go.mod"
	"golang.org/x/term v0.0.0-20201210144234-2321bbc49cbf"
	"golang.org/x/term v0.0.0-20201210144234-2321bbc49cbf/go.mod"
)

go-module_set_globals

DESCRIPTION="Official Command Line Interface for the IPinfo API "
SRC_URI="https://${EGO_PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
SRC_URI+="${EGO_SUM_SRC_URI}"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="+pie"

S="${WORKDIR}/cli-${P}"

src_compile() {
	# -buildmode=pie forces external linking mode, even CGO_ENABLED=0
	# https://github.com/golang/go/issues/18968
	use pie && local build_pie="-buildmode=pie"

	local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

	set -- env \
		GOCACHE="${T}/go-cache" \
		CGO_ENABLED=0 \
		go build -o "bin/${PN}" -mod=vendor -v -work -x ${build_flags} \
			./${PN}
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/${PN}
}
