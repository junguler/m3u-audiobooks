# easy-m3u-audiobooks
a collection of free audio books from archive.org in a easy to use m3u format

<br>

## Why?
because it's easier to listen than to download, there is so much stuff out there it doesn't make sense to me to download them when i can stream them and not put any load on the servers

<br>

## What kinds of audio books do you plan to include?
all kinds of different stuff, i'm planning to support this repo extensively, feel free to request different genres or artists and i'll try my best to include them here

<br>

## How?
it was started as a test to see if i could do it, now i have a system to scrape somewhat efficiently and i'm going to explain it here in detail, my script is also going to be added to repo so you can do it on your own too

<br>

## These lack extra info, where should look to know more about them
because everything is done in bulk, there is no way to name these manualy, luckily you can easily find the `archive.org` page for any audio books by adding it's name to this string and opening the page in your web browser, here is an example

i'm interested to know what the file `indian_fairy_tales_1304_librivox.m3u` is about, just add `https://archive.org/details/` in the begining of it to get the actual link like this :
```
https://archive.org/details/indian_fairy_tales_1304_librivox
```

<br>

## The bash script
this script relies on gnu core utils and the lynx web browser, if you are on linux or mac you already have access to gnu core utils and installing lynx is as easy of finding it in your package manager

on windows i recommend using cygwin, msys2 or wsl/2, cygwing has lynx packaged and there are windows binaries out them for other platforms

<details>
  <summary>click me to read</summary>
  
<br>

so the first thing to do is to make a text file that includes the links you want to scrape, this can have one or many links in it, here is an example list file, i'll call it `list.txt`

```
https://archive.org/details/alice_in_wonderland_librivox
https://archive.org/details/moby_dick_librivox
https://archive.org/details/game_of_life_0911_librivox
```

```
#!/bin/bash

echo "insert the name of text file including different archive.org pages to scrape from"
read list 
```

the first line is to let the shell know what kind of script we are going to run, the `echo` command here shows the text and let's the user know what to do, the `read` parts takes what the user wrote and holds it for when we need it, i'm going to write the name of my text file here which is `list` 

note: don't add the extension here, the name is all you need, the rest of the script runs on it's own and doesn't need any user intraction

```
sed -e 's!https://archive.org/details/!!' $list.txt > temp_a.txt
```

this `sed` command remove the `https://archive.org/details/` from every link and stores the output to the `temp_a.txt` file, we remove the extra part so naming the output files will be easier

```
sed -i 's/\r$//' temp_a.txt
```

this line convert the windows text file format to a unix one to avoid erros in file names, if you are not on windows just it's not needed but doesn't harm anything either

<br>

```
for i in $(cat temp_a.txt) ; do lynx --dump --listonly --nonumbers "https://archive.org/download/$i" | grep "128kb.mp3" | grep -v "64kb" | grep -v ".zip" > $i.txt ; done
```

this line scrapes the actual links, here is what's happening:

`lynx` is a command line web browser that easily dumps the data from a website for us, we are feeding the info from the `temp_a.txt` to it here via a for loop, this will go thru the text file one by one and inserts it into the program, `grep` is used here to find the string 1`28kb.mp3` and exclude the links with `64kb` and `.zip` in them, finally create the text files for each link with their archive.org names

this will work in most of the links but not all, so we will run this command again with a slightly differnt thing to look for to get all the links, so lets do that in the next line

```
find *.txt -size 0 | sed 's/.txt//g' > temp_b.txt
```

this line finds every file that doesn't has anything in it and copies their name to the temp_b.txt file, lets use this new file to get the other links

```
for i in $(cat temp_b.txt) ; do lynx --dump --listonly --nonumbers "https://archive.org/download/$i" | grep ".mp3" | grep -v "64kb" | grep -v ".zip" > $i.txt ; done
```

this command is very similar to the last command but here we are only looking for the links that weren't scrape correctly

<br>

```
for i in $(cat temp_a.txt) ; do sed "s/^/#EXTINF:-1\n/" $i.txt > temp_c-$i.txt ; done
```

now lets convert this text file to a m3u stream, add this string `#EXTINF:-1` above every link of text 

```
for i in $(cat temp_a.txt) ; do sed '1s/^/#EXTM3U\n/' temp_c-$i.txt > $i.m3u ; done
```

almost done, put this string `#EXTM3U`at the top of the text files and convert them to m3u streams

<br>

all done, now lets do some cleanup

```
rm temp_a.txt temp_b.txt temp_c-*.txt 
```

remove the temp files that were created in the process

```
find . -type f -empty -delete
```

remove any extra files that might be in the folder that are zero bytes

after the script is done doing it's thing, you are going to have two sets of files, the .txt files are just the links of the mp3 files, use them to download if you want and the m3u files, these are the ones i'm including here in this repo

</details>
