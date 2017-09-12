# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/mheese"
GOLANG_PKG_USE_CGO=1
GOLANG_PKG_ARCHIVEPREFIX="v"

GOLANG_PKG_DEPENDENCIES=(
	"github.com/Shopify/sarama:1517403"
	"github.com/coreos/go-systemd:d219646"
	"github.com/coreos/pkg:459346e"
	"github.com/danwakefield/fnmatch:cbb64ac"
	"github.com/davecgh/go-spew:a476722"
	"github.com/eapache/go-resiliency:b1fe83b"
	"github.com/eapache/go-xerial-snappy:bb955e0"
	"github.com/eapache/queue:44cc805"
	"github.com/elastic/beats:74bfb8f"
	"github.com/elastic/go-lumber:616041e"
	"github.com/elastic/go-ucfg:ec8488a"
	"github.com/garyburd/redigo:b925df3"
	"github.com/golang/snappy:553a641"
	"github.com/joeshaw/multierror:69b34d4"
	"github.com/klauspost/compress:f3dce52"
	"github.com/klauspost/cpuid:ae7887d"
	"github.com/mitchellh/hashstructure:2bca23e"
	"github.com/nranchev/go-libGeoIP:d6d4a9a"
	"github.com/pierrec/lz4:08c2793"
	"github.com/pierrec/xxHash:a0006b1"
	"github.com/pkg/errors:c605e28"
	"github.com/rcrowley/go-metrics:1f30fe9"
	"github.com/satori/go.uuid:5bf94b6"
	"github.com/golang/net:66aacef -> golang.org/x"
	"github.com/golang/sys:9aade4d -> golang.org/x"
	"github.com/go-yaml/yaml:eb3733d -> gopkg.in/yaml.v2"
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
