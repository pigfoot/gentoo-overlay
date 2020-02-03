# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/isacikgoz/tldr"
EGIT_COMMIT="3918253df491996b5618f2eb3de015170d63c21a"
EGO_VENDOR=(
	"github.com/c-bata/go-prompt v0.2.3"
	"github.com/fatih/color v1.7.0"
	"github.com/isacikgoz/gitin v0.2.3"
	"github.com/kelseyhightower/envconfig v1.4.0"
	"github.com/mattn/go-isatty v0.0.9"
	"github.com/pkg/term aa71e9d9e942"
	"github.com/sahilm/fuzzy v0.1.0"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6 github.com/alecthomas/kingpin"
	"gopkg.in/src-d/go-git.v4 v4.13.1 github.com/src-d/go-git"
	"github.com/alecthomas/template a0175ee3bccc"
	"github.com/alecthomas/units 2efee857e7cf"
	"github.com/emirpasic/gods v1.12.0"
	"github.com/jbenet/go-context d14ea06fba99"
	"github.com/kevinburke/ssh_config 01f96b0aa0cd"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/src-d/gcfg v1.4.0"
	"github.com/xanzy/ssh-agent v0.2.1"
	"golang.org/x/crypto 4def268fd1a4 github.com/golang/crypto"
	"golang.org/x/net ca1201d0de80 github.com/golang/net"
	"golang.org/x/sys fde4db37ae7a github.com/golang/sys"
	"gopkg.in/src-d/go-billy.v4 v4.3.2 github.com/src-d/go-billy"
	"gopkg.in/warnings.v0 v0.1.2 github.com/go-warnings/warnings"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="fast and interactive tldr client written with go, written in GoLang"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
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
		go install -v -work -x ${build_flags} ${EGO_PN}/cmd/tldr
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/*
}
