CSI=$'\e['
DEFAULT_COLOR="${CSI}39m"
DEFAULT_BG_COLOR="${CSI}49m"
DARK_CYAN="${CSI}36m"
CYAN="${CSI}1;36m"
ATTR_OFF="${CSI}m"

OPTION_COLOR="$DARK_CYAN"
OPTION_INSTANCE_COLOR="$CYAN"


dnf_command=update
dnf_options=

usage ()
{
	echo
	echo "Usage: $0 [${OPTION_COLOR}OPTIONS${ATTR_OFF}] p=<package>,rpm=<rpm>,v=<version>,r=<release>[,a=<arch>] [[p=<package>,]rpm=<rpm>[,v=<version>,r=<release>,a=<arch>]]..."
	echo "	${OPTION_COLOR}OPTIONS${ATTR_OFF}"
	echo "		 ${OPTION_INSTANCE_COLOR}/install${ATTR_OFF}	use \`dnf install\` command instead of \`dnf update\`, useful for update package whose name is changed in new version"
	echo "		 ${OPTION_INSTANCE_COLOR}/download${ATTR_OFF}	Download only, it will override "
	echo "	<package>, something like 'kernel'"
	echo "	<rpm>, something like 'kernel-devel', a package can have several rpm. If omitted, it will be \$package name."
	echo "	<version>, something like '3.14.2'"
	echo "	<release>, something like '200.fc20'"
	echo "	<arch>, something like 'x86_84', it can be omitted, then it will use the result of \$(uname -m) command."
	echo
	echo "eg: $0  p=kernel,rpm=kernel-headers,v=3.14.2,r=200.fc20  rpm=kernel-devel  rpm=kernel"
	echo
	echo "Note: if you specified package name in the first group parameters, you can omit it in the rest group parameters, it will inherit from the first one"
	echo "Note 2: all arch can be omitted, if omitted, it will inherit from (1)the previous one (2)or the system default arch (\$ARCH)"
	exit -1
}
# 默认 tab 大小: 4
tabs 4 >/dev/null

default_arch=$(uname -m)
while [[ ! -z "$1" ]]
do
	if [[ "$1" == ?download ]];
	then
		download_only=true
		shift
		continue
	fi

	if [[ "$1" == ?install ]];
	then
		dnf_command=install
		shift
		continue
	fi

	# - -- options 直接加到 dnf/yum 参数里，不做额外处理
	if [[ "$1" == -* ]];
	then
		dnf_options="$dnf_options $1"
		shift
		continue
	fi

	params=(${1//,/ })
echo "${params[*]}"

#reset parameters
package=
rpm=
version=
release=
arch=
	for e in "${params[@]}"
	do
		kv=(${e/=/ })
		k="${kv[0]}"
		v="${kv[1]}"
		if [[ "$k" = "p" ]]; then
			package="$v"
		elif [[ "$k" = "rpm" ]]; then
			rpm="$v"
		elif [[ "$k" = "v" ]]; then
			version="$v"
		elif [[ "$k" = "r" ]]; then
			release="$v"
		elif [[ "$k" = "a" ]]; then
			arch="$v"
		fi
	done
#echo -ne "package=\e[31m$package\e[m"
#echo -ne "	rpm=\e[32m$rpm\e[m"
#echo -ne "	version=\e[33m$version\e[m"
#echo -ne "	release=\e[34m$release\e[m"
#echo -ne "	arch=\e[35m$arch\e[m"
#echo

#echo "处理后，参数变为： After parameter are processed, parameters becomes to:"	
	# 包名
	if [[ -z "$package" ]]; then
		package=${previous_package}
		if [[ -z "$package" ]]; then
			usage
		fi
		package_name_is_inherit_from_previous=true
	else
		# 只有明确指出 arch 参数的，才会放到“前面的 package 参数”中。 下面的几个参数相同
		previous_package=$package
	fi
echo -e "	package=	\e[31m$package\e[m"
	
	# rpm 构建/文件 名
	if [[ -z "$rpm" ]]; then
		#rpm=${previous_rpm}
		rpm=${package}
		if [[ -z "$rpm" ]]; then
			usage
		fi
		rpm_name_is_inherit_from_package_name=true
	else
		previous_rpm=$rpm
	fi
echo -e "	rpm=		\e[32m$rpm\e[m"
	
	# 版本/大版本
	if [[ -z "$version" ]]; then
		version=${previous_version}
		if [[ -z "$version" ]]; then
			usage
		fi
		version_is_inherit_from_previous=true
	else
		previous_version=$version
	fi
echo -e "	version=	\e[33m$version\e[m"
	
	# 发布号/小版本
	if [[ -z "$release" ]]; then
		release=${previous_release}
		if [[ -z "$release" ]]; then
			usage
		fi
		release_is_inherit_from_previous=true
	else
		previous_release=$release
	fi
echo -e "	release=	\e[34m$release\e[m"
	
	# 架构 (x86_86 还是 i686 还是 armv7hl 等等……)
	if [[ -z "$arch" ]]; then
		arch=${previous_arch:-$default_arch}
		arch_is_inherit_from_previous_or_default=true
	else
		previous_arch=$arch
	fi
echo -e "	arch=		\e[35m$arch\e[m"

	rpm_file="$rpm-$version-$release.$arch.rpm"
	rpm_files="$rpm_files $rpm_file"
	url="http://kojipkgs.fedoraproject.org/packages/$package/$version/$release/$arch/$rpm_file"
echo "	url=		$url"
	urls="$urls $url"

	shift
done

if [[ -z "$urls" ]]; then
	usage
fi

if [[ "$download_only" == true ]]
then
	echo "wget -c $urls"
	wget -c $urls
else
	echo "dnf $dnf_command $dnf_options $urls"
	dnf $dnf_command $dnf_options $urls
fi

