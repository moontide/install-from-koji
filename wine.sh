dir=$(dirname $0)
package=wine
version="$1"
release="$2"
arch=
if [[ -z "$version" || -z "$release" ]]; then
	echo "Usage: $0  <version>  <release>"
	echo "eg: $0  1.7.35  2.fc21"
	exit -1
fi

$dir/install-packages-from-koji.sh    p=$package,rpm=$package,v=$version,r=$release    rpm=$package-{alsa,capi,cms,core,ldap,openal,opencl,pulseaudio,twain}    a=i686,rpm=$package-{capi,cms,core,ldap,openal,opencl,pulseaudio,twain}    a=noarch,rpm=$package-{common,arial-fonts,courier-fonts,desktop,filesystem,fonts,fixedsys-fonts,marlett-fonts,ms-sans-serif-fonts,small-fonts,symbol-fonts,system-fonts,systemd,tahoma-fonts,tahoma-fonts-system,wingdings-fonts}

# 去掉不需要的 wine 程序菜单项
/usr/bin/rm -v -f /usr/share/applications/wine-{notepad,winefile,winemine,wordpad}.desktop

# 删除右键菜单条目
# https://wiki.archlinux.org/index.php/wine#Removing_menu_entries
user_dir=/home/liuyan
#rm -f $user_dir/.local/share/applications/wine/Programs/*
/usr/bin/rm -v -f $user_dir/.local/share/applications/wine-extension*
/usr/bin/rm -v -f $user_dir/.local/share/icons/hicolor/*/*/application-x-wine-extension*
/usr/bin/rm -v -f $user_dir/.local/share/mime/application/x-wine-extension*
/usr/bin/rm -v -f $user_dir/.local/share/mime/packages/x-wine*

