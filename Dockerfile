FROM ubuntu:latest
FROM gcc:latest

RUN sudo apt-get update && \
    sudo apt-get install -y curl

WORKDIR /tmp

RUN curl https://sh.rustup.rs -sSf > rustup.sh
RUN chmod 755 rustup.sh
RUN ./rustup.sh -y
RUN rm /tmp/rustup.sh

RUN ~/.cargo/bin/cargo install mdbook
RUN cargo install clarity-repl
RUN curl -L https://github.com/hirosystems/clarinet/releases/download/v0.33.0/clarinet-linux-x64-glibc.tar.gz > yarn.tar.gz
RUN tar -xf yarn.tar.gz
RUN sudo mv ./clarinet /usr/local/bin
RUN rm -f yarn.tar.gz
RUN clarinet check
CMD ["clarinet","integrate"]

# ./rustup.sh -y
# ~/.cargo/bin/cargo install mdbook
# cargo install clarity-repl
# curl -L https://github.com/hirosystems/clarinet/releases/download/v0.33.0/clarinet-linux-x64-glibc.tar.gz > yarn.tar.gz