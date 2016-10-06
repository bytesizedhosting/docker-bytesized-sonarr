FROM bytesized/debian-base
MAINTAINER maran@bytesized-hosting.com
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list && \
  echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
      && echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list \
      && apt-get update -q
RUN apt-get install -qy mono-complete\
      && apt-get install -qy nzbdrone mediainfo \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY /static /

VOLUME /config /data /tv

EXPOSE 8989
