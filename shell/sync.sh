#!/bin/bash
# 同步2个目录的文件，不删除目标目录的文件夹

if [ $# -lt 2 ]; then
	echo "usage: sync source_path destination_path"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "source path($1) is not exist!"
	exit 2
fi

if [ ! -d "$2" ]; then
	echo "destination path($2) is not exist!"
	exit 3
fi


from=$(cd $1; pwd) #absolute path
to=$(cd $2; pwd) #absolute path

# 删除目标目录的文件
if [ $# == 3 ]; then
	echo "delete all files with $3 extention in $to ? (y/n)"
	read answer
	if [[ "$answer" != "y" ]]; then
		echo "abort by user"
		exit 0
	fi

	# 删除目标目录的指定后缀文件
	ext=$3
	if [ -d "$to" ]; then
		find $to -type f -name "*.$ext" -exec rm -f {} \;
	fi
else
	echo "delete all files in $to ? (y/n)"
	read answer
	if [[ "$answer" != "y" ]]; then
		echo "abort by user"
		exit 0
	fi

	# 删除目标目录的所有文件
	if [ -d "$to" ]; then
		find $to ! -iwholename '*.svn*' -type f -exec rm -f {} \; #排除svn
	fi
fi

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
				
				if [ ! $ext ]; then
		            cp $file $des
		        elif [ "${file##*.}" = "$ext" ]
		        	then
		         	cp $file $des
		        fi
			fi
		fi
	done
}

foreach $from > /dev/null
