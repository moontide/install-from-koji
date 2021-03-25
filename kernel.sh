echo "--------------------------------------------------"
echo "参数 1: kernel 版本号（如：4.17.9）"
echo "参数 2: kernel 编译号（如：200.fc28）"
echo ""
echo "指定 kernel-tools 版本号、编译号："
echo "  /tools <kernel-tools 版本号> <kernel-tools 编译号>"
echo "kernel-tools 从 kernel 4.15 开始分离成单独的包的，kernel 4.15 之前的不需要指定这个版本号"
echo ""
echo "指定 kernel-headers 版本号、编译号："
echo "  /headers <kernel-headers 版本号> <kernel-headers 编译号>"
echo "kernel-headers 是从 kernel 4.17.11 开始分离成单独的包的，kernel 4.17.11 之前的不需要指定这个版本号"
echo "另外，kernel-headers 编译号（如：1.fc28）跟 kernel 编译号的不同，kernel-headers 编译号都是从 1 开始的，也就是说，没有在 kernel-headers 加入 fedora 特定的更改"
echo "--------------------------------------------------"
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
version_number3=$(($major_version*1000000+$minor_version*1000+${version_array[2]:-0}))	# 根据大版本号、小版本号、最小版本号，生成数值，每个版本号最多允许 3 位数（即：1000个版本号  -->  *1000）

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
has_tools_libs=$(rpm -qa kernel-tools-libs)

#if [[ "$version_number" -ge 10#004015 ]]	# 从 kernel-4.15 开始，kernel-tools 和 kernel-tools-libs 移到了 kernel-tools 包里
#if [[ "$version_number3" -ge 10#004017011 ]]	# 从 kernel-4.17.11 开始，kernel-headers 移到了 kernel-headers 包里，但是：不是每个版本号都会有对应的 kernel-headers 包（猜测这也是为什么要分离的原因？）
if [[ "$1" == ?tools ]]
then
	shift
	kernel_tools_version=${1:-${version}}
	kernel_tools_release=${2:-${revision}}
	shift 2
elif [[ "$1" == ?headers ]]
then
	shift
	kernel_headers_version=${1:-${version}}
	kernel_headers_release=${2:-1.fc${distro_version_number}}
	shift 2
else
	kernel_tools_version=${version}
	kernel_tools_release=${revision}
	kernel_headers_version=${version}
	kernel_headers_release=${revision}
fi


if [[ "$version_number3" -ge 10#004017011 ]]	# 从 kernel-4.17.11 开始，kernel-headers 移到了 kernel-headers 包里，但是：不是每个版本号都会有对应的 kernel-headers 包（猜测这也是为什么要分离的原因？）
then
	optional_packages_params="${has_devel:+rpm=kernel${PAE}-devel}    ${has_modules_extra:+rpm=kernel${PAE}-modules-extra}    ${has_headers:+p=kernel-headers,v=${kernel_headers_version},r=${kernel_headers_release},rpm=kernel-headers}    ${has_tools:+p=kernel-tools,rpm=kernel-tools,v=${kernel_tools_version}}    ${has_tools_libs:+p=kernel-tools,rpm=kernel-tools-libs}"
	echo "Installed kernel${PAE}- packages: ${optional_packages_params//rpm=/}"
	$dir/install-packages-from-koji.sh  $*    p=$package,v=$version,r=$release,rpm=$package${PAE}    rpm=$package${PAE}-{core,modules}    $optional_packages_params
elif [[ "$version_number" -ge 10#003015  &&  "$distro_version_number" -ge 21 ]]; then
	#_core=$(rpm -qa kernel${PAE}-core)
	#_modules=$(rpm -qa kernel${PAE}-modules)
	optional_packages_params="${has_devel:+rpm=kernel${PAE}-devel}    ${has_headers:+rpm=kernel-headers}    ${has_modules_extra:+rpm=kernel${PAE}-modules-extra}    ${has_tools:+p=kernel-tools,rpm=kernel-tools,v=${kernel_tools_version}}    ${${has_tools_libs:+p=kernel-tools,rpm=kernel-tools-libs}"
	echo "Installed kernel${PAE}- packages: ${optional_packages_params//rpm=/}"
	# Fedora 21 从 3.15 开始， kernel 分成了 kernel${PAE}-core kernel${PAE}-modules 几个子包，所以需要特别处理
	$dir/install-packages-from-koji.sh  $*    p=$package,v=$version,r=$release,rpm=$package${PAE}    rpm=$package${PAE}-{core,modules}    $optional_packages_params
else
	optional_packages_params="${has_devel:+rpm=kernel${PAE}-devel}    ${has_headers:+rpm=kernel-headers}    ${has_modules_extra:+rpm=kernel${PAE}-modules-extra}    ${has_tools:+rpm=kernel-tools}    ${has_tools_libs:+rpm=kernel-tools-libs}"
	echo "Installed kernel${PAE}- packages: ${optional_packages_params//rpm=/}"
	$dir/install-packages-from-koji.sh  $*    p=$package,v=$version,r=$release,rpm=$package${PAE}    $optional_packages_params
fi
