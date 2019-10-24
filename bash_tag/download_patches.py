
from bs4 import *
import requests
import urllib

url = "http://ftp.gnu.org/gnu/bash/bash-4.2-patches/"
# header = {'User-Agent': 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:57.0) Gecko/20100101 Firefox/57.0'}
location = "delhi technological university"
PARAMS = {'address':location}

req = requests.get(url)
soup = BeautifulSoup(req.text,'html.parser')
for item in soup.find_all('a'):
    try:
        req = requests.get('http://ftp.gnu.org/gnu/bash/bash-4.2-patches/'+item['href'], allow_redirects=True)
        open(item['href'], 'wb').write(req.content)
    except:
        print('error')
#
# html = urllib.request.urlopen(req).read()
# soup = BeautifulSoup(html,'lxml')
# print(soup.a)