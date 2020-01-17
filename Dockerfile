FROM ubuntu:bionic

LABEL MAINTAINER="pcop <rachen@eri.com.tw>"

RUN sed -i 's/http:\/\/archive/http:\/\/tw\.archive/g' /etc/apt/sources.list
RUN apt update
RUN apt install -y gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN apt install -y mono-complete libgdiplus curl wget
RUN curl https://jexus.org/release/install|sh
RUN sed -i 's/export MONO_ENV_OPTIONS/#export MONO_ENV_OPTIONS/g' /usr/jexus/jws
RUN sed -i 's/# export MONO_IOMAP/export MONO_IOMAP/g' /usr/jexus/jws
RUN sed -i 's/zh_CN/zh_TW/g' /usr/jexus/jws

COPY src/bootstrap.sh /usr/bin/

EXPOSE 80 443

VOLUME ["/usr/jexus/siteconf", "/var/www", "/usr/jexus/log"]

WORKDIR /usr/jexus

ENTRYPOINT ["/usr/bin/bootstrap.sh"]

# Healthy check
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 \
  CMD curl -f http://127.0.0.1 || exit 1
