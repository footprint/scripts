#!/bin/bash

path=$(cd `dirname $0`; pwd) #脚本所在目录
c_path=$path/..

if [ ! -d "$ANDROID_SDK_ROOT" ]; then
	echo "ANDROID_SDK_ROOT path is not found!"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "usage: apkInstall pathOfApk (clear)"
	exit 2
fi


cmd="$ANDROID_SDK_ROOT/platform-tools/adb"

if [[ -n "$1" && "$1" != "clear" ]]; then
	apk="$1"
fi

echo "install $apk..."

if [ `echo $* | grep -i clear` ]; then
	$cmd install $apk
else
	$cmd install -r $apk
fi

echo "install done."