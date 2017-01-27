
# wget http://s3.amazonaws.com/commoncrawl/crawl-data/CC-MAIN-2016-50/segments/1480698540409.8/wat/CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wat.gz


if (($# != 1)); then
	echo "Must give number of wat files to download."
	echo "Should be of the form \"./download-wat-files.sh <number-of-files>\""
	exit -1
fi

num_files=$1
local_target=./wat-files
hdfs_target=/tmp/wat-files

echo "~~~~~ Dowloading files... ~~~~~"

i=0
while read line; do

	wget -P $local_target http://s3.amazonaws.com/commoncrawl/$line
	NAME=$(echo $(basename $line))
	# gunzip $local_target/$NAME

	echo "~~~~~ Moving to HDFS ~~~~~"
	hadoop fs -put $local_target/$NAME $hdfs_target/$NAME

	rm -f $local_target/$NAME

	i=$i+1
	if (( i >= $num_files )); then
		exit 0
	fi
done < wat.paths



