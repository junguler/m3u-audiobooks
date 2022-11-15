import argparse
from time import sleep
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

# enable passing url from the command line
parser = argparse.ArgumentParser()

parser.add_argument("--url", help="the web page to scrape from", default='https://www.google.com/')

args = parser.parse_args()

# make firefox headless
options = Options()
options.headless = True

driver = webdriver.Firefox(options=options)

driver.maximize_window()

# get url to scrape
driver.get(args.url)

# amount of seconds to wait before each scroll
SCROLL_PAUSE_TIME = 5

last_height = driver.execute_script("return document.body.scrollHeight")

# number of total scrolls, usefull for infinite scroll websites
scroll_limit = 100

count = 0
while True and count < scroll_limit:
    # Scroll down to bottom
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    # Wait to load page
    sleep(SCROLL_PAUSE_TIME)

    # Calculate new scroll height and compare with last scroll height
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height
    count += 1

sleep(1) 

html = driver.page_source
soup = BeautifulSoup(html, 'html.parser')
            
for a in soup.find_all('a', href=True):
    print(a['href'])

driver.close()

# script was adapted from this gist https://gist.github.com/wkarney/11e5f1beeb85f7670f1a077115c681e2
