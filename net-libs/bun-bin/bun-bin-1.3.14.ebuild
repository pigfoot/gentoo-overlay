# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Bun is a fast all-in-one JavaScript runtime & toolkit"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"
SRC_URI="
    amd64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64.zip -> ${P}-amd64.zip )
    arm64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-aarch64.zip -> ${P}-arm64.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="mirror strip"
IUSE=""

BDEPEND="
    app-arch/unzip
"
DEPEND="
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/bun"

src_prepare() {
	echo "pwd:`pwd`"
    default
    mv bun-linux*/bun . || die "Failed to move bun binary"
    # generate shell completion scripts
    for sh in bash fish zsh; do
      env SHELL=${sh} "${S}/bun" completions ${sh} > "${WORKDIR}/completion.${sh}"
    done
}

src_install() {
    dobin bun
    dosym bun /usr/bin/bunx

    newbashcomp completion.bash "${PN}"
    newfishcomp completion.fish "${PN}".fish
    newzshcomp completion.zsh _"${PN}"
}
