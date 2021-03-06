FROM ruby:2.6.3-slim-stretch

MAINTAINER Jacob Brackett <jbrackett@onemedical.com>

RUN apt-get update && apt-get install -qq -y curl gnupg

# Grab PostgreSQL key and add source
RUN curl -L -s -m 10 https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list


RUN apt-get update && apt-get install -qq -y build-essential libpq-dev postgresql-server-dev-11 postgresql-11 postgresql-client-11 redis-server wkhtmltopdf libicu-dev --fix-missing --no-install-recommends
RUN apt-get install -y --fix-missing xvfb

# wkhtmltopdf needs some sort of x server
RUN printf '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh && chmod a+x /usr/bin/wkhtmltopdf.sh && ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

ENV INSTALL_PATH /
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
RUN bundle install

# Fix data_mapper & Sinatra 2 conflict (https://github.com/sinatra/sinatra/issues/1294)
RUN find / -name json-2.1.0.gemspec -exec rm {} \; 

COPY . .

VOLUME ["$INSTALL_PATH/public"]

CMD thin start -p 443 --threaded --ssl --ssl-cert-file server.crt --ssl-key-file server.key


