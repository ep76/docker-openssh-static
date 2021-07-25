# docker-openssh-static

> A Docker image for [OpenSSH](https://www.openssh.com),
> statically compiled with `musl`

[![CI](https://github.com/ep76/docker-openssh-static/actions/workflows/ci.yml/badge.svg?branch=main)](
  https://github.com/ep76/docker-openssh-static/actions/workflows/ci.yml
)
[![DockerHub](https://img.shields.io/docker/v/ep76/openssh-static/latest)](
  https://hub.docker.com/r/ep76/openssh-static/tags?page=1&ordering=last_updated
)

## Usage

### In shell

Start `sshd` service:

```shell
$ docker run -d --read-only \
    -p 2222:22 -v /path/to/ssh/confs:/etc/ssh:ro \
    ep76/openssh-static:latest
```

Run a command:

```shell
$ docker run --rm --entrypoint=ssh ep76/openssh-static:latest -V
# <version string>
```

### In Dockerfile

```Dockerfile
COPY --from=ep76/openssh-static:latest /usr /usr
```

## License

[MIT](./LICENSE)
