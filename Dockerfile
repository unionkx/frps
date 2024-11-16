FROM debian:12.8-slim
ENV FRP_VERSION=0.61.0
RUN mkdir /workspace
WORKDIR /workspace
RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    make \
    && wget -c https://github.com/fatedier/frp/archive/refs/tags/v${FRP_VERSION}.tar.gz \
    && tar zxvf v${FRP_VERSION}.tar.gz \
    && cd frp-${FRP_VERSION} \
    && make \
    && cp -rfv bin conf /workspace/ \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*
    
COPY --from=builder /workspace/bin/frps /usr/bin/
COPY --from=builder /workspace/conf/frps.toml /etc/frp/
ENTRYPOINT ["/usr/bin/frps"]
CMD ["-c", "/etc/frp/frps.toml"]
