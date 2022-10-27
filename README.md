# easy-m3u-audiobooks
a collection of free audio books from archive.org in a easy to use m3u format

## Why?
because it's easier to listen than to download, there is so much stuff out there it doesn't make sense to me to download them when i can stream them and not put any load on the servers

## What kinds of audio books do you plan to include?
all kinds of different stuff, i'm planning to support this repo extensively, feel free to request different genres or artists and i'll try my best to include them here

## How?
it was started as a test to see if i could do it, now i have a system to scrape somewhat efficiently and i'm going to explain it here in detail, my script is also going to be added to repo so you can do it on your own too

## These lack extra info, where should look to know more about them
because everything is done in bulk, there is no way to name these manualy, luckily you can easily find the `archive.org` page for any audio books by adding it's name to this string and opening the page in your web browser, here is an example

i'm interested to know what the file `indian_fairy_tales_1304_librivox.m3u` is about, just add `https://archive.org/details/` in the begining of it to get the actual link like this :
```
https://archive.org/details/indian_fairy_tales_1304_librivox
```

## The bash script
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
