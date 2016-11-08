# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/jakm"
GOLANG_PKG_ARCHIVEPREFIX=""
GOLANG_PKG_HAVE_TEST=1

GOLANG_PKG_DEPENDENCIES=(
	"github.com/docopt/docopt-go:854c423 -> github.com/docopt/docopt-go" #0.6.1-5-g854c423
	"github.com/ugorji/go:8a2a3a8"
)

inherit golang-single

DESCRIPTION="CLI tool to encoding/decoding data to/from MessagePack format and calling RPC via msgpack-rpc / msgpack.org[Shell]"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 arm"