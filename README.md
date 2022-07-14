
####  **介绍** 


1.  【 **TI Kitchen 3.0** 】 永久开源的ROM工具箱，支持安卓全版本

2.  已支持大多常见镜像的分解/打包，较完善支持erofs/V-AB分区等

3.  新增设置功能-调整交互习惯、打包行为

4.  已支持目前安卓13新机型，包括但不限于Xiaomi OPPO Pixel等

5.  迁移至Magisk Boot Kitchen分解合成[boot|exaid|recovery/etc].img

6.  支持分解全版本super.img(V-AB)支持各种类型打包（半自动识别，高效稳定）


####  **支持** 

【 **识别分解 打包支持** 】

1. 【 *.zip, *.br, *.dat, ext4/2 *.img, bootimg 等】传统镜像识别-分解-打包
2. 【 Super.img <A-onloy/AB/V-AB>, bootimg<header3>, erofs *.img,  等】较新镜像识别-分解-打包
3. 【 dtbo，dtb , TWRP, ops, ofp, ozip, payload.bin, *.win000-004, *.dat.1~20等】特殊文件的解包/打包
4. 较完善适配最新 **安卓13** **Erofs** **动态分区** **V-AB分区**


【 **软件架构  同时支持** 】

1. 手机 Termux Proot Ubuntu 20.04及以上版本 Arm64[aarch64] 或者 <Linux Deploy> Chroot Ubuntu 20.04及以上版本 Arm64[aarch64] 【推荐chroot，效率更高】

2. 电脑 Win10 Wsl/Wsl2 Ubuntu 20.04及以上版本 x86_64[x64]  推荐wsl1! 

3. 虚拟机或实体机 Ubuntu 20.04及以上版本 x86_64[x64] 

Note: WSL 可能存在权限出错的问题 请自行判断测试


####  **安装教程** 

    git clone https://www.github.com/NightstarSakura/TIK3
    cd TIK3 && bash TIK3.sh
	
####  **【手机端--需配置proot环境】** 

1----手机运行Termux 获取存储权限 

        termux-setup-storage

<!-- 2----手机一键配置proot并下载工具

	bash <(curl -s https://gitee.com/xiaobai2333/proot-ubuntu/raw/master/onekey_install.sh) -->


####  **使用说明** 

1.  Termux内所有操作尽量【 **不要使用系统root功能** 】， PC端需要root权限(sudo) 且最好不要在【root用户登录状态下】运行此工具，以免打包后刷入手机出现权限问题 ！

2.   **关于手机解压zip** 
    - 请将zip文件放置在【 **内置存储 /sdcard/TIK2** 】，工具会自动查找（设置中可以修改)

3.  手机端termux proot ubuntu下工具目录： 【**/data/data/com.termux/files/home/ubuntu/root/TIK2** 】

4.  **请勿删除【工程目录/TI_config文件夹】，打包时所需的文件信息都在此处，默认工具会自动帮您修改大小，适配动态分区！！！

5.  由于手机性能、proot效率、工作模式( **如打包img前自动比对fs_config，不会立刻打包** )等原因，保持耐心，等待片刻即可；

6.  删除文件尽量在【Termux或proot ubuntu】执行 【rm -rf 文件、文件夹】 【 **不要使用系统root功能 ** 】

7.   **不要放在含有中文名文件夹下运行，不要选择带有空格的文件进行解包，工程文件夹不得有空格或其他特殊符号 ，文件名不要过长！！！** 

8.   **动态分区不允许单刷.img，具体请参见安卓文档** 

10.  手机上使用工具时如果使用 **系统ROOT** 对工程目录下进行了操作(比如： **添加文件，修改文件**等。。。 )，请记得给操作过的文件或文件夹  **777**  满权！！！

####  **参与贡献** 

Credit:
1.  mke2fs & e2fsdroid [aarch64 from @小新大大](https://github.com/xiaoxindada/SGSI-build-tool)
2.  mke2fs & e2fsdroid [x86_64 from Erfan Abdi](https://github.com/erfanoabdi/ErfanGSIs)
3.  mke2fs & e2fsdroid [cygwin64 from @affggh](https://github.com/affggh/fspatch)
4.  Magisk-bootimage-Kitchen(modified): [affggh @ Github](https://github.com/affggh/magiskbootkitchen)
5.  termux-linux [xiliuya @ Github](https://github.com/xiliuya/termux-linux)
6.  sdat2img.py [xpirt   @ Github](https://github.com/xpirt/sdat2img) & [img2sdat.py](https://github.com/xpirt/img2sdat)
7.  ext4.py [Cubi  @ Github](https://github.com/cubinator/ext4)
8.  payload-dumper-go(modified) [ssut @ Github](https://github.com/ssut/payload-dumper-go)
9.  payload-dumper-go [cygwin64 from @affggh](https://github.com/affggh/fspatch)
10.  dtb_tools [from 小新大大 and 黑风](https://github.com/xiaoxindada/SGSI-build-tool)(http://www.coolapk.com/u/3473348)
11.  FlashImageTools [from @hais](http://z.hais.pw/)
12. oppo_decrypt [from bkerler @github](https://github.com/bkerler/oppo_decrypt)
13. get_miui.py [@NightstarSakura](https://github.com/NightstarSakura) [@酷安](https://www.coolapk.com/u/2670027)
14. fspatch.py [from @affggh](https://github.com/affggh/fspatch)
15. imgextractor.py [from 小新大大](https://github.com/xiaoxindada)
16. lpmake & lpunpack [aarch64 from @hais](http://z.hais.pw/)
17. lpmake & lpunpack [x86_64 from @yeliqin666](https://github.com/yeliqin666)
18. mkfs.erofs [aarch64 & x86_64 from @忘川](https://github.com/bugme2/)
19. simg2img [from @多幸运](http://www.coolapk.com/u/8160711)
20. erofsUnpackKt [from @忘川](https://github.com/bugme2/erofs-oneplus)
21. erofsUnpackRust [cygwin64 from @affggh](https://github.com/affggh/fspatch)
22. pack_ext4_with-rw.bash(modified) [from @多幸运](http://www.coolapk.com/u/8160711)
23. pack_super.bash(modified) [from @秋水](Email：qiurigao@163.com)
24. pack_payload_tool [x64_64 from @秋水](Email：qiurigao@163.com)
25. resize2fs [cygwin64 from @affggh](https://github.com/affggh/fspatch)
26. D.N.A. & CYToolkit for reference on UI [@sharpeter ](https://gitee.com/sharpeter/DNA) [@NightstarSakura](https://github.com/NightstarSakura)
27. gettype [aarch64&cygwin64&x86_64 from affggh @ Github](https://github.com/affggh/gettype)
28. debuging & suggestions &PR [the active users!]


####  **参与维护途径**

  请发起PR，我们将会第一时间查看并考虑是否通过，感谢所有为本项目提供支持的开发者/爱好者！ 


####  **交流反馈** 

  QQ群：[939212867] ( https://jq.qq.com/?_wv=1027&k=HOJVFqzP )

  酷安话题#TIK工具箱#


####  **免责声明** 

1.  本工具在Termux proot环境中运行，不需要root权限 【 **请在Termux中慎用系统root功能** 】 ！！！

2.  此工具不含任何【破坏系统、获取数据】等其他不法代码 ！！！

3.  **如果由于用户利用root权限对工具中的工程目录进行操作导致的数据丢失、损毁，本人不承担任何责任 ！！！** 


