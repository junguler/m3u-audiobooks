## How to download?
there is two main ways to download these, either use the automatically generated [zip file](https://github.com/junguler/easy-m3u-audiobooks/archive/refs/heads/main.zip) (this file gets updated every time i push updates to this repo)

or use git
```
git clone https://github.com/junguler/easy-m3u-audiobooks.git
```
for furthur updates cd into the git folder on your hard drive and do a `git pull`

<br>

## How to listen to these?
in the terminal, cd into the folder and do this:
```
mpv librivox/2005/A_Christmas_Carol.m3u
```
or add/change `m3u` file association in your os to mpv or vlc and double click on any of `.m3u` files in your file manager

<br>

## Why?
because it's easier to listen than to download, there is so much stuff out there it doesn't make sense to me to download them when i can stream them and not put any load on the servers

<br>

## What kinds of audio books do you plan to include?
all kinds of different stuff, i'm planning to support this repo extensively, feel free to request different genres or authors and i'll try my best to include them here

<br>

## These lack extra info, where should i look to know more about them
because everything is done in bulk, there is no way to name these manualy, luckily you can easily find the `archive.org` page for any audio books by adding it's name to this string and opening the page in your web browser, here is an example

i'm interested to know what the file `indian_fairy_tales_1304_librivox.m3u` is about, just add `https://archive.org/details/` in the begining of it to get the actual link like this :
```
https://archive.org/details/indian_fairy_tales_1304_librivox
```

<br>

if you prefer to stay in the terminal you can also use something like this, lets find the title of this file
```
curl --silent https://archive.org/details/indian_fairy_tales_1304_librivox | htmlq h1 -t | sed -n '2 p' | sed 's/^ *//'
```
this outputs `Indian Fairy Tales` which is the exact title that is shown in the website, other details can also be taken from the page but in most cases the title is enough so i leave it at that
