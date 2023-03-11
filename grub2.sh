dir=$(dirname $0)
version="$1"
release="$2"

shift 2
$dir/install-packages-from-koji.sh    p=grub2,v=$version,r=$release,rpm=grub2-{pc,efi-{x64,ia32}{,-cdboot},tools{,-efi,-extra,-minimal},emu,emu-modules}    rpm=grub2-{common,{pc,efi-{x64,ia32}}-modules},a=noarch    $*
