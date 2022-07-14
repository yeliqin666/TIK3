#!/bin/bash

LOCALDIR="$(cd $(dirname $0); pwd)"
binner=$LOCALDIR/bin
source $binner/settings
rm -rf $LOCALDIR/TEMP/*
MBK="$binner/MBK"
platform=$(uname -m)
if [[ $(uname -m) != "aarch64" ]]; then 
    su="sudo "
fi

ebinner="$binner/Linux/$platform"
yecho(){ echo -e "\033[36m[$(date '+%H:%M:%S')]${1}\033[0m" ; }	#显示打印
ywarn(){ echo -e "\033[31m${1}\033[0m" ; }	#显示打印
ysuc(){ echo -e "\033[32m[$(date '+%H:%M:%S')]${1}\033[0m" ; }	#显示打印
getinfo(){ export info=$($ebinner/gettype -i $1) ; }
tikver=$(cat $binner/version)
if [ "$platform" = "aarch64" ];then
	command+=" -b /sdcard"
fi
if [[ -d "/sdcard" ]];then
	Sourcedir=/sdcard/$mydir
else
	Sourcedir=$LOCALDIR
fi

# 配置环境
function checkpath(){
clear
cd $LOCALDIR
if [[ ! -f "$binner/depment" ]]; then
	PIP_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple/
	echo -e "\033[34m $(cat $binner/banners/1) \033[0m"
	if [[ $(whoami) = "root" ]]; then
		userid="root"
	fi
	if [[ $userid = "root" ]]; then
		clear
		ywarn "检测到系统sudo，将强制目录赋满权！"
		sleep $sleeptime
	fi
	if [ "$platform" = "aarch64" ] && [[ ! -d "/sdcard/TIK3" ]]; then
		mkdir /sdcard/TIK3
	fi
	yecho "开始配置环境..."
    sleep $sleeptime
    yecho "更换北外大源..."
    ${su} cp /etc/apt/sources.list /etc/apt/sources.list.bak
    ${su} sed -i 's/archive.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list
    ${su} sed -i 's/security.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list
    yecho "正在更新软件列表..."
    ${su} apt-get update  -y && ${su} apt-get upgrade -y 
    yecho "正在安装必备软件包..."
    packages="python3 sed python3-pip brotli resize2fs curl default-jre bc android-sdk-libsparse-utils aria2 openjdk-11-jre zip p7zip-full"
    for i in $packages; do
        yecho "安装$i..."
        ${su} apt-get install $i -y
    done
    ${su} apt --fix-broken install
    ${su} apt update --fix-missing
	pip3 install --upgrade pip -i $PIP_MIRROR
	pip3 install pycryptodome docopt requests beautifulsoup4 -i $PIP_MIRROR
	pip3 install --ignore-installed pyyaml -i $PIP_MIRROR
	touch $binner/depment
fi
if [[ $userid = "root" ]]; then
	${su} chmod 777 -R *
fi
promenu
}

# 项目菜单
function promenu(){
clear
content=$(curl -s https://v1.jinrishici.com/all.json)
shiju=$(echo $content| cut -d \" -f 4 )
from=$(echo $content| cut -d \" -f 8)
author=$(echo $content| cut -d \" -f 12)
cd $LOCALDIR  
echo -e "\033[31m $(cat $binner/banners/$banner) \033[0m"
echo 

echo -ne "\033[36m “$shiju”"
echo -e "\033[36m---$author《$from》\033[0m"
echo -e " \n"

echo -e " >\033[33m 项目列表 \033[0m\n"
echo -e "\033[31m   [00]  删除项目\033[0m\n"
echo -e "   [0]  新建项目\n"
pro=0
if ls TI_* >/dev/null 2>&1;then
	for pros in $(ls -d TI_*/| sed 's/\///g')
	do 
		if [ -d "./$pros" ];then
			pro=$((pro+1))
			echo -e "   [$pro]  $pros\n"
			eval "pro$pro=$pros" 
		fi
	done
fi
echo -e "  --------------------------------------"
echo -e "\033[33m  [55] 解压  [66] 退出  [77] 设置  [88] TIK实验室\033[0m"
echo -e ""
echo -e " \n"
read -p "  请输入序号：" op_pro
if [ "$op_pro" == "55" ]; then
	echo ""
	echo "维护中..."
	echo ""
	# unpackRom
elif [ "$op_pro" == "88" ]; then
	echo ""
	echo "维护中..."
	echo ""
	# tiklab
elif [ "$op_pro" == "00" ]; then
	read -p "  请输入你要删除的项目序号：" deln
    del=1
	Project
elif [ "$op_pro" == "0" ]; then
	newpro
elif [ "$op_pro" == "66" ]; then
	clear
	exit
elif [ "$op_pro" == "77" ]; then
	settings
elif [[ $op_pro =~ ^-?[1-9][0-9]*$ ]]; then
	chooPro=1
    Project
else
	ywarn "  请输入正确编号!"
	sleep $sleeptime
	promenu
fi
}

# 新建项目
function newpro(){
clear
cd $LOCALDIR
echo " "
read -p "请输入项目名称(非中文)：TI_" projec
if test -z "$projec";then
  ywarn "Input ereor！"
  sleep $sleeptime
  promenu
else  
  project=TI_$projec
  if [[ -d "$project" ]]; then
	project="$project"-`date "+%Y%m%d%H%M%S"`
	ywarn "项目已存在！自动命名为：$project"
	sleep $sleeptime
  fi
  mkdir $project
  mkdir $project/TI_config
  menu
fi
}

# 主菜单
function menu(){
clear
PROJECT_DIR=$LOCALDIR/$project
cd $PROJECT_DIR

if [[ ! -d "TI_config" ]]; then
	ywarn "项目已损坏！"
	menu
fi
echo -e "\n"
echo -e " \033[31m>ROM菜单 \033[0m\n"
echo -e "  项目：$project"
if [[ -f $PROJECT_DIR/system/system/build.prop ]]; then
	SYSTEM_DIR="$PROJECT_DIR/system/system"
elif [[ -f $PROJECT_DIR/system/build.prop ]]; then
	SYSTEM_DIR="$PROJECT_DIR/system"
else
	SYSTEM_DIR=0
	ywarn "  非完整ROM项目"
fi

echo  
echo -e "\033[31m    1> 项目     2> 解包\033[0m\n" 
echo -e "\033[32m    3> 打包     4> 插件\033[0m\n" 
echo -e "\033[32m    5> 封装\033[0m\n" 
echo  
read -p "    请输入编号: " op_menu
case $op_menu in
		1)
        promenu
        ;;
		2)
        unpackChoo
        ;;
		3)
        # packmenu
		echo ""
		echo "维护中..."
		echo ""
        ;;
		4)
        # subbed
		echo ""
		echo "维护中..."
		echo ""
        ;;
		5)
		# packzip
		echo ""
		echo "维护中..."
		echo ""
		;;
        *)
        ywarn "   请输入正确编号!"
		sleep $sleeptime
        menu
esac
}

function Project(){
    if ls TI_* >/dev/null 2>&1;then
		if [ $deln -gt $pro ];then
			ywarn "  请输入正确编号!"
			sleep $sleeptime
			promenu
		else
            if [[ "$del" == "1" ]]; then
                eval "delproject=\$pro$deln"
                read -p "  确认删除？[1/0]" delr
                if [ "$delr" == "1" ];then
                    rm -fr $delproject
                    ysuc "  删除成功！"
                    sleep $sleeptime
                fi
                promenu
            elif [[ "$chooPro" == "1" ]]; then
                eval "project=\$pro$op_pro"
                cd $project
                menu
            fi
		fi
	else
		ywarn  "  输入有误！"
		sleep $sleeptime
		promenu
	fi
}

function unpackChoo(){
clear
cd $PROJECT_DIR
echo -e " \033[31m >分解 \033[0m\n"
filen=0
ywarn "   请将文件放于$PROJECT_DIR根目录下！"
if ls -d *.br >/dev/null 2>&1;then
	for br0 in $(ls *.br)
	do 
	if [ -f "$br0" ] ; then
		file0=$(echo "$br0" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <BR> \n"
		eval "file$filen=$file0" 
		eval "info$filen=br"
	fi
	done
fi

if ls -d *.new.dat >/dev/null 2>&1;then
	for dat0 in $(ls *.new.dat)
	do 
	if [ -f "$dat0" ] ; then
		file0=$(echo "$dat0" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <DAT> \n"
		eval "file$filen=$file0" 
		eval "info$filen=dat"
	fi
	done
fi

if ls -d *.img >/dev/null 2>&1;then
	for img0 in $(ls *.img)
	do 
	if [ -f "$img0" ] ; then
		info=$($ebinner/gettype -i $img0)
		if [ $(file $img0 | cut -d":" -f2 | grep "ext") ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <EXT4>\n"
			eval "file$filen=$file0" 
		elif [ "$info" == "erofs" ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <EROFS>\n"
			eval "file$filen=$file0" 
		elif [ "$info" == "dtbo" ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <DTBO>\n"
			eval "file$filen=$file0" 
		elif [ "$info" == "boot" ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <BOOT>\n"
			eval "file$filen=$file0" 
		elif [ "$info" == "vendor_boot" ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <VENDOR_BOOT>\n"
			eval "file$filen=$file0" 
		elif [ "$info" == "super" ]; then
			file0=$(echo "$img0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <SUPER>\n"
			eval "file$filen=$file0" 
		else
			file0=$(echo "$img0" )
			filen=$((filen+1))
			ywarn "   [$filen]- $file0 <UNKNOWN>\n"
			eval "file$filen=$file0" 
		fi
		eval "info$filen=img"
	fi
	done
fi

if ls -d *.bin >/dev/null 2>&1;then
	for bin0 in $(ls *.bin)
	do 
	if [ -f "$bin0" ] ; then
		info=$($ebinner/gettype -i $bin0)
		if [ "$info" == "payload" ]; then
			file0=$(echo "$bin0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <BIN> \n"
			eval "file$filen=$file0" 
			eval "info$filen=payload"
		fi
	fi
	done
fi

if ls -d *.ozip >/dev/null 2>&1;then
	for ozip0 in $(ls *.ozip)
	do 
	if [ -f "$ozip0" ] ; then
		info=$($ebinner/gettype -i $ozip0)
		if [ "$info" == "ozip" ]; then
			file0=$(echo "$ozip0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <OZIP> \n"
			eval "file$filen=$file0" 
			eval "info$filen=ozip"
		fi
	fi
	done
fi

if ls -d *.ofp >/dev/null 2>&1;then
	for ofp0 in $(ls *.ofp)
	do 
	if [ -f "$ofp0" ] ; then
		info=$($ebinner/gettype -i $ofp0)
		file0=$(echo "$ozip0" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <OFP> \n"
		eval "file$filen=$file0" 
		eval "info$filen=ofp"
	fi
	done
fi

if ls -d *.ops >/dev/null 2>&1;then
	for ops0 in $(ls *.ops)
	do 
	if [ -f "$ops0" ] ; then
		file0=$(echo "$ops0" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <OPS> \n"
		eval "file$filen=$file0" 
		eval "info$filen=ops"
	fi
	done
fi

if ls -d *.win >/dev/null 2>&1;then
	for win0 in $(ls *.win)
	do 
	if [ -f "$win0" ] ; then
		file0=$(echo "$win0" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <WIN> \n"
		eval "file$filen=$file0" 
		eval "info$filen=win"
	fi
	done
fi

if ls -d *.win000 >/dev/null 2>&1;then
	for win0000 in $(ls *.win000)
	do 
	if [ -f "$win0000" ] ; then
		file0=$(echo "$win0000" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <分段WIN> \n"
		eval "file$filen=$file0" 
		eval "info$filen=win000"
	fi
	done
fi
if ls -d *.dat.1 >/dev/null 2>&1;then
	for dat10 in $(ls *.dat.1)
	do 
	if [ -f "$dat10" ] ; then
		file0=$(echo "$dat10" )
		filen=$((filen+1))
		echo -e "   [$filen]- $file0 <分段DAT> \n"
		eval "file$filen=$file0" 
		eval "info$filen=dat.1"
	fi
	done
fi

if ls -d *dtb* >/dev/null 2>&1;then
	for dtb0 in $(ls *dtb*)
	do 
	if [ -f "$dtb0" ] ; then
		info=$($ebinner/gettype -i $dtb0)
		if [ "$info" == "dtb" ]; then
			file0=$(echo "$bin0" )
			filen=$((filen+1))
			echo -e "   [$filen]- $file0 <DTB> \n"
			eval "file$filen=$file0" 
			eval "info$filen=dtb"
		fi
	fi
	done
fi

echo -e ""
echo -e "\033[33m  [88] 菜单\033[0m"
echo -e ""
read -p "请输入对应序号：" filed

if [[ "$filed" = "88" ]]; then
	menu
elif [[ $filed =~ ^-?[1-9][0-9]*$ ]]; then
	if [ $filed -gt $filen ];then
		ywarn "输入有误！"
		sleep $sleeptime && menu
	else
		eval "i=\$file$filed"
		eval "type1=\$info$filed"
		unpack $i
	fi
else
	ywarn "输入有误！！" && menu
	sleep $sleeptime
fi
}


function unpack(){
if [[ ! -d "$PROJECT_DIR/TI_config" ]]; then
    mkdir $PROJECT_DIR/TI_config
fi
filet=${i}
echo $filet $type1
sf=$(echo "$i" | rev |cut -d'.' -f1 --complement | rev | sed 's/.new.dat//g' | sed 's/.new//g')
if [ "$type1" = "br" ];then
	rm -f $sf.new.dat $sf.img
	brotli -d $PROJECT_DIR/$filet > /dev/null
	python3 $binner/sdat2img.py $sf.transfer.list $sf.new.dat $PROJECT_DIR/$sf.img > /dev/null
	getinfo $sf.img
elif [ "$type1" = "dat" ];then
	rm -f $sf.img
	python3 $binner/sdat2img.py $sf.transfer.list $sf.new.dat $PROJECT_DIR/$sf.img > /dev/null
	getinfo $sf.img
	imgextra

elif [ "$type1" = "img" ];then
	imgextra
elif [ "$type1" = "ofp" ];then
	read -p " ROM机型处理器为？?[1]高通 [2]MTK	" ofpm
	if [ "$ofpm" = "1" ]; then
		python3 $binner/oppo_decrypt/ofp_qc_decrypt.py $PROJECT_DIR/$filet $PROJECT_DIR/$sf
	elif [ "$ofpm" = "2" ];then
		python3 $binner/oppo_decrypt/ofp_mtk_decrypt.py $PROJECT_DIR/$filet $PROJECT_DIR/$sf
	fi
elif [ "$type1" = "ozip" ];then
	python3 $binner/oppo_decrypt/ozipdecrypt.py $PROJECT_DIR/$filet
elif [ "$type1" = "ops" ];then
	python3 $binner/oppo_decrypt/ofp_mtk_decrypt.py $PROJECT_DIR/$filet $PROJECT_DIR/$sf
elif [ "$type1" = "bin" ];then
	yecho "$file所含分区列表："
	$ebinner/payload-dumper-go -l $PROJECT_DIR/$filet
	read -p "请输入需要解压的分区名(空格隔开)/all	" extp </dev/tty
	if [ "$extp" = "all" ];then 
		$ebinner/payload-dumper-go $PROJECT_DIR/$filet -o $PROJECT_DIR/payload
	else
		if [[ ! -d "payload" ]]; then
			mkdir $PROJECT_DIR/payload
		fi
		for d in $extp
		do
			$ebinner/payload-dumper-go -p $d $PROJECT_DIR/$filet -o $PROJECT_DIR/payload${d} > /dev/null 2>&1
			mv $PROJECT_DIR/payload${d} $PROJECT_DIR/payload&&rm -fr payload${d}
		done
	fi
elif [ "$type1" = "win000" ];then
	${su} $ebinner/simg2img *${sf}.win* ./${sf}.win
	${su} python3 $binner/imgextractor.py ./${sf}.win ./
elif [ "$type1" = "win" ];then
	${su} python3 $binner/imgextractor.py ./${sf}.win ./
elif [ "$type1" = "dat.1" ];then
	${su} cat ./${sf}.new.dat.{1..999} >> ./${sf}.new.dat
	python3 $binner/sdat2img.py $sf.transfer.list $sf.new.dat ./$sf.img
	imgextra
else
	ywarn "未知格式！"
fi
if [[ $userid = "root" ]]; then
	${su} chmod 777 -R $sf > /dev/null 2>&1
fi
}

function imgextra(){
if [[ $(file ${sf}.img | cut -d":" -f2 | grep "ext") ]]; then
	${su} python3 $binner/imgextractor.py $LOCALDIR/${sf}.img $PROJECT_DIR
	if [ ! $? = "0" ];then
		ywarn "解压失败"
	fi
	rm -rf $LOCALDIR/${sf}.img
elif [ "$info" = "erofs" ];then
	$ebinner/erofsUnpackRust $LOCALDIR/${sf}.img $PROJECT_DIR
	mv ./config/* ./TI_config&&rm -fr ./config
	if [ ! $? = "0" ];then
		ywarn "解压失败"
	fi
	rm -rf $LOCALDIR/${sf}.img
elif [ "$info" = "super" ];then
	super_size=$(du -sb "./${sf}.img" | awk '{print $1}' | bc -q)
	yecho "super分区大小: $super_size bytes  解压${sf}.img中..."
	mkdir super
	TARGETDIR=./super
	$ebinner/lpunpack $PROJECT_DIR/${sf}.img $TARGETDIR
	if [ ! $? = "0" ];then
		ywarn "解压失败"
	else
		ysuc "super输出至 $TARGETDIR"
        if [[ $userid = "root" ]]; then
            chmod 777 -R $TARGETDIR
        fi
	fi
elif [ "$info" = "boot" ] || [ "$sf" == "boot" ] || [ "$sf" == "vendor_boot" ] || [ "$sf" == "recovery" ] ; then
	if [[ -d "$sf" ]]; then
		rm -fr $sf
	fi
	${su} mkdir $sf && cd $sf
	${su} bash $MBK/unpackimg.sh $PROJECT_DIR/$i >> $PROJECT_DIR/TI_config/$sf.info
	${su} cp -f $PROJECT_DIR/$i $PROJECT_DIR/TI_config
    if [[ $userid = "root" ]]; then
        ${su} chmod 777 -R ./$sf
    fi
	cd $PROJECT_DIR
else
	ywarn "未知格式！请附带文件提交issue!"
	sleep $sleeptime
fi
sleep $sleeptime
}

checkpath
