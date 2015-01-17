#!/usr/bin/bash

if [[ $# -ne 2 ]]; then
    exit
fi
tmpfile=/tmp/luc_cheesemaker_df_html
rssscript=./bay12forum.pl

curl $2 > $tmpfile 2> /dev/null
url=$(cat $tmpfile | perl -e 'while(my $line=<>) { if($line =~ m~Pages:.*<a class="navPages" href="(.*?)">\d+</a>\s*</div>$~) { print "$1"; exit(); } }')
curl $url > $tmpfile 2> /dev/null
cat $tmpfile | exec $rssscript $1 $2 $url

