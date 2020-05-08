# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 systemd

MY_PN="github.com/GoogleCloudPlatform/compute-image-packages"
MY_P="${P}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${MY_PN}"
	EGIT_SUBMODULES=()
else
	EGIT_COMMIT="v${PV}"
	MY_P="compute-image-packages-tags-${EGIT_COMMIT}"
	SRC_URI="https://${MY_PN}/archive/tags/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-accounts-daemon -> google-accounts-daemon.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-accounts-daemon.service -> google-accounts-daemon.service.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-clock-skew-daemon -> google-clock-skew-daemon.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-clock-skew-daemon.service -> google-clock-skew-daemon.service.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-instance-setup -> google-instance-setup.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-instance-setup.service -> google-instance-setup.service.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-network-daemon -> google-network-daemon.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-network-daemon.service -> google-network-daemon.service.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-shutdown-scripts -> google-shutdown-scripts.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-shutdown-scripts.service -> google-shutdown-scripts.service.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/sysvinit/google-startup-scripts -> google-startup-scripts.${EGIT_COMMIT}
		https://${MY_PN}/raw/20190124/google_compute_engine_init/systemd/google-startup-scripts.service -> google-startup-scripts.service.${EGIT_COMMIT}"
fi

DESCRIPTION="Scripts and tools for Google Compute Engine Linux images."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="mirror"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/distro[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/packages/python-google-compute-engine"

INIT=(
	"google-accounts-daemon"
	"google-clock-skew-daemon"
	"google-instance-setup"
	"google-network-daemon"
	"google-shutdown-scripts"
	"google-startup-scripts")

python_install_all() {
	for _s in "${INIT[@]}"
	do
		newinitd "${DISTDIR}/${_s}.${EGIT_COMMIT}" "${_s}"
		systemd_newunit "${DISTDIR}/${_s}.service.${EGIT_COMMIT}" "${_s}.service"
	done

	# Install google-compute-engine python modules.
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn
	ewarn "Systems using systemd can do the following:"
	ewarn "    # Stop existing daemons."
	ewarn "    systemctl stop --no-block google-accounts-daemon"
	ewarn "    systemctl stop --no-block google-clock-skew-daemon"
	ewarn "    systemctl stop --no-block google-network-daemon"
	ewarn
	ewarn "    # Enable systemd services."
	ewarn "    systemctl enable google-accounts-daemon.service"
	ewarn "    systemctl enable google-clock-skew-daemon.service"
	ewarn "    systemctl enable google-instance-setup.service"
	ewarn "    systemctl enable google-network-daemon.service"
	ewarn "    systemctl enable google-shutdown-scripts.service"
	ewarn "    systemctl enable google-startup-scripts.service"
	ewarn
	ewarn "    # Run instance setup manually to prevent startup script execution."
	ewarn "    /usr/bin/google_instance_setup"
	ewarn
	ewarn "    # Start daemons."
	ewarn "    systemctl start --no-block google-network-daemon"
	ewarn "    systemctl start --no-block google-accounts-daemon"
	ewarn "    systemctl start --no-block google-clock-skew-daemon"
	ewarn
}
