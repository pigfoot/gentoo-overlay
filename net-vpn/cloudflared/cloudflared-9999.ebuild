# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/cloudflare/${PN}"

inherit go-module systemd

if [[ ${PV} == *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://${EGO_PN}.git"

    src_unpack() {
        git-r3_src_unpack
        #go-module_live_vendor
    }
else
    EGO_VER="${P}"
    SRC_URI="https://${EGO_PN}/archive/${EGO_VER}.tar.gz -> ${P}.tar.gz"

    EGO_SUM=(
    )
    go-module_set_globals

    SRC_URI+="${EGO_SUM_SRC_URI}"
    S="${WORKDIR}/${EGO_VER}"
fi

DESCRIPTION="Argo Tunnel client, written in GoLang"
LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86 ~arm"
RESTRICT="mirror"
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
