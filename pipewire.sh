dir=$(dirname $0)
package=pipewire
version="$1"
release="$2"
arch=

if [[ -z "$version" || -z "$release" ]]; then
        echo "Usage: $0  <version>  <release>"
        echo "eg: $0  0.3.29  1.fc34"
        exit -1
fi

shift 2
$dir/install-packages-from-koji.sh    p=$package,v=$version,r=$release,rpm=$package{,-{alsa,gstreamer,jack-audio-connection-kit{,-libs},libs,plugin-jack,pulseaudio,utils}}    a=i686,rpm=$package-{libs,alsa}    "$@"
