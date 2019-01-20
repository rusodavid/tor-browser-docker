FROM debian:buster-slim
LABEL maintainer "Jessie Frazelle <jess@linux.com>"

RUN apt-get update && apt-get install -y \
	ca-certificates \
	curl \
	dirmngr \
	gnupg \
	libasound2 \
	libdbus-glib-1-2 \
	libgtk-3-0 \
        libcanberra-gtk* \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
	libxrender1 \
	libx11-xcb-dev \
	libx11-xcb1 \
	libxt6 \
	xz-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/anon anon

WORKDIR /home/anon

# Add TOR browser
RUN apt-get update && \
    apt-get install -y wget
ENV VERSION 8.0.4
RUN wget -O /home/anon/tor.tar.xz \
      https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz && \
    wget -O /home/anon/tor.tar.xz.asc \
      https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz.asc
#RUN gpg --keyserver ha.pool.sks-keyservers.net \
#      --recv-keys "EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290"
RUN gpg --keyserver ha.pool.sks-keyservers.net \
      --recv-keys 0x4E2C6E8793298290 
RUN gpg --fingerprint 0x4E2C6E8793298290
RUN gpg --verify /home/anon/tor.tar.xz.asc
RUN tar xvf /home/anon/tor.tar.xz && \
    rm -f /home/anon/tor.tar.xz*

RUN mkdir /home/anon/Downloads && \
    chown -R anon:anon /home/anon && \
    apt-get autoremove

USER anon

#ENTRYPOINT ["/bin/bash"]
CMD /home/anon/tor-browser_en-US/Browser/start-tor-browser

#ENV HOME /home/user
#RUN useradd --create-home --home-dir $HOME user \
#	&& chown -R user:user $HOME

#ENV LANG C.UTF-8

# https://www.torproject.org/projects/torbrowser.html.en
#ENV TOR_VERSION 8.0.4
#ENV TOR_FINGERPRINT 0x4E2C6E8793298290

# download tor and check signature
#RUN cd /tmp \
#	&& curl -sSOL "https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz" \
#	&& curl -sSOL "https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc" \
#	&& export GNUPGHOME="$(mktemp -d)" \
#	&& for server in $(shuf -e \
#			ha.pool.sks-keyservers.net \
#			hkp://p80.pool.sks-keyservers.net:80 \
#			keyserver.ubuntu.com \
#			hkp://keyserver.ubuntu.com:80 \
#			pgp.mit.edu) ; do \
#		gpg --no-tty --keyserver "${server}" --recv-keys ${TOR_FINGERPRINT} && break || : ; \
#	done \
 #	&& gpg --fingerprint --keyid-format LONG ${TOR_FINGERPRINT} | grep "Key fingerprint = EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290"
#RUN gpg --verify tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc \
#	&& tar -vxJ --strip-components 1 -C /usr/local/bin -f tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz \
#	&& rm -rf tor-browser* "$GNUPGHOME" \
#	&& chown -R user:user /usr/local/bin
#
# good fonts
#COPY local.conf /etc/fonts/local.conf

#WORKDIR $HOME
#USER user

#ENTRYPOINT ["/bin/bash"]
#CMD [ "/usr/local/bin/Browser/start-tor-browser", "--log", "/dev/stdout" ]

