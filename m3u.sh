#!/bin/bash

# take the list to scrape from, don't include the extension like .txt
echo "insert the name of text file including different archive.org pages to scrape from"
read list 

# remove extra part of the links to make naming the output files easier
sed -e 's!https://archive.org/details/!!' $list.txt > temp_a.txt

# fix filename errors that some times occur on windows
sed -i 's/\r$//' temp_a.txt

echo "start scraping the links for mp3 files"

# for links containing the 128kb.mp3 string
for i in $(cat temp_a.txt) ; do lynx --dump --listonly --nonumbers "https://archive.org/download/$i" | grep -iF "128kb.mp3" | grep -iFv "64kb" | grep -iFv ".zip" > $i.txt ; done

# find empty files if there is any and copy their names for the next command 
find *.txt -size 0 | sed 's/.txt//g' > temp_b.txt

# for other links if there is any
for i in $(cat temp_b.txt) ; do lynx --dump --listonly --nonumbers "https://archive.org/download/$i" | grep -iF ".mp3" | grep -iFv "64kb" | grep -iFv ".zip" > $i.txt ; done

echo "create m3u playlists out of text files"

# add #EXTINF:-1 at the begining of every other line and #EXTM3U at the first line and convert the text file to m3u stream
for i in $(cat temp_a.txt) ; do sed "s/^/#EXTINF:-1\n/" $i.txt | sed '1s/^/#EXTM3U\n/' > $i.m3u ; done

echo "remove empty and temp files"

# remove temp files
#for i in $(cat temp_a.txt) ; do rm $i.txt ; done

rm temp_a.txt temp_b.txt

# remove empty files (links that didn't have mp3 files in them)
find . -type f -empty -delete

echo "job done"
