#!/bin/sh

# hardening - enforce exact usage
if [[ "${1}" != '/usr/sbin/sshd' ]] || [[ "${2}" != '-D' ]] || [[ "${#}" -ne 2 ]]; then
  echo 'docker-entrypoint.sh NOT called with /usr/sbin/sshd -D'
  exit 1
fi

# generate SSH HostKeys if not provided
# and append them to sshd_config if not already added
for algorithm in dsa ecdsa ed25519 rsa
do
  keyfile="/etc/ssh/keys/ssh_host_${algorithm}_key"
  [[ -f ${keyfile} ]] || ssh-keygen -q -N '' -f ${keyfile} -t ${algorithm}
  grep -q "HostKey ${keyfile}" /etc/ssh/sshd_config || echo "HostKey ${keyfile}" >> /etc/ssh/sshd_config
done

# Also initializes mounted volume
chown -R git:git /var/lib/git

# setup git user
if [[ ! -f '/var/lib/git/.ssh/authorized_keys' ]]; then
  if [[ -z ${GIT_PUBLICKEY+x} ]]; then
    echo 'Can NOT setup gitolite with public key, cause ${GIT_PUBLICKEY} is not set!'
    exit 2
  else
    echo ${GIT_PUBLICKEY} > '/tmp/git_key.pub'
    su - git -c "gitolite setup -pk '/tmp/git_key.pub'"
    rm '/tmp/git_key.pub'
  fi
else
  su - git -c "gitolite setup"
fi

# execute CMD from Dockerfile
exec "${@}"
