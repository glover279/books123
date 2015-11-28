FROM racker/precise-with-updates:latest
MAINTAINER santi@regueiro.es

RUN apt-get update -y && apt-get dist-upgrade -y

RUN apt-get install -y calibre

RUN apt-get clean

RUN rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*rack*.com* && rm -rf /var/lib/apt/lists/security.ubuntu.com_ubuntu_dists_precise-security_*


EXPOSE 8080

RUN mkdir /opt/calibre && mkdir /opt/calibre/library

VOLUME        ["/opt/calibre/library"]
ENTRYPOINT           ["/usr/bin/calibre-server", "--with-library=/opt/calibre/library"]

RUN echo deb http://archive.ubuntu.com/ubuntu/ trusty multiverse >> \
    /etc/apt/sources.list
RUN apt-get -qy update && apt-get -qy install python python-cheetah unrar \
    unzip python-yenc par2

RUN    useradd sabnzbd -d /sab -m && chown -R sabnzbd:sabnzbd /sab
VOLUME /sab
ADD  . /sabnzbd

EXPOSE 8013
USER   sabnzbd
ENV    HOME /sab

ENTRYPOINT [ "python", "/sabnzbd/SABnzbd.py", "-s", "0.0.0.0:8013" ]


