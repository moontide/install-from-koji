dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=vim,v=$version,r=$release,rpm=vim-{X11,common,enhanced,filesystem,minimal}    $*


# 用 vim 代替 vi
pushd /usr/bin
mv vi vi.vi
ln -s vim vi
popd

