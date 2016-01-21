dir=$(dirname $0)
package=samba
version="$1"
release="$2"
arch=

if [[ -z "$version" || -z "$release" ]]; then
        echo "Usage: $0  <version>  <release>"
        echo "eg: $0  4.3.3  0.fc23"
        exit -1
fi

shift 2
$dir/install-packages-from-koji.sh    p=$package,v=$version,r=$release,rpm={$package{,-{client,client-libs,common-libs,common-tools,libs,winbind{,-clients,-modules}}},libsmbclient,libwbclient}    rpm=$package-common,a=noarch    $*

