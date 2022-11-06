FROM ubuntu:20.04

ARG node_bin

ADD opt /opt
RUN apt-get update && \
    apt-get install libssl1.1
RUN ln -s $node_bin /usr/sbin/erl-microservice
ENTRYPOINT ["/usr/sbin/erl-microservice", "start"]