FROM fluent/fluentd:v1.1-debian

RUN buildDeps="sudo build-essential libc-dev ruby-dev" \
 && echo "gem: --no-ri --no-rdoc" >> ~/.gemrc \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-elasticsearch \
 && gem install fluent-plugin-secure-forward \
 && gem install fluent-plugin-kubernetes_metadata_filter \
 && gem install fluent-plugin-splunk-enterprise \
 && gem install fluent-plugin-kafka \
 && gem install fluent-plugin-remote_syslog_tls \ 
 && gem install fluent-plugin-rewrite-tag-filter \
 && gem install fluent-plugin-prometheus \
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
RUN mkdir -p /fluentd/etc/config/custom/cluster/
RUN mkdir -p /fluentd/etc/config/custom/project/
RUN mkdir -p /fluentd/etc/config/system/

COPY fluent.conf /fluentd/etc/
COPY custom_cluster.conf /fluentd/etc/config/custom/
COPY custom_project.conf /fluentd/etc/config/custom/
COPY metrics.conf /fluentd/etc/config/system/

EXPOSE 24224 5140

CMD exec fluentd -c /fluentd/etc/${FLUENTD_CONF}
