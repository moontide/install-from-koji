echo "参数 1: kernel 版本号（如：4.17.9）"
echo "参数 2: kernel 编译号（如：200.fc28）"
echo "参数 3: kernel-tools 版本号。注意：kernel-tools 是从 kernel 4.15 开始分离成单独的包的，kernel 4.15 之前的不需要指定这个版本号"
echo "参数 4: kernel-tools 编译号"
dir=$(dirname $0)
package=kernel
version="$1"
release="$2"
#arch=x86_64

shift 2

version_array=(${version//\./ })
major_version=${version_array[0]}
minor_version=${version_array[1]}
distro_version_number=$(echo "$release" | grep -oP  '\d+$')
echo "major=$major_version,minor=$minor_version"
echo "distro_ver=$distro_version_number"
version_number=$(($major_version*1000+$minor_version))	# 根据大版本号、小版本号，生成数值，每个版本号最多允许 3 位数（即：1000个版本号  -->  *1000）

PAE=$(uname -r)
if [[ $PAE = *PAE ]]
then
	PAE="-PAE"
	echo "this is PAE variant"
else
	PAE=
fi

has_devel=$(rpm -qa kernel${PAE}-devel)
has_headers=$(rpm -qa kernel-headers)
has_modules_extra=$(rpm -qa kernel${PAE}-modules-extra)
has_tools=$(rpm -qa kernel-tools)
if [[ "$version_number" -ge 10#004015 ]]	# 从 kernel-4.15 开始，kernel-tools 和 kernel-tools-libs 移到了 kernel-tools 包里
then
	if [[ ! -z "$1" && ! "$1" == ?install && ! "$1" == ?download ]]
	then
		kernel_tools_version=${1:-$version}
		shift
	fi
	if [[ ! -z "$1" && ! "$1" == ?install && ! "$1" == ?download ]]
	then
		kernel_tools_release=${2:-$release}
		shift
	fi
else
	kernel_tools_version=$version
	kernel_tools_release=$release
fi


if [[ "$version_number" -ge 10#003015  &&  "$distro_version_number" -ge 21 ]]; then
	#_core=$(rpm -qa kernel${PAE}-core)
	#_modules=$(rpm -qa kernel${PAE}-modules)
	optional_packages_params="${has_devel:+rpm=kernel${PAE}-devel}    ${has_headers:+rpm=kernel-headers}    ${has_modules_extra:+rpm=kernel${PAE}-modules-extra}    ${has_tools:+p=kernel-tools,rpm=kernel-tools,v=${kernel_tools_version}}    ${has_tools:+p=kernel-tools,rpm=kernel-tools-libs}"
	echo "Installed kernel${PAE}- packages: ${optional_packages_params//rpm=/}"
	# Fedora 21 从 3.15 开始， kernel 分成了 kernel${PAE}-core kernel${PAE}-modules 几个子包，所以需要特别处理
	$dir/install-packages-from-koji.sh  $*    p=$package,v=$version,r=$release,rpm=$package${PAE}    rpm=$package${PAE}-{core,modules}    $optional_packages_params
else
	optional_packages_params="${has_devel:+rpm=kernel${PAE}-devel}    ${has_headers:+rpm=kernel-headers}    ${has_modules_extra:+rpm=kernel${PAE}-modules-extra}    ${has_tools:+rpm=kernel-tools}    ${has_tools:+rpm=kernel-tools-libs}"
	echo "Installed kernel${PAE}- packages: ${optional_packages_params//rpm=/}"
	$dir/install-packages-from-koji.sh  $*    p=$package,v=$version,r=$release,rpm=$package${PAE}    $optional_packages_params
fi
