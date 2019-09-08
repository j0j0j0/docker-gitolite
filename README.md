# Docker image for Gitolite

This image allows you to run a git server in a container with OpenSSH and [Gitolite](https://github.com/sitaramc/gitolite#readme).

Based on Alpine Linux.

## Quick setup

Adapt docker compose:

* Add your SSH public key into GIT_PUBLICKEY.
* Adapt your port: default=50122
* Adapt your volumes: default location within this git!

Start via docker-compose:

```bash
# start
docker-compose up --build --detach

# stop
docker-compose down
```

You can then add users and repos by following the [official guide](https://github.com/sitaramc/gitolite#adding-users-and-repos).
