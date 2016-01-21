dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=grub2,v=$version,r=$release,rpm=grub2{,-{efi{,-modules},tools}}    $*

