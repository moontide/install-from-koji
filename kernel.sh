dir=$(dirname $0)
package=kernel
version="$1"
release="$2"
#arch=x86_64

version_array=(${version//\./ })
major_version=${version_array[0]}
minor_version=${version_array[1]}
distro_version_number=$(echo "$release" | grep -oP  '\d+$')
echo "major=$major_version,minor=$minor_version"
echo "distro_ver=$distro_version_number"
version_number=$(($major_version*1000+$minor_version))	# 根据大版本号、小版本号，生成数值，每个版本号最多允许 3 位数（即：1000个版本号  -->  *1000）


_devel=$(rpm -qa kernel-devel)
_headers=$(rpm -qa kernel-headers)
_modules_extra=$(rpm -qa kernel-modules-extra)


if [[ "$version_number" -ge 10#003015  &&  "$distro_version_number" -ge 21 ]]; then
	#_core=$(rpm -qa kernel-core)
	#_modules=$(rpm -qa kernel-modules)
	_installed_packages_params="${_devel:+rpm=kernel-devel}    ${_headers:+rpm=kernel-headers}    ${_modules_extra:+rpm=kernel-modules-extra}"
	echo "Installed kernel- packages: ${_installed_packages_params//rpm=/}"
	# Fedora 21 从 3.15 开始， kernel 分成了 kernel-core kernel-modules 几个子包，所以需要特别处理
	$dir/install-packages-from-koji.sh    p=$package,v=$version,r=$release    rpm=$package-core    rpm=$package-modules    $_installed_packages_params
else
	_installed_packages_params="${_devel:+rpm=kernel-devel}  ${_headers:+rpm=kernel-headers}  ${_modules_extra:+rpm=kernel-modules-extra}"
	echo "Installed kernel- packages: ${_installed_packages_params//rpm=/}"
	$dir/install-packages-from-koji.sh    p=$package,v=$version,r=$release    $_installed_packages_params
fi
