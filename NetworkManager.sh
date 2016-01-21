dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh\
    p=NetworkManager,v=$version,r=$release,rpm=NetworkManager{,-{adsl,bluetooth,glib,libnm,wifi,wwan,tui}}\
\
    p=NetworkManager-openvpn\
	rpm=NetworkManager-openvpn-gnome\
\
    p=NetworkManager-vpnc\
	rpm=NetworkManager-vpnc-gnome\
\
    p=network-manager-applet\
	rpm=libnm-gtk\
    rpm=nm-connection-editor\
    $*

