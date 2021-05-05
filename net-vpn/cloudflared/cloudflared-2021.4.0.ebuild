# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

EGO_PN="github.com/cloudflare/${PN}"

EGO_SUM=(
)

go-module_set_globals

DESCRIPTION="Argo Tunnel client, written in GoLang"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+="${EGO_SUM_SRC_URI}"
RESTRICT="mirror"

LICENSE="Cloudflare"
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
		go build -o "bin/${PN}" -mod=vendor -v -work -x ${build_flags} \
			-ldflags "-X \"main.Version=${PV}\" -X \"main.BuildTime=$(date -u '+%Y-%m-%d-%H%M UTC')\"" \
			${EGO_PN}/cmd/${PN}
	echo "$@"
	"$@" || die
}

src_install() {
	dobin bin/${PN}
	insinto /etc/cloudflared
	doins "${FILESDIR}"/config.yml
	newinitd "${FILESDIR}"/cloudflared.initd cloudflared
	newconfd "${FILESDIR}"/cloudflared.confd cloudflared
	systemd_dounit "${FILESDIR}"/cloudflared.service
}
