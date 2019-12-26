#!/bin/sh
path=.
cdn=cdn.txt
download_url="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"

download_cdn()
{
	echo "Download begin..."
	rm -f $path/$cdn
	wget $download_url -O $path/$cdn
	if [ "$?" = "0" ];then
		echo "Download complate"
		return 0
	else
		rm -f $path/$cdn
		echo "Download fail"
		return 1
	fi
}

generate_chnroute()
{
	if [ -e $path/$cdn ];then
		chnroute_v4=chnroute_v4.txt
		# chnroute_v6=chnroute_v6.txt
		chnroute_temp=chnroute.tmp
	
		echo "Generate new chnroute file..."
		rm -f $path/$chnroute_temp
		cat $path/$cdn | while read line
		do
			echo $line | awk -F '|' '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' >> $path/$chnroute_temp.v4
			# echo $line >> $path/$chnroute_temp.v6
		done
		rm -f $path/$cdn
		rm -f $path/$chnroute_v4
		mv $path/$chnroute_temp.v4 $path/$chnroute_v4
		# rm -f $path/$chnroute_v6
		# mv $path/$chnroute_temp.v6 $path/$chnroute_v6
		echo "Generate complate"
		return 0
	else
		echo "CDN file not exist"
		return 1
	fi
}

if [ "$1" = "download" ];then
	download_cdn
elif [ "$1" = "generate" ];then
	generate_chnroute
else
	download_cdn
	generate_chnroute
fi
