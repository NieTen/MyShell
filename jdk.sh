#!/bin/sh
# 从源码安装jdk1.8
# 解压后包名
App=jdk1.8.0_281
# 安装包名称
AppTar=jdk-8u281-linux-x64.tar.gz
# 安装目录
AppInstallBase=/opt
# 安装目录下包名
AppName=jdk
# 脚本目录
ScriptDir=$AppInstallBase/script
# 安装包保存目录
AppTarDir=$AppInstallBase/soft
# build目录
AppBuildBase=$AppInstallBase/soft/build

# 判断是否已经下载了tar包
fdownload(){
	echo "第一步"
	echo "--------------开始下载$AppTar --------------"
	# 先判断是否已下载
	if [[ ! -f $AppTarDir/$AppTar ]]; then
		echo "$AppTar 不存在"
		echo "Start download $AppTar"
		# 判断soft目录是否存在
		if [[ ! -d $AppTarDir ]]; then
			echo "$AppTarDir 不存在"
			mkdir -p $AppTarDir
			echo "$AppTarDir 目录新建完成"
		fi
		wget -O $AppTarDir/$AppTar --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http://www.oracle.com/; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn-pub/java/jdk/8u281-b09/89d678f2be164786b292527658ca1605/jdk-8u281-linux-x64.tar.gz"
	fi
	echo "--------------解压处理--------------"
    # 解压
	tar -zxf $AppTarDir/$AppTar
	# 重命名并拷贝到build目录
	if [[ ! -d $AppBuildBase ]]; then
		# 如果文件夹不存在，新建目录
		echo "mkdir build"
		mkdir -p $AppBuildBase/$AppName 		  
	fi 
	rm -rf $AppBuildBase/$AppName
	mv $ScriptDir/$App $AppBuildBase/$AppName

	echo "--------------完成下载$AppTar --------------"
}

# 增加配置
fconfig(){
	echo "第二步"
	echo "--------------开始配置/etc/profile--------------"
	# 判断/etc/profile是否已有配置
	grep "export JAVA_HOME=$AppBuildBase/$AppName" /etc/profile 
	# $? 最后运行的命令的结束代码（返回值）即执行上一个指令的返回值  0表示没有错误
	if [[ ! $? -eq 0 ]]; then
		echo "新增配置信息"
		echo "export JAVA_HOME=$AppBuildBase/$AppName" >> /etc/profile
    	echo "export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> /etc/profile
    	echo "export PATH=\$PATH:$JAVA_HOME/bin" >> /etc/profile
    	source /etc/profile
	else
		echo "/etc/profile中 $App 配置已存在"
	fi

	echo "--------------开始配置~/.bashrc, 增加全局变量--------------"
    # 增加全局变量
    # 判断/etc/profile是否已有配置
	grep "export JAVA_HOME=$AppBuildBase/$AppName" ~/.bashrc 
	# $? 最后运行的命令的结束代码（返回值）即执行上一个指令的返回值  0表示没有错误
		if [[ ! $? -eq 0 ]]; then
		echo "新增配置信息"
		echo "export JAVA_HOME=$AppBuildBase/$AppName" >> ~/.bashrc
    	echo "export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> ~/.bashrc
    	echo "export PATH=\$PATH:$JAVA_HOME/bin" >> ~/.bashrc
    	source ~/.bashrc
	else
		echo "~/.bashrc中 $App 配置已存在"
	fi
    echo "--------------完成配置~/.bashrc--------------"
}

# 版本
fversion(){
	echo "第三步"
	echo "--------------安装完成--------------"
	java -version
}

# 安装
finstall(){
	fdownload
	fconfig
	fversion
}

# 执行
finstall

