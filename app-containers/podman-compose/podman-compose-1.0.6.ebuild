# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit python-r1 bash-completion-r1

DESCRIPTION="a script to run docker-compose.yml using podman"
HOMEPAGE="https://github.com/containers/podman-compose"
SRC_URI="https://github.com/containers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
    dev-python/pyyaml[${PYTHON_USEDEP}]
    dev-python/python-dotenv[${PYTHON_USEDEP}]
"
RDEPEND="${PYTHON_DEPS}
    app-containers/podman
    ${BDEPEND}"

src_install() {
	newbin podman_compose.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
	newbashcomp completion/bash/podman-compose ${PN}
}
