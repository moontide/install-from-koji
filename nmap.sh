dir=$(dirname $0)
package=nmap
version="$1"
release="$2"
arch=

if [[ -z "$version" || -z "$release" ]]; then
        echo "Usage: $0  <version>  <release>"
        echo "eg: $0  7.01  1.fc23"
        exit -1
fi

shift 2
$dir/install-packages-from-koji.sh    p=$package,v=$version,r=$release,rpm=$package{,-ncat}    rpm=$package-frontend,a=noarch    $*

