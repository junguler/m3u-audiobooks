#!/bin/bash

base="https://archive.org/services/search/v1/scrape?fields=title&q="
search=$1

# curl -s $base$search > raw.json
wget -O raw.json -q -i $base$search
jq -r '.items[].identifier' raw.json >> $search.txt
jq -r '.cursor' raw.json | grep -v "null" > cursor.txt

pre="&cursor="
cursor="$(cat cursor.txt)"

while [[ $(jq -r '.total' raw.json) > 5000 ]]
do
	sleep 1
	wget -O raw.json -q -i $base$search$pre$cursor
	jq -r '.items[].identifier' raw.json >> $search.txt
	jq -r '.cursor' raw.json | grep -v "null" > cursor.txt
	sleep 1
done
