dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=gcc,v=$version,r=$release,rpm={cpp,gcc{,-c++},lib{gcc,gomp,stdc++{,-devel}}}    $*

