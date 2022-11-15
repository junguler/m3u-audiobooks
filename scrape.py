import argparse
from time import sleep
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

parser = argparse.ArgumentParser()

parser.add_argument("--url", help="the web page to scrape from", default='https://www.google.com/')

args = parser.parse_args()

options = Options()
options.headless = True

driver = webdriver.Firefox(options=options)

driver.maximize_window()

driver.get(args.url)

SCROLL_PAUSE_TIME = 5

last_height = driver.execute_script("return document.body.scrollHeight")

scroll_limit = 100

count = 0
while True and count < scroll_limit:
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    sleep(SCROLL_PAUSE_TIME)

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
