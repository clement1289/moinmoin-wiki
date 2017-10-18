moinmoin-wiki
=============

Docker image with the Moinmoin wiki engine, uwsgi, nginx.

# Image info
* Forked from https://github.com/olavgg/moinmoin-wiki
* supports mounting wiki content as volumes with configurable UID for read/write

# Environment Variables

Environment Variable | Description
-------------------- | ------------
MM_UID | The UID which owns the wiki pages. Default is 1000
MM_ADMIN | The moinmoin admin user that will be created. Default is mmAdmin
MM_EMAIL | MM_ADMIN email address. Default is user@moinmoin.example.org
MM_VHOST | The nginx virtual host name. Default is moinmoin.example.org.
MM_PASSWD | password of the MM_ADMIN user. Default is randomly generated. The randomly generated password is printed to stdout and so docker logs should print it

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

sudo docker run -it -p 80:80 \
     -v /opt/wiki/pages:/usr/local/share/moin/data/pages \
     -e MMUSER=1001 \
     clement89/moinmoin-wiki
``` 
* Override any default environment variables and use customized wikiconfig.py if required
```
sudo docker run -it -p 80:80 \
     -v /opt/wiki/pages:/usr/local/share/moin/data/pages \
     -v /moinmoin-wiki/wikiconfig_customized.py:/usr/local/share/moin/wikiconfig.py \
     -e MMUSER=1001 \
     -e MM_ADMIN=clement \
     -e MM_EMAIL=myemail@gmail.com \
     -e MM_VHOST=wiki.example.org \
     -e MM_PASSWD=testpasswdchangeme \
     clement89/moinmoin-wiki
``` 


### Todo
* create ssl certificates 
