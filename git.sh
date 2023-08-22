dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=git,v=$version,r=$release    rpm=gitweb,a=noarch    rpm=perl-Git    "$@"
