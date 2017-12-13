# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy{,3} )

inherit distutils-r1 systemd

GITHUB_USER="GoogleCloudPlatform"
MY_PN="compute-image-packages"
MY_TAG="20171129"

DESCRIPTION="Scripts and tools for Google Compute Engine Linux images."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-accounts-daemon -> google-accounts-daemon.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-accounts-daemon.service -> google-accounts-daemon.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-clock-skew-daemon -> google-clock-skew-daemon.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-clock-skew-daemon.service -> google-clock-skew-daemon.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-instance-setup -> google-instance-setup.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-instance-setup.service -> google-instance-setup.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-ip-forwarding-daemon -> google-ip-forwarding-daemon.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-ip-forwarding-daemon.service -> google-ip-forwarding-daemon.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-network-setup -> google-network-setup.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-network-setup.service -> google-network-setup.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-shutdown-scripts -> google-shutdown-scripts.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-shutdown-scripts.service -> google-shutdown-scripts.service.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/sysvinit/google-startup-scripts -> google-startup-scripts.${MY_TAG}
		https://raw.githubusercontent.com/${GITHUB_USER}/${MY_PN}/${MY_TAG}/google_compute_engine_init/systemd/google-startup-scripts.service -> google-startup-scripts.service.${MY_TAG}"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
    dev-python/boto[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
    dev-python/setuptools[${PYTHON_USEDEP}]
"

INIT=(
	"google-accounts-daemon"
	"google-clock-skew-daemon"
	"google-instance-setup"
	"google-ip-forwarding-daemon"
	"google-network-setup"
	"google-shutdown-scripts"
	"google-startup-scripts")

python_install_all() {
	for _s in "${INIT[@]}"
	do
		newinitd "${DISTDIR}/${_s}.${MY_TAG}" "${_s}"
		systemd_newunit "${DISTDIR}/${_s}.service.${MY_TAG}" "${_s}.service"
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
	ewarn "    systemctl stop --no-block google-ip-forwarding-daemon"
	ewarn
	ewarn "    # Enable systemd services."
	ewarn "    systemctl enable google-accounts-daemon.service"
	ewarn "    systemctl enable google-clock-skew-daemon.service"
	ewarn "    systemctl enable google-instance-setup.service"
	ewarn "    systemctl enable google-ip-forwarding-daemon.service"
	ewarn "    systemctl enable google-network-setup.service"
	ewarn "    systemctl enable google-shutdown-scripts.service"
	ewarn "    systemctl enable google-startup-scripts.service"
	ewarn
	ewarn "    # Run instance setup manually to prevent startup script execution."
	ewarn "    /usr/bin/google_instance_setup"
	ewarn
	ewarn "    # Enable network interfaces."
	ewarn "    /usr/bin/google_network_setup"
	ewarn
	ewarn "    # Start daemons."
	ewarn "    systemctl start --no-block google-accounts-daemon"
	ewarn "    systemctl start --no-block google-clock-skew-daemon"
	ewarn "    systemctl start --no-block google-ip-forwarding-daemon"
	ewarn
}
