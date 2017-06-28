# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/mheese"
GOLANG_PKG_USE_CGO=1

GOLANG_PKG_DEPENDENCIES=(
	"github.com/Shopify/sarama:c01858a"
	"github.com/coreos/go-systemd:1f9909e"
	"github.com/coreos/pkg:8dbaa49"
	"github.com/davecgh/go-spew:346938d"
	"github.com/eapache/go-resiliency:b86b1ec"
	"github.com/eapache/go-xerial-snappy:bb955e0"
	"github.com/eapache/queue:44cc805"
	"github.com/elastic/beats:d73106d"
	"github.com/elastic/go-lumber:616041e"
	"github.com/elastic/go-ucfg:ec8488a"
	"github.com/garyburd/redigo:4339695"
	"github.com/golang/snappy:553a641"
	"github.com/joeshaw/multierror:69b34d4"
	"github.com/klauspost/compress:e80ca55"
	"github.com/klauspost/cpuid:09cded8"
	"github.com/mitchellh/hashstructure:9204ce5"
	"github.com/nranchev/go-libGeoIP:c78e8bd"
	"github.com/pierrec/lz4:88df279"
	"github.com/pierrec/xxHash:5a00444"
	"github.com/pkg/errors:c605e28"
	"github.com/rcrowley/go-metrics:1f30fe9"
	"github.com/satori/go.uuid:5bf94b6"
	"github.com/golang/net:3405706 -> golang.org/x"
	"github.com/golang/sys:98b5b1e -> golang.org/x"
	"github.com/go-yaml/yaml:cd8b52f -> gopkg.in/yaml.v2"
)

inherit systemd golang-single

DESCRIPTION="Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch"
HOMEPAGE="https://github.com/mheese/journalbeat"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

src_install() {
	# Install the package
	golang-single_src_install

	keepdir /var/{lib,log}/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	# Install systemd/init.d services
	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	insinto "/etc/${PN}"
	doins etc/journalbeat.yml

	doexe "${GOBIN}"/*
}
