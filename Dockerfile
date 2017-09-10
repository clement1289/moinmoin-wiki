# Forked from olavgg/moinmoin-wiki

FROM debian:jessie
MAINTAINER Clement Thomas <clement1289@hotmail.com>

# Set the version you want of MoinMoin
ENV MM_VERSION=1.9.8 MM_CSUM=4a616d12a03f51787ac996392f9279d0398bfb3b \
    MM_USER=1000

# Install
RUN apt-get update && apt-get install -qqy --no-install-recommends python curl openssl nginx uwsgi uwsgi-plugin-python \
    && usermod -u ${MM_USER} www-data && curl -Ok https://bitbucket.org/thomaswaldmann/moin-1.9/get/$MM_VERSION.tar.gz \
    && if [ "$MM_CSUM" != "$(sha1sum $MM_VERSION.tar.gz | awk '{print($1)}')" ]; then exit 1; fi \
    && mkdir moinmoin && tar xf $MM_VERSION.tar.gz -C moinmoin --strip-components=1 && cd moinmoin \
    && python setup.py install --force --prefix=/usr/local && mkdir -p /usr/local/share/moin/underlay/pages

ADD wikiconfig.py /usr/local/share/moin/
ADD nginx.conf /etc/nginx/
ADD moinmoin.conf /etc/nginx/sites-available/

RUN chown -Rh ${MM_USER} /usr/local/share/moin/ && mkdir -p /var/cache/nginx/cache \
    && ln -s /etc/nginx/sites-available/moinmoin.conf /etc/nginx/sites-enabled/moinmoin.conf \
    && rm /etc/nginx/sites-enabled/default && rm $MM_VERSION.tar.gz && rm -rf /moinmoin && rm /usr/local/share/moin/underlay.tar && apt-get purge -qqy curl \
    && apt-get autoremove -qqy && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

EXPOSE 80

CMD service nginx start && \
  uwsgi --uid ${MM_USER} \
    -s /tmp/uwsgi.sock \
    --plugins python \
    --pidfile /var/run/uwsgi-moinmoin.pid \
    --wsgi-file server/moin.wsgi \
    -M -p 4 \
    --chdir /usr/local/share/moin \
    --python-path /usr/local/share/moin \
    --harakiri 30 \
    --die-on-term
