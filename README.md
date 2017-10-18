moinmoin-wiki
=============

Docker image with the Moinmoin wiki engine, uwsgi, nginx.

# Image info
* Forked from https://github.com/olavgg/moinmoin-wiki
* supports mounting wiki content as volumes with configurable UID for read/write

# how to run

* run moinmoin wiki engine
```
sudo docker run -it -p 80:80 clement89/moinmoin-wiki
``` 
* if the moinmoin data is available at /opt/wiki/pages with uid 1001 owing the files,then
```
tree /opt/wiki/pages
├── TCPIP
│   ├── current
│   └── revisions
│       └── 00000001
├── TaxNotes
│   ├── current
│   ├── edit-log
│   └── revisions
│       └── 00000001
├── Troubleshooting
│   ├── current
│   └── revisions
│       └── 00000001

here TCPIP,TaxNotes etc are moinmoin wiki pages

sudo docker run -it -p 80:80 -v /opt/wiki/pages:/usr/local/share/moin/data/pages -e MMUSER=1001 clement89/moinmoin-wiki
``` 
* customize wikiconfig.py or moinmoin.conf if you wish
```
sudo docker run -it -p 80:80 -v /moinmoin-wiki/wikiconfig_customized.py:/usr/local/share/moin/wikiconfig.py clement89/moinmoin-wiki
``` 


### Todo
* create ssl certificates 
