# install-from-koji #

如果你觉得 fedora updates-testing 仓库里的软件还不够新（或者本地镜像的更新速度比较慢），那么你可以用这些脚本来直接从 fedora 的 koji 平台安装最新编译完成的软件包。

# 用法 | Usage #

	install-packages-from-koji.sh [p=_包名称_,v=_版本号_,r=编译号]...

例如：
	install-packages-from-koji.sh p=kernel,rpm=kernel-headers,v=3.14.2,r=200.fc20  rpm=kernel-devel  rpm=kernel
	# 上面的命令将会安装 3.14.2 版本的 kernel、kernel-headers、kernel-devel 包

# 一些封装好的脚本 | Convenient scripts #

* kernel.sh - 更新 kernel 包的便利脚本
* wine.sh - 更新很多 wine-\* 包的便利脚本
* git.sh - 更新 git 包的便利脚本
