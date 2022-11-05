FROM ubuntu:20.04

COPY _build/prod /opt/_build/prod
RUN apt-get update && \
    apt-get install libssl1.1
RUN chmod +x -R /opt/_build/prod
RUN ln -s /opt/_build/prod/rel/fyp/bin/fyp /usr/sbin/fyp-server
RUN chmod +x /usr/sbin/fyp-server
ENTRYPOINT ["/usr/sbin/fyp-server", "start"]
