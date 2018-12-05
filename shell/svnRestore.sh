#!/bin/bash
# restore from backup 

path=$(cd `dirname $0`; pwd)

if [ $# -lt 2 ]; then
	echo "usage: svnRestore.sh source_path destination_path"
	exit 1
fi

from=$(cd $1; pwd) #absolute path
to=$(cd $2; pwd) #absolute path


# 递归copy文件方法
foreach() {
	for file in $1/*
	do
		if [ "$file" != "." ] && [ "$file" != ".." ] && [ "$file" != ".DS_Store" ] && [ "$file" != ".svn" ]; then
			# mkdir first
			des=${file/$from/$to}
			dir=`dirname $des`
			if [ ! -d "$dir" ]; then
				mkdir -p $dir
			fi

			if [ -d $file ]
				then
				foreach $file
			elif [ -f $file ]
				then
				cp $file $des
			fi
		fi
	done
}

foreach $from > /dev/null
