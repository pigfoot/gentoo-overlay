# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver systemd

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/go-1.9.2"

S="${WORKDIR}/src/github.com/elastic/beats"

src_unpack() {
	mkdir -p "${S%/*}" || die
	default
	mv beats-${PV} "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}" emake -C "${S}/metricbeat"
	GOPATH="${WORKDIR}" emake fields -C "${S}/metricbeat"
}

src_install() {
	keepdir /var/{lib,log}/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	dobin metricbeat/metricbeat

	docinto examples
	dodoc ${PN}/{metricbeat.yml,metricbeat.reference.yml}

	insinto "/etc/${PN}"
	doins ${PN}/metricbeat.yml
	newins ${PN}/_meta/fields.generated.yml fields.yml
	insinto "/etc/${PN}/module"
	doins -r ${PN}/module/*
	insinto "/etc/${PN}/modules.d"
	doins -r ${PN}/modules.d/*
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "Please read the migration guide at:"
		elog "https://www.elastic.co/guide/en/beats/libbeat/$(ver_cut 1-2)/upgrading.html"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT%/}/usr/share/doc/${PF}/examples"
}
