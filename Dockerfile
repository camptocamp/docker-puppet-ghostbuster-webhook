FROM jmcarbo/webhook

EXPOSE 9000

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV IRC_NOTIFY_BRANCHES production

ENV GHOSTBUSTER_VERSION 0.7.3

RUN apt-get update \
  && apt-get install -y locales-all ruby \
  && rm -rf /var/lib/apt/lists/*

RUN gem install puppet-ghostbuster --no-ri --no-rdoc --version "${GHOSTBUSTER_VERSION}"

COPY puppet-ghostbuster.json /etc/webhook/puppet-ghostbuster.json
COPY puppet-ghostbuster.sh /puppet-ghostbuster.sh

# Configure .ssh directory
RUN mkdir /root/.ssh \
  && chmod 0600 /root/.ssh \
  && echo StrictHostKeyChecking no > /root/.ssh/config

VOLUME ["/var/lib/git/"]

COPY /docker-entrypoint.sh /
COPY /gh-create-issues /usr/local/bin/
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]
