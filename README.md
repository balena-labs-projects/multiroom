# multiroom block

This block provides an easy way to set up multiroom audio for your fleet of devices by using a pre-configured instance of [Snapcast](https://github.com/badaix/snapcast) audio player. Use it in conjunction with the [audio block](https://github.com/balena-labs-projects/audio) for the best experience.


## Features

- Runs snapcast audio player (binaries for both server and client versions available)
- Pre-configured to work with balena [audio block](https://github.com/balena-labs-projects/audio)

## Usage

#### Prebuilt images

We maintain images for this block on balenaHub Container Registry. The images can be accessed using:

`bh.cr/g_tomas_migone1/multiroom-<arch>` or `bhcr.io/g_tomas_migone1/multiroom-<arch>` where `<arch>` is one of: `rpi`, `armv7hf`, `aarch64` or `amd64`.

For details on how to select a specific version or commit version of the image see our [documentation](https://github.com/balena-io/open-balena-registry-proxy/#usage).

### Server mode
To use in server mode, create a container in your `docker-compose.yml` file as shown below:

```yaml
version: '2'

services:

  server:
    image: bh.cr/g_tomas_migone1/multiroom-<arch> # where <arch> is one of rpi, armv7hf, aarch64 or amd64
    command: /usr/bin/snapserver
    ports:
      - 1704:1704
      - 1705:1705
      - 1780:1780
```
### Client mode
To use in client mode, create a container in your `docker-compose.yml` file as shown below:

```yaml
version: '2'

services:
  client:
    image: bh.cr/g_tomas_migone1/multiroom-<arch> # where <arch> is one of rpi, armv7hf, aarch64 or amd64
    command: [ "/usr/bin/snapclient", "--host", "<MULTIROOM_SERVER>" ]  # "<MULTIROOM_SERVER>" is your multiroom server hostname or IP address
```


## Customization
### Extend image configuration

You can extend the `multiroom` block to include custom configuration as you would with any other `Dockerfile`. Just make sure you don't override the `ENTRYPOINT` as it contains important system configuration.

Here are some of the most common extension cases: 

- Pass a flag to the multiroom server (this won't work for client!):

```Dockerfile
FROM bh.cr/g_tomas_migone1/multiroom-aarch64

CMD [ "--datadir=/var/cache/snapcast" ]
```

- Start multiroom (client or server) from your own bash script:

```Dockerfile
FROM bh.cr/g_tomas_migone1/multiroom-aarch64

COPY start.sh /usr/src/start.sh
CMD [ "/bin/bash", "/usr/src/start.sh" ]
```

## Supported device architectures
The multiroom block has been tested to work on the following device architectures:

- ARM v6 (`rpi`)
- ARM v7 (`armv7hf`)
- ARM v8 (`aarch64`)
- x86_64 (`amd64`)
