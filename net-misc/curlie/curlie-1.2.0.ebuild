# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/rs"
GOLANG_PKG_VERSION="2285fb6be0659b7fe1f78de488033a2ef630baf1"
GOLANG_PKG_HAVE_TEST=1

GOLANG_PKG_DEPENDENCIES=(
	"github.com/akamensky/argparse:99676ba"
	"github.com/jessevdk/go-flags:c6ca198"

	"github.com/golang/crypto:159ae71 -> golang.org/x"
	"github.com/golang/sys:3135538 -> golang.org/x"
)

inherit golang-single

DESCRIPTION="The power of curl, the ease of use of httpie, written in GoLang"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
