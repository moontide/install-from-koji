dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=compiz,v=$version,r=$release \
	p=compiz-plugins-{main,extra,unsupported} \
	p=libcompizconfig \
	p=compizconfig-python \
	p=emerald \
\
	p=emerald-themes,a=noarch \
	p=compiz-bcop \
	p=ccsm \
	"$@"
