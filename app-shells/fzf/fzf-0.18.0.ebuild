# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/junegunn/${PN}"
EGO_VENDOR=(
	"github.com/mattn/go-isatty 66b8e73f3f5c"
	"github.com/mattn/go-runewidth 14207d285c6c"
	"github.com/mattn/go-shellwords v1.0.3"
	"golang.org/x/crypto 558b6879de74 github.com/golang/crypto"
	"golang.org/x/sys b90f89a1e7a9 github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot bash-completion-r1

DESCRIPTION="A general-purpose command-line fuzzy finder, written in GoLang"
ARCHIVE_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
SRC_URI="${ARCHIVE_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE="bash-completion fish-completion neovim +pie tmux vim zsh-completion"

RDEPEND="bash-completion? ( app-shells/bash )
	fish-completion? ( app-shells/fish )
	tmux? ( app-misc/tmux )
	vim? ( app-editors/vim )
	zsh-completion? ( app-shells/zsh )"

src_compile() {
	use pie && local build_pie="-buildmode=pie"
	local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		CGO_ENABLED=0 \
		GO111MODULE=off \
		go install -v -work -x ${build_flags} ${EGO_PN}
	echo "$@"
	"$@" || die

	local go_srcpath="${WORKDIR}/${P}/src/${EGO_PN}"

	doman ${go_srcpath}/man/man1/${PN}.1

	# Install bash completion files
	if use bash-completion; then
		newbashcomp ${go_srcpath}/shell/completion.bash ${PN}
		insinto /etc/profile.d/
		newins ${go_srcpath}/shell/key-bindings.bash ${PN}.sh
	fi

	# Install fish completion files
	if use fish-completion; then
		insinto /usr/share/fish/functions/
		newins ${go_srcpath}/shell/key-bindings.fish fzf_key_bindings.fish
	fi

	# Install Neovim plugin
	if use neovim; then
		insinto /usr/share/nvim/runtime/plugin
		doins ${go_srcpath}/plugin/${PN}.vim
	fi

	# Install TMUX utils
	if use tmux; then
		dobin ${go_srcpath}/bin/${PN}-tmux
		doman ${go_srcpath}/man/man1/${PN}-tmux.1
	fi

	# Install VIM plugin
	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins ${go_srcpath}/plugin/${PN}.vim
	fi

	# Install zsh completion files
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins ${go_srcpath}/shell/completion.zsh _${PN}
		insinto /usr/share/zsh/site-contrib/
		newins ${go_srcpath}/shell/key-bindings.zsh ${PN}.zsh
	fi
}

src_install() {
	dobin bin/*
}
