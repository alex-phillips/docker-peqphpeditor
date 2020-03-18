FROM lsiobase/nginx:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PEQPHPEDITOR_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	mariadb-client \
	php7 \
	php7-mysqli && \
 echo "**** install peqphpeditor ****" && \
 mkdir -p /app/peqphpeditor && \
 if [ -z ${PEQPHPEDITOR_RELEASE+x} ]; then \
	PEQPHPEDITOR_RELEASE=$(curl -sX GET "https://api.github.com/repos/ProjectEQ/peqphpeditor/commits/master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 	/tmp/peqphpeditor.tar.gz -L \
	"https://github.com/ProjectEQ/peqphpeditor/archive/${PEQPHPEDITOR_RELEASE}.tar.gz" && \
 tar xf \
 	/tmp/peqphpeditor.tar.gz -C \
	/app/peqphpeditor/ --strip-components=1 && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /
