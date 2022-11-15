## Why?
because it's easier to listen than to download, there is so much stuff out there it doesn't make sense to me to download them when i can stream them and not put any load on the servers

<br>

## What kinds of audio books do you plan to include?
all kinds of different stuff, i'm planning to support this repo extensively, feel free to request different genres or author and i'll try my best to include them here

<br>

## These lack extra info, where should i look to know more about them
because everything is done in bulk, there is no way to name these manualy, luckily you can easily find the `archive.org` page for any audio books by adding it's name to this string and opening the page in your web browser, here is an example

i'm interested to know what the file `indian_fairy_tales_1304_librivox.m3u` is about, just add `https://archive.org/details/` in the begining of it to get the actual link like this :
```
https://archive.org/details/indian_fairy_tales_1304_librivox
```

<br>

## The bash script
this script relies on gnu core utils and the lynx web browser, if you are on linux or mac you already have access to gnu core utils and installing lynx is as easy of finding it in your package manager

on windows i recommend using cygwin, msys2 or wsl/2, cygwing has lynx packaged and there are windows binaries out there for other platforms

<details>
  <summary>click me to read</summary>
  
<br>

so the first thing to do is to make a text file that includes the links you want to scrape, this can have one or many links in it, here is an example list file, i'll call it `list.txt`

```
https://archive.org/details/alice_in_wonderland_librivox
https://archive.org/details/moby_dick_librivox
https://archive.org/details/game_of_life_0911_librivox
```
  
<br>

now make the script executable by running this command
```
chmod +x m3u.sh
```
without this permission you won't be able to run the script in a unix envierment
  
<br>

```
#!/bin/bash

echo "insert the name of text file including different archive.org pages to scrape from"
read list 
```

the first line is to let the shell know what kind of script we are going to run, the `echo` command here shows the text and let's the user know what to do, the `read` parts takes what the user wrote and holds it for when we need it, i'm going to write the name of my text file here which is `list` 

note: don't add the extension here, the name is all you need, the rest of the script runs on it's own and doesn't need any user intraction
  
<br>

```
sed -e 's!https://archive.org/details/!!' $list.txt > temp_a.txt
```

this `sed` command remove the `https://archive.org/details/` from every link and stores the output to the `temp_a.txt` file, we remove the extra part so naming the output files will be easier
  
<br>

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
  
<br>

```
find *.txt -size 0 | sed 's/.txt//g' > temp_b.txt
```

this line finds every file that doesn't has anything in it and copies their name to the temp_b.txt file, lets use this new file to get the other links
  
<br>

```
for i in $(cat temp_b.txt) ; do lynx --dump --listonly --nonumbers "https://archive.org/download/$i" | grep ".mp3" | grep -v "64kb" | grep -v ".zip" > $i.txt ; done
```

this command is very similar to the last command but here we are only looking for the links that weren't scraped correctly

<br>

```
for i in $(cat temp_a.txt) ; do sed "s/^/#EXTINF:-1\n/" $i.txt > temp_c-$i.txt ; done
```

convert these text files to a m3u streams, add this string `#EXTINF:-1` above every link in text files

<br>

```
for i in $(cat temp_a.txt) ; do sed '1s/^/#EXTM3U\n/' temp_c-$i.txt > $i.m3u ; done
```

almost done, put this string `#EXTM3U`at the top of the text files and convert them to m3u streams

<br>

all done, now lets do some clean up

```
rm temp_a.txt temp_b.txt temp_c-*.txt 
```

remove the temp files that were created in the process

```
find . -type f -empty -delete
```

remove any extra files that might be in the folder that are zero bytes
  
<br>

after the script is done doing it's thing, you are going to have two sets of files, the .txt files are just the links of the mp3 files, use them to download the audio books if you want 

and the m3u files, these are the ones i'm including here in this repo, drag them to vlc or mpv to start listening

</details>

<br>

## Scrape the links from a archive.org search query in firefox
some times you want every link from a search query to be listed in your list.txt file and don't want to manually include them in the text file, lets take the laziness one step further and do that via the commandline too

<details>
  <summary>click me to read</summary>
  
<br>

open this link in firefox browser `https://archive.org/details/audio_bookspoetry` and search for the subject you are looking for, now take a look at the left side of the page to see how many entries are listed, now scroll the page down so all of them show up so when we save the page all of them are present

save the page as a plain text, now lets use this text file to find the links, i've named this page `web.txt`

```
cat web.txt | grep "https://archive.org/details/" | grep -v "@\|?\|*\|#\| " | awk '!seen[$0]++' | sed 's/[<>,]//g' > page.txt
```

using `grep` look for this string `https://archive.org/details/` , with `grep` exclude `@?* #`, use `awk` to remove duplicated entries and `sed` again to remove the few rogue tags that might stil be there, now you are left with the `page.txt` file that is ready to be used with the main script

</details>

<br>

## Scrape the links from a archive.org search query in chrome
because there is no save as plain text option in chrome we have to do a little work-around for this, i'll explain how

<details>
  <summary>click me to read</summary>
  
<br>

just like in the firefox method, search for the subject you want and scroll down so all of the links are shown and there is no more loading, now save the page in complete html

in the terminal naviagte to the folder you have saved this html file and run this command, i've named it `page.html` in this example

```
lynx --dump --listonly --nonumbers page.html | grep "https://archive.org/details/" | grep -v "@\|?\|*\|#\| " | awk '!seen[$0]++' | sed 's/[<>,]//g' > list.txt
```

now you have a `list.txt` that can be used with the script just like the firefox version, there are a few random links in this list file but the script will ignore them because it can't find any mp3 files inside them

</details>

<br>

## Scrape the links from a archive.org using python and selenium
trying to make things more automated i've made a simple python script to scrape the pages and scroll down the dynamic pages automatically, lets explain this in some detail

<details>
  <summary>click me to read</summary>
  
<br>

first install python3 if you don't have it already and using pip install `BeautifulSoup` and `selenium`

```
pip3 install selenium bs4
```

you also need to install firefox if you don't have it already and download [geckodriver](https://github.com/mozilla/geckodriver/releases) and make sure both of them are on your system PATH

i'm not going to explain how the python script itself works because i don't even know it but i know how to use it and that's what i'll go over

```
python3 scrape.py --url https://archive.org/details/librivoxaudio?and[]=year%3A%222007%22
```

the above command scrapes all the links from `https://archive.org/details/librivoxaudio?and[]=year%3A%222007%22` and prints them to your terminal, now lets pipe this output to several programs to get a usefull output for our `m3u.sh` script

```
python3 scrape.py --url https://archive.org/details/librivoxaudio?and[]=year%3A%222007%22 | sort | uniq | grep "details" | grep -v "@\|?\|%" | sed 's/^/https:\/\/archive.org/' > links.txt
```

`sort` does exactly what you think and it's required for `uniq` to work, uniq removes duplicates, then using `sed` we look for `details` in links because all of the pages we want to scrape from include them, remove `@?%` using `sed` because those links are also irrelevent to us and finally using `sed` add the string `https://archive.org` to the begining of all the links and save to `links.txt`

this will effectively get us the exact same output if we scrolled the pages to the bottom and saved them manually

</details>
