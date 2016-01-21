# install-from-koji #

如果你觉得 fedora updates-testing 仓库里的软件还不够新（或者本地镜像的更新速度比较慢），那么你可以用这些脚本来直接从 fedora 的 koji 平台安装最新编译完成的软件包。

此脚本的功能基本上就是：**自动检测当前 CPU 架构，并根据传入的参数 (版本号、发行号) 自动生成 URL 链接，然后，或下载，或更新，或安装**。无其他特效。

# 用法 | Usage #

	./install-packages-from-koji.sh  [/download | /install]  [p=_包名称_,v=_版本号_,r=发行号]...

[基本用法截图](screenshots-01-basic-usage.png)

* 如果加上了 `/download`，则只下载，不安装。
* 如果加上了 `/install`，则执行 `dnf install`，而不是 `dnf update` 命令。

	[只下载不安装的用法截图](screenshots-02-download-only.png)

例如：

	#
	# 下面的任何一条命令将会安装 4.3.3-301.fc23 版本的 kernel、kernel-headers、kernel-devel 包
	#

	# 最原始的用法
	install-packages-from-koji.sh p=kernel,rpm=kernel,v=4.3.3,r=301.fc23  rpm=kernel-devel  rpm=kernel-headers

	# 如果 rpm 的名称与 package 的名称相同，则 rpm= 参数可以省略
	install-packages-from-koji.sh p=kernel,v=4.3.3,r=301.fc23  rpm=kernel-devel  rpm=kernel-headers

	# 可以利用 bash 的【花括号扩展】(Brace Expansion) 功能，将命令行再缩短
	install-packages-from-koji.sh p=kernel,rpm=kernel{,-devel,headers},v=4.3.3,r=301.fc23

# 一些封装好的脚本 | Convenient scripts #

**注意：在便利脚本中， /download 或 /install 参数需要放在参数后面，因为一般情况下，便利脚本的第一个参数为 版本号、第二个参数为发行号 **

* kernel.sh - 更新 kernel 包的便利脚本

	这个脚本，会更新/安装下列包

	- kernel
	- kernel-core
	- kernel-modules
	- kernel-tools
	- kernel-tools-libs

	并且，会自动探测下列包，并更新/安装探测到的包

	- kernel-modules-extra
	- kernel-devel
	- kernel-headers

	[kernel.sh](screenshots-03-run-kernel.sh.png)


* wine.sh - 更新很多 wine-\* 包的便利脚本

	[wine.sh](screenshots-04-run-wine.sh.png)


* firefox.sh - 更新 firefox 包的便利脚本
* thunderbird.sh - 更新 thunderbird 包的便利脚本
* git.sh - 更新 git、gitweb、perl-Git 包的便利脚本
* mate.sh - 更新很多 mate-* 包，此外还包括

	- caja (MATE 文件管理器)
	- eom (MATE 图片查看器)
	- pluma (MATE 文本编辑器)
	- atril (MATE 文档查看器)
	- engrampa (MATE 压缩工具)
	- marco (MATE 窗口管理器) 的便利脚本


* nmap.sh - 更新 nmap、nmap-ncat、nmap-frontend 包的便利脚本
* vim.sh - 更新 vim-X11、vim-common、vim-enhanced、vim-filesystem、vim-minimal 包的便利脚本
* samba.sh - 更新很多 samba-* 包，包括

	- samba
	- samba-libs
	- samba-common
	- samba-common-libs
	- samba-common-tools
	- samba-client
	- samba-client-libs
	- winbind
	- winbind-ciients
	- winbind-modules
	- libsmbclient
	- libwbclient


* grub2-efi.sh - 更新 grub2、grub2-efi、grub2-efi-modules、grub2-tools 包的便利脚本
* NetworkManager.sh - 更新很多 NetworkManager-* 包，包括

	- NetworkManager
	- NetworkManager-adsl
	- NetworkManager-bluetooth
	- NetworkManager-glib
	- NetworkManager-libnm
	- NetworkManager-wifi
	- NetworkManager-wwan
	- NetworkManager-tui
	- NetworkManager-openvpn
	- NetworkManager-openvpn-gnome
	- NetworkManager-vpnc
	- NetworkManager-vpnc-gnome
	- network-manager-applet
	- libnm-gtk
	- nm-connection-editor
