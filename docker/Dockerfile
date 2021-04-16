FROM ubuntu:18.04

COPY _build/prod /opt/_build/prod
RUN apt-get update && \
    apt-get install libssl1.1
RUN ln -s /opt/_build/prod/rel/fyp/bin/fyp /usr/sbin/fyp-server
ENTRYPOINT ["/usr/sbin/fyp-server", "start"]
