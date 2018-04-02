FROM fluent/fluentd:v0.14-debian

RUN buildDeps="sudo build-essential libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-elasticsearch \
 && gem install fluent-plugin-secure-forward \
 && gem install fluent-plugin-kubernetes_metadata_filter \
 && gem install fluent-plugin-aws-elasticsearch-service \
 && gem install fluent-plugin-splunk-http-eventcollector \
 && gem install fluent-plugin-kafka \
 && gem install fluent-plugin-remote_syslog \
 && gem install fluent-plugin-rewrite-tag-filter \
 && gem install zookeeper \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

ENV FLUENTD_CONF="fluent.conf"

RUN mkdir -p /fluentd/etc/buffer
RUN mkdir -p /fluentd/etc/config/customer/cluster/
RUN mkdir -p /fluentd/etc/config/customer/project/

COPY fluent.conf /fluentd/etc/
COPY custom_cluster.conf /fluentd/etc/config/customer/
COPY custom_project.conf /fluentd/etc/config/customer/

EXPOSE 24224 5140

CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF}