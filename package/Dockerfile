FROM fluent/fluentd:v1.1-debian

RUN buildDeps="sudo build-essential libc-dev ruby-dev" \
 && echo "gem: --no-ri --no-rdoc" >> ~/.gemrc \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install fluent-plugin-elasticsearch -v 2.11.10 \
 && gem install fluent-plugin-kubernetes_metadata_filter -v 2.0.0 \
 && gem install fluent-plugin-splunk-enterprise -v 0.9.1 \
 && gem install fluent-plugin-kafka -v 0.7.9 \
 && gem install fluent-plugin-remote_syslog_tls -v 1.0.2 \ 
 && gem install fluent-plugin-rewrite-tag-filter -v 2.1.0 \
 && gem install fluent-plugin-prometheus -v 1.1.0 \
 && gem install zookeeper -v 1.4.11 \
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
