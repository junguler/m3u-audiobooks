#!/bin/bash

# this is a constant in every api request so i've added it as a variable
base="https://archive.org/services/search/v1/scrape?fields=title&q="

# this one determines what to look for
search=$1

# curl -s $base$search > raw.json

# scrape first 5000 or less entries
wget -O raw.json -q -i $base$search

# insert links to a text file
jq -r '.items[].identifier' raw.json >> $search.txt

# copy the cursor if it exist to keep requesting next enteries in the api
jq -r '.cursor' raw.json | grep -v "null" > cursor.txt

# just a string that needs to be present before the cursor
pre="&cursor="

# make the scrape command easier to read by storing the cursor to a variable
cursor="$(cat cursor.txt)"

# while loop, keep looking at the file and scrape the api until it finds less than 5000 entries in which case there won't be a need to scrape the cursor further
while [[ $(jq -r '.total' raw.json) > 5000 ]]
do
	sleep 1
	wget -O raw.json -q -i $base$search$pre$cursor
	jq -r '.items[].identifier' raw.json >> $search.txt
	jq -r '.cursor' raw.json | grep -v "null" > cursor.txt
	sleep 1
done
