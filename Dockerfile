FROM debian

MAINTAINER kerwindena

## Install all the Packages

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    ssh \
    weechat \
    weechat-plugins \
    weechat-scripts \
    locales \
    tmux \
    tor

# Install english language
RUN sed -ir 's/^(# )?(en_US.+)( UTF-8)$/\2\3/' /etc/locale.gen \
 && locale-gen

## Configure the container

# Fix sshd for priviliege separation
RUN mkdir /var/run/sshd \
 && chmod 700 /var/run

# Configure ssh
ADD sshd_config /etc/ssh/

# Create /data
RUN mkdir /data

# Configure Weechat
RUN useradd -m -d /home/weechat -s /home/weechat/login.sh weechat \
 && usermod -p '*' weechat

# Add tor user
RUN useradd --create-home tor

# Add files not to be changed by the end user
ADD login.sh /home/weechat/
ADD config.txt /home/weechat/

# Add startup script
ADD startup.sh /usr/sbin/

## Populate the volume

# Add authorized_keys placeholder
RUN mkdir /home/weechat/.ssh \
 && touch /data/authorized_keys \
 && ln -s /data/authorized_keys /home/weechat/.ssh/

# Configure Tmux
ADD tmux.conf /data/
RUN ln -s /data/tmux.conf /home/weechat/.tmux.conf

# Make Weechat configuration persistent
RUN mkdir /data/weechat \
 && chown -R weechat:weechat /data/weechat \
 && ln -s /data/weechat /home/weechat/.weechat

## Final steps

# Add Volume under /data
VOLUME ["/data"]

# Expose port 22
EXPOSE 22

# Startup preocedure
CMD ["/bin/sh", "/usr/sbin/startup.sh"]
