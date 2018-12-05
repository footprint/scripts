#!/bin/bash
# backup svn changes

if [ $# -lt 2 ]; then
	echo "usage: svnBackup.sh source_path destination_path"
	exit 1
fi

from=$1

if [ ! -d "$2" ]; then
	mkdir -p $2
fi

to=$(cd $2; pwd) #absolute path

# init status
flag=
skip=true

pushd $from
	ret=`svn status`
	i=0
	for e in $ret; do
		if [ "$skip" = true ] ; then
			if [ -n "$flag" ]; then
				echo "Skip:$flag"
			fi

			flag=$e
			case $e in
				'M' | 'A' | '?' | 'D' | '!')
					skip=false
					;;
				*)
					skip=true
					;;
			esac
		else
			case $flag in
				'M' | 'A' | '?' )
					file=$from/$e
					if [ -d $file ] ; then
						if [ ! -d "$to/$e" ] ; then
							mkdir -p $to/$e
						fi
					elif [ -f $file ] ; then
						dir=`dirname $to/$e`
						if [ ! -d "$dir" ] ; then
							mkdir -p $dir
						fi
						cp -rf $file $dir
					fi
					;;
				'D' | '!' )
					rm -rf $to/$e
					;;
				*)
					echo "error:$flag"
					;;
			esac
			# parse next
			flag=
			skip=true
		fi
	done
popd