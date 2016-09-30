FROM bytesized/base
MAINTAINER maran@bytesized-hosting.com

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm'
RUN \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
  mono mono-dev

RUN apk -U add \
  ca-certificates \
  make \
  g++ gcc git \
  sqlite sqlite-libs \
  xz \
  unrar \
  wget \
  zlib zlib-dev

ARG MEDIAINFO_VERSION="0.7.88"

RUN cd / && \
      wget "https://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VERSION}/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
      -O "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
      wget "https://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VERSION}/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
      -O "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
      cd / && \
      tar xpf "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
      tar xpf "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
      cd /MediaInfo_CLI_GNU_FromSource && \
      ./CLI_Compile.sh && \
      cd /MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI/ && \
      make install && \
      \
      cd /MediaInfo_DLL_GNU_FromSource && \
      ./SO_Compile.sh && \
      cd /MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && \
      make install && \
      cd /MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library && \
      make install

RUN mkdir -p /root/.config/ && ln -sf /config /root/.config/NzbDrone

RUN mkdir /app && cd /app && wget https://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz \
      -O NzbDrone.master.tar.gz && \
      tar xzvf NzbDrone.master.tar.gz

RUN apk del \
    make \
    g++ gcc git sqlite \
    wget && \
    rm -rf "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
    rm -rf "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
    rm -rf /MediaInfo_CLI_GNU_FromSource && \
    rm -rf /MediaInfo_DLL_GNU_FromSource && \
    rm -rf /NzbDrone.master.tar.gz && \
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

COPY /static /

VOLUME /config /data /tv

EXPOSE 8989
