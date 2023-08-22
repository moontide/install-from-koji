dir=$(dirname $0)
version="$1"
release="$2"
arch=
if [[ -z "$version" || -z "$release" ]]; then
	echo "Usage: $0  <version>  <release>"
	echo "eg: $0  1.12.0  1.fc23"
	exit -1
fi

shift 2
$dir/install-packages-from-koji.sh\
    p=mate-desktop,rpm=mate-desktop{,-libs},v=$version,r=$release\
    p=mate-session-manager\
    p=mate-terminal\
    p=mate-power-manager\
    p=mate-system-monitor\
    p=mate-screensaver\
    p=mate-settings-daemon\
    p=mate-media\
    p=mate-notification-daemon\
    p=mate-control-center,rpm=mate-control-center{,-filesystem}\
    p=mate-applets\
    p=mate-sensors-applet\
    p=mate-netspeed\
    p=atril,rpm=atril{,-caja,-libs,-thumbnailer}\
    p=engrampa\
    p=eom\
    p=pluma\
    p=marco,rpm=marco{,-libs}\
    p=mate-polkit\
    p=mate-panel,rpm=mate-panel{,-libs}\
    p=mate-menus,rpm=mate-menus{,-libs}\
    p=caja,rpm=caja{,-extensions,-schemas}\
    p=caja-extensions,rpm=caja-{open-terminal,sendto,share,image-converter,beesu,wallpaper,xattr-tags}\
    p=python-caja\
    p=mate-utils,rpm=mate-{disk-usage-analyzer,screenshot,search-tool,system-log}\
    p=libmatekbd\
    p=libmatemixer\
    p=libmateweather\
\
    p=mate-common,a=noarch\
    p=mate-utils,rpm=mate-utils-common,a=noarch\
    p=caja-extensions,rpm=caja-extensions-common\
    p=mozo\
    p=pluma,rpm=pluma-data\
    p=mate-icon-theme\
    p=mate-icon-theme-faenza\
    p=mate-backgrounds\
    p=libmateweather,rpm=libmateweather-data\
	"$@"
