# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_NAME=l_mkl
INTEL_DIST_SKU=11544
INTEL_DIST_PV=2017.3.196
INTEL_SKIP_LICENSE=true

NUMERIC_MODULE_NAME=${PN}

inherit alternatives-2 intel-sdp-r1 numeric-int64-multibuild

DESCRIPTION="Intel Math Kernel Library: linear algebra, fft, math functions"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-mkl/"

IUSE="doc examples mic"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND=""

CHECKREQS_DISK_BUILD=900M

INTEL_DIST_BIN_RPMS=()
INTEL_DIST_X86_RPMS=()
INTEL_DIST_AMD64_RPMS=(
	"mkl"
	"mkl-common-c-64bit"
	"mkl-gnu"
	"mkl-gnu-c"
	"mkl-gnu-rt"
	"mkl-ps-cluster-64bit"
	"mkl-ps-cluster-rt"
	"mkl-ps-common-64bit"
	"mkl-ps-common-f-64bit"
	"mkl-ps-f95"
	"mkl-ps-f95-mic"
	"mkl-ps-gnu-f"
	"mkl-ps-gnu-f-rt"
	"mkl-ps-pgi"
	"mkl-ps-pgi-c"
	"mkl-ps-pgi-f"
	"mkl-ps-pgi-rt"
	"mkl-ps-ss-tbb"
	"mkl-ps-ss-tbb-rt"
	"mkl-rt"
	"openmp-l-all-196-17.0.4-196.x86_64.rpm"
	"openmp-l-ps-libs-196-17.0.4-196.x86_64.rpm")
INTEL_DIST_DAT_RPMS=(
	"mkl-common"
	"mkl-common-c"
	"mkl-ps-cluster"
	"mkl-ps-cluster-c"
	"mkl-ps-cluster-f"
	"mkl-ps-common"
	"mkl-ps-common-c"
	"mkl-ps-common-f"
	"mkl-ps-f95-common"
	#"comp-l-all-vars-196-17.0.4-196.noarch.rpm"
	#"compxe-pset-056-2017.4-056.noarch.rpm"
	"mkl-psxe-056-2017.3-056.noarch.rpm"
	"mkl-sta-common")
	#"psxe-common-056-2017.4-056.noarch.rpm"
	#"tbb-libs-196-2017.6-196.noarch.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( 
			"mkl-doc"
			"mkl-doc-c"
			"mkl-ps-doc"
			"mkl-ps-doc-f")
	fi

	if use mic; then
		INTEL_DIST_AMD64_RPMS+=( 
			"mkl-ps-mic"
			"mkl-ps-mic-c"
			"mkl-ps-mic-cluster"
			"mkl-ps-mic-cluster-rt"
			"mkl-ps-mic-f"
			"mkl-ps-mic-rt"
			"mkl-ps-tbb-mic"
			"mkl-ps-tbb-mic-rt")
	fi
}

src_prepare() {
	default
	chmod u+w -R opt || die
}

_mkl_add_pc_file() {
	local pcname=${1} cflags="" suffix=""
	shift
	numeric-int64_is_int64_build && cflags=-DMKL_ILP64 && suffix="-int64"

	local IARCH=$(isdp_convert2intel-arch ${MULTIBUILD_ID})

	create_pkgconfig \
		--prefix "$(isdp_get-sdp-edir)/linux/mkl" \
		--libdir "\${prefix}/lib/${IARCH}" \
		--includedir "\${prefix}/include" \
		--name ${pcname} \
		--libs "-L\${libdir} -L$(isdp_get-sdp-edir)/linux/compiler/lib/${IARCH} $* -lpthread -lm" \
		--cflags "-I\${includedir} ${cflags}" \
		${pcname}${suffix}
}

_mkl_add_alternative_provider() {
	local prov=$1; shift
	local alt
	for alt in $*; do
		NUMERIC_MODULE_NAME=${prov} \
			numeric-int64-multibuild_install_alternative ${alt} ${prov}
	done
}

# help: http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/
mkl_add_pc_file() {
	local bits=""
	[[ ${MULTIBUILD_ID} =~ amd64 ]] && bits=_lp64
	numeric-int64_is_int64_build && bits=_ilp64

	local gf="-Wl,--no-as-needed -Wl,--start-group -lmkl_gf${bits}"
	local gc="-Wl,--no-as-needed -Wl,--start-group -lmkl_intel${bits}"
	local intel="-Wl,--start-group -lmkl_intel${bits}"
	local core="-lmkl_core -Wl,--end-group"

	# blas lapack cblas lapacke
	_mkl_add_pc_file mkl-gfortran ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-openmp ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-intel-openmp ${intel} -lmkl_intel_thread ${core} -openmp
	_mkl_add_pc_file mkl-dynamic -lmkl_rt
	_mkl_add_pc_file mkl-dynamic-openmp -lmkl_rt -liomp5

	# blacs and scalapack
	local scal="-lmkl_scalapack${bits:-_core}"
	local blacs="-lmkl_blacs_intelmpi${bits}"
	core="-lmkl_core ${blacs} -Wl,--end-group"

	_mkl_add_pc_file mkl-gfortran-blacs ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-scalapack ${scal} ${gf} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel-blacs ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-intel-scalapack ${scal} ${intel} -lmkl_sequential ${core}
	_mkl_add_pc_file mkl-gfortran-openmp-blacs ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gfortran-openmp-scalapack ${scal} ${gf} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp-blacs ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-gcc-openmp-scalapack ${scal} ${gc} -lmkl_gnu_thread ${core} -fopenmp
	_mkl_add_pc_file mkl-intel-openmp-blacs ${intel} -lmkl_intel_thread ${core} -liomp5
	_mkl_add_pc_file mkl-intel-openmp-scalapack ${scal} ${intel} -lmkl_intel_thread ${core} -liomp5
	_mkl_add_pc_file mkl-dynamic-blacs -lmkl_rt ${blacs}
	_mkl_add_pc_file mkl-dynamic-scalapack ${scal} -lmkl_rt ${blacs}
	_mkl_add_pc_file mkl-dynamic-openmp-blacs -lmkl_rt ${blacs} -liomp5
	_mkl_add_pc_file mkl-dynamic-openmp-scalapack ${scal} -lmkl_rt ${blacs} -liomp5
}

mkl_add_alternative_provider() {
	# blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-gfortran blas lapack
	_mkl_add_alternative_provider mkl-intel blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-gfortran-openmp blas lapack
	_mkl_add_alternative_provider mkl-gcc-openmp cblas lapacke
	_mkl_add_alternative_provider mkl-intel-openmp blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-dynamic blas lapack cblas lapacke
	_mkl_add_alternative_provider mkl-dynamic-openmp blas lapack cblas lapacke

	# blacs and scalapack
	_mkl_add_alternative_provider mkl-gfortran-blacs blacs
	_mkl_add_alternative_provider mkl-gfortran-scalapack scalapack
	_mkl_add_alternative_provider mkl-intel-blacs blacs
	_mkl_add_alternative_provider mkl-intel-scalapack scalapack
	_mkl_add_alternative_provider mkl-gfortran-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-gfortran-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-gcc-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-gcc-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-intel-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-intel-openmp-scalapack scalapack
	_mkl_add_alternative_provider mkl-dynamic-blacs blacs
	_mkl_add_alternative_provider mkl-dynamic-scalapack scalapack
	_mkl_add_alternative_provider mkl-dynamic-openmp-blacs blacs
	_mkl_add_alternative_provider mkl-dynamic-openmp-scalapack scalapack
}

src_install() {
	local IARCH
	local ldpath="LDPATH="
	intel-sdp-r1_src_install

	numeric-int64-multibuild_foreach_all_abi_variants mkl_add_pc_file
	mkl_add_alternative_provider

	use abi_x86_64 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_64)"
	use abi_x86_32 && ldpath+=":$(isdp_get-sdp-edir)/linux/mkl/lib/$(isdp_convert2intel-arch abi_x86_32)"

	echo "${ldpath}" > "${T}"/35mkl || die
	doenvd "${T}"/35mkl
}
