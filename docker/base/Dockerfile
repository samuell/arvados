# Arvados base image (wheezy+rvm+Arvados source) in Docker

# Based on Debian Wheezy
FROM arvados/debian:wheezy
MAINTAINER Tim Pierce <twp@curoverse.com>

ENV DEBIAN_FRONTEND noninteractive

# Install prerequisite packages for Arvados
#   * git, curl, rvm
#   * Arvados source code in /usr/src/arvados, for preseeding gem installation

ADD apt.arvados.org.list /etc/apt/sources.list.d/
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7
RUN apt-get update -qq

RUN apt-get install -qqy apt-utils git curl \
             libcurl3 libcurl3-gnutls libcurl4-openssl-dev locales \
             postgresql-server-dev-9.1 python-arvados-python-client

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys D39DC0E3 && \
    /bin/sed -ri 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    /usr/sbin/locale-gen && \
    curl -L https://get.rvm.io | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.1 && \
    /usr/local/rvm/bin/rvm alias create default ruby-2.1 && \
    /bin/mkdir -p /usr/src/arvados

ADD generated/arvados.tar.gz /usr/src/arvados/

# Update gem. This (hopefully) fixes
# https://github.com/rubygems/rubygems.org/issues/613.
RUN /usr/local/rvm/bin/rvm-exec default gem update --system && \
    /usr/local/rvm/bin/rvm-exec default gem install bundler && \
    /usr/local/rvm/bin/rvm-exec default bundle install --gemfile=/usr/src/arvados/apps/workbench/Gemfile && \
    /usr/local/rvm/bin/rvm-exec default bundle install --gemfile=/usr/src/arvados/services/api/Gemfile && \
    /usr/local/rvm/bin/rvm-exec default bundle install --gemfile=/usr/src/arvados/doc/Gemfile
