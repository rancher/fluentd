# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This Dockerfile will build an image that is configured
# to run Fluentd with an Genfile plug-in and the
# provided configuration file.
# The image acts as an executable for the binary /usr/sbin/td-agent.
# Note that fluentd is run with root permssion to allow access to
# log files with root only access under /var/log/containers/*

FROM debian:stable-20210816-slim

ARG DEBIAN_FRONTEND=noninteractive

COPY clean-apt /usr/bin
COPY clean-install /usr/bin
COPY Gemfile /Gemfile
COPY Gemfile.lock /Gemfile.lock

RUN BUILD_DEPS="make ruby-dev build-essential autoconf automake libtool libsnappy-dev" \
    && clean-install $BUILD_DEPS \
                     ca-certificates \
                     ruby \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem install bundler \
    && CFLAGS=-Wno-error=format-overflow bundle install \
    && apt-get purge -y --auto-remove \
                     -o APT::AutoRemove::RecommendsImportant=false \
                     $BUILD_DEPS \
    && clean-apt \
    # Ensure fluent has enough file descriptors
    && ulimit -n 65536 \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem /usr/lib/ruby/gems/2.*/gems/fluentd-*/test \
    # Remove file due to red herring: https://github.com/fluent/fluentd/issues/3374#issuecomment-840916184
    && rm -f /usr/lib/ruby/gems/2.7.0/gems/http_parser.rb-0.6.0/Gemfile.lock

# Copy the Fluentd configuration file for logging Docker container logs.
COPY fluent.conf /etc/fluent/fluent.conf
COPY run.sh /run.sh
COPY upgrade-gems.sh /upgrade-gems.sh

# Expose prometheus metrics.
EXPOSE 80

# Start Fluentd to pick up our config that watches Docker container logs.
CMD /run.sh $FLUENTD_ARGS
