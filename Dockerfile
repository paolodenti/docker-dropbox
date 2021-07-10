FROM debian:buster

ARG DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
	gir1.2-pango-1.0 \
	gir1.2-gtk-3.0 \
	gir1.2-gdkpixbuf-2.0 \
	lsb-release \
	libpango1.0-0 \
	libgtk-3-0 \
	libatk1.0-0 \
	python3 \
	python3-gi \
	python3-qt-binding \
	procps \
	wget \
	ca-certificates

RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* \
    /var/cache/* \
    /usr/share/doc/* \
    /usr/share/locale/*

# Create service account and set permissions.
RUN groupadd dropbox \
	&& useradd -m -d /dbox -c "Dropbox Daemon Account" -s /usr/sbin/nologin -g dropbox dropbox

USER dropbox

RUN cd /dbox && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
RUN mkdir -p /dbox/.dropbox /dbox/.dropbox-dist /dbox/Dropbox /dbox/base

# Switch back to root, since the run script needs root privs to chmod to the user's preferrred UID
USER root

# Prevent dropbox to overwrite its binary
RUN mkdir -p /opt/dropbox
RUN mv /dbox/.dropbox-dist/dropbox-lnx* /opt/dropbox/
RUN mv /dbox/.dropbox-dist/dropboxd /opt/dropbox/
RUN mv /dbox/.dropbox-dist/VERSION /opt/dropbox/
RUN rm -rf /dbox/.dropbox-dist
RUN install -dm0 /dbox/.dropbox-dist

# Prevent dropbox to write update files
RUN chmod u-w /dbox
RUN chmod o-w /tmp
RUN chmod g-w /tmp

# Install init script and dropbox command line wrapper
COPY run /root/.

WORKDIR /dbox/Dropbox
VOLUME ["/dbox/.dropbox", "/dbox/Dropbox"]

ENTRYPOINT ["/root/run"]