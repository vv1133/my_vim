#!/bin/sh

#=========================================================================
# Description: 用于cscope和ctags生成数据库文件tags和cscope.out
# Version: 1.4
#=========================================================================

IGNORE_DIR="" 
INCLUDE_DIR=""  
#INCLUDE_FILE_TYPE="\.c$|\.h$|\.S$|\.cpp$|\.java$|\.lds$|\.ld*|\.chh$|\.cc$"  
INCLUDE_FILE_TYPE="\.c$|\.h$|\.S$|\.s$|\.cpp$|\.java$|\.lds$|\.ld.*|\.chh$|\.cc$|\.hpp$"

cs_init() 
{
	if [ ! -e ./cscope.ignore ]; then
		touch ./cscope.ignore
	fi

	if [ ! -e ./cscope.include ]; then
		touch ./cscope.include
	fi

	IGNORE_DIR=`awk ' {
	if(null != $0)
	{
		if(i == 0)
		{
			i++;
			printf("-path %s ",$0);
		} 
		else 
		{
			printf("-o -path %s ",$0);
		}
	} }' ./cscope.ignore`

	INCLUDE_DIR=`awk '{printf(" %s ",$0);}' ./cscope.include`

	#echo "INCLUDE_DIR=" $INCLUDE_DIR 
	#echo "IGNORE_DIR=" $IGNORE_DIR 

	if [ ! -e ./cscope.files ]; then

		if [ -z "$IGNORE_DIR" ]; then #字符串为null，即长度为0
			#find . -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" >    cscope.files
			#modify the cscope code to allow index link file
			#find -L . | grep -E '\.c$|\.h$|\.S$|\.cpp$|\.java$|\.lds$|\.ld*|\.chh$|\.cc$' > cscope.files
			find -L ${INCLUDE_DIR} | grep -E ${INCLUDE_FILE_TYPE} > cscope.files
		else
			#find -L . \( -path ./kk -o -path ./mm -o -path ./nn/yy \) -prune -o -print
			find -L ${INCLUDE_DIR} \( ${IGNORE_DIR} \) -prune -o -print | grep -E ${INCLUDE_FILE_TYPE} > cscope.files
		fi
	fi
}

cs_reinit()
{
	rm cscope.files -f
	cs_init
}

cs_data() 
{
	cscope -Rbqk -i ./cscope.files #cscope.files为查找的文件列表
	#ctags -R *
	ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+q -L ./cscope.files #cscope.files为查找的文件列表
	echo "create database ok!"
}

cs_clean()
{
	rm cscope.* -f
	rm tags -f
	echo "clean ok!"
}

cs_all()
{
	cs_clean
	cs_init
	cs_data
}

help()
{
	echo ""
	echo " mycscope.sh <init|reinit|data|all|clean>"
	echo ""
	echo "    eg: mycscope.sh init"
	echo "        mycscope.sh reinit"
	echo "        mycscope.sh data"
	echo "        mycscope.sh all"
	echo "        mycscope.sh clean"
	echo " "
}

main()
{
	if [ $# -ne 1 ]; then
		help
		exit 1
	fi

	case "$1" in
		init)
			cs_init
			;;
		reinit)
			cs_reinit
			;;
		data)
			cs_data
			;;
		all)
			cs_all
			;;
		clean)
			cs_clean
			;;
		*)
			echo "EORROR : $1"
			help
			exit 1
			;;
	esac
}

main $@

