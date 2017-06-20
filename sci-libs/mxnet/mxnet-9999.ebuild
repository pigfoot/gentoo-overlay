# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
DISTUTILS_OPTIONAL=1
inherit cmake-utils eutils distutils-r1 git-r3

DESCRIPTION="Flexible and Efficient Library for Deep Learning"
HOMEPAGE="http://mxnet.io/"
EGIT_REPO_URI="https://github.com/dmlc/mxnet"
#EGIT_SUBMODULES=( "*" "-dmlc-core" "-nnvm" "-ps-lite" )

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="cuda distributed opencv openmp python +mxnet_blas_mkl mxnet_blas_openblas mxnet_blas_atlas"

RDEPEND="
	sys-devel/gcc[cxx,openmp=]
	mxnet_blas_mkl? ( ~sci-libs/mkl-2017 )
	mxnet_blas_openblas? ( sci-libs/openblas )
	mxnet_blas_atlas? ( sci-libs/atlas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	distributed? ( sci-libs/ps-lite )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	^^ (
		mxnet_blas_mkl
		mxnet_blas_openblas
		mxnet_blas_atlas
	)"

#PATCHES=( "${FILESDIR}/${P}-build-fix.patch" "${FILESDIR}/${P}-fix-python-stupid.patch" )
#PATCHES=( "${FILESDIR}/${P}-fix-python-stupid.patch" )
PATCHES=( "${FILESDIR}/${P}-build-fix.patch" )

pkg_setup() {
	lsmod|grep -q '^nvidia_uvm'
	if [ $? -ne 0 ] || [ ! -c /dev/nvidia-uvm ]; then
		eerror "Please run: \"nvidia-modprobe -u -c 0\" before attempting to install ${PN}."
		eerror "Otherwise the hardware autodetect will fail and all architecture modules will be built."
	fi
}

src_prepare() {
	default
	if use python; then
		cd "${S}"/python
		distutils-r1_src_prepare
	fi
	if use cuda; then
		cd "${S}"/mshadow
		epatch "${FILESDIR}/${P}-fix-c++11.patch"
	fi
	if use distributed; then
		cd "${S}"
		epatch "${FILESDIR}/${P}-link-shared-zmq.patch"
	fi
}

src_configure() {
	local mycmakeargs=(
		#-DBUILD_SHARED_LIBS=ON
		-DUSE_CUDA=$(usex cuda)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_DIST_KVSTORE=$(usex distributed)
	)

	if use mxnet_blas_mkl; then
		einfo "BLAS provided by Intel Math Kernel Library"
		get_major_version 
		mycmakeargs+=(
			-DBLAS=MKL
			-DUSE_MKLML_MKL=OFF
		)
		export MKL_ROOT=$(find /opt/intel -xtype d -regextype posix-extended -regex '.*compilers_and_libraries_[[:digit:]\.]+/linux/mkl$')
		if [[ -z ${MKL_ROOT} ]]; then
			eerror "Cannot find intel library in /opt/intel."
			return 0
		fi
	elif use mxnet_blas_openblas; then
		einfo "BLAS provided by OpenBLAS"
		mycmakeargs+=( 
			-DBLAS=Open
		)
	elif use mxnet_blas_atlas; then
		einfo "BLAS provided by ATLAS"
		mycmakeargs+=( 
			-DBLAS=Atlas
		)
	fi
	
	addwrite /dev/nvidia-uvm
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0

	cmake-utils_src_configure

	if use python; then
		cd python;
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use python; then
		cd python
		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}"
		distutils-r1_src_compile
	fi
}

src_install() {
	doheader -r include/mxnet

	if use python; then
		cd python
		distutils-r1_src_install
	fi

	cd "${BUILD_DIR}"
	dolib.so libmxnet.so
}
