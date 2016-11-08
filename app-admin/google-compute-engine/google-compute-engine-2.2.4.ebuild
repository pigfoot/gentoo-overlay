# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )

inherit distutils-r1 systemd

DESCRIPTION="Scripts and tools for Google Compute Engine Linux images."
HOMEPAGE="https://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

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


python_install_all() {
	for _s in google-accounts-daemon \
		     google-clock-skew-daemon \
		     google-instance-setup \
		     google-ip-forwarding-daemon \
		     google-network-setup \
		     google-shutdown-scripts \
		     google-startup-scripts;
    do
    	newinitd "${FILESDIR}/sysvinit/${_s}-20160803" "${_s}"
    	systemd_newunit "${FILESDIR}/systemd/${_s}.service-20160803" "${_s}.service"
    done

    # Install google-compute-engine python modules.
    distutils-r1_python_install_all
}
