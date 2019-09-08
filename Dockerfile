FROM alpine:3.10

# Install basic components.
# Unlock automatically created user.
RUN set -x \
 && apk add --no-cache gitolite openssh \
 && passwd -u git

# Volume used to stroe SSH host keys.
# Generated if not provided.
VOLUME /etc/ssh/keys

# Volume used to store all Gitolite data (keys, config, and repositories).
# Initialized on first run.
VOLUME /var/lib/git

### TODO Set very restrictive SSHD settings.
COPY sshd_config /etc/sshd/sshd_config

#### executes logic if symlinks/setups have to be created/executed
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# use SSH default port
EXPOSE 22

# gets forwared to the docker-entrypoint script
CMD ["/usr/sbin/sshd", "-D"]
