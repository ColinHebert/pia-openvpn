# Private Internet Access OpenVPN

An Alpine Linux container running OpenVPN via Private Internet Access

Based on [ColinHebert/pia-openvpn](https://hub.docker.com/r/colinhebert/pia-openvpn/)

## Improvements

* Updated to new PIA configs with strong encryption (AES-256-CBC data encryption, RSA-4096 SSL handshake, SHA256 message authentication)
* Updated README

## What is Private Internet Access

Private Internet Access VPN Service encrypts your connection and provides you with an anonymous IP to protect your privacy.

## How to use this image

This image provides the configuration files for each region supported by PIA.

The goal is to start this container first, and then run other containers within the PIA VPN via `--network=container:pia`.

### Starting the client

```Shell
docker run --cap-add=NET_ADMIN --device=/dev/net/tun --name=pia -d \
  --restart=always
  --dns 209.222.18.222 --dns 209.222.18.218 \
  -e 'REGION=<region>' \
  -e 'USERNAME=<pia_username>' \
  -e 'PASSWORD=<pia_password>' \
  act28/pia-openvpn
```

Substitute the environment variables for `REGION`, `USERNAME`, and `PASSWORD` as indicated.

*NOTE 1:* `REGION` is optional. The default region is set to `Switzerland`. `REGION` should match the supported PIA `.opvn` region config. See the [PIA Support page](https://www.privateinternetaccess.com/pages/client-support/#third) for details.

*NOTE 2:* `USERNAME` and `PASSWORD` is also optional. See __Advanced usage__ below, on how to avoid passing credentials via the environment.

Due to the nature of the VPN client, this container must be started with some additional privileges, `--cap-add=NET_ADMIN` and `--device=/dev/net/tun` make sure that the tunnel can be created from within the container.

Starting the container in privileged mode would also achieve this, but keeping the privileges to the minimum required is preferable.

### Creating a container that uses PIA VPN

```Shell
docker run --rm --network=container:pia appropriate/curl -s ifconfig.co
```

The IP address returned after this execution should be different from the IP address you would get without specifying `--net=container:pia`.

## Advanced usage

### Additional arguments for the openvpn client

Every parameter provided to the `docker run` command is directly passed as an argument to the [openvpn executable](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage).

This will run the openvpn client with the `--pull` option:

```Shell
docker run ... --name=pia \
  act28/pia-openvpn \
    --pull
```

### Avoid passing credentials via environment variables

By default this image relies on the variables `USERNAME` and `PASSWORD` to be set in order to successfully connect to the PIA VPN.

You can create your VPN credentials using:

```Shell
echo "<username>\n<password>" > auth.conf
```

And then bind mount the credential file, like so:

```Shell
docker run ... --name=pia \
  -e 'REGION=Switzerland' \
  -v '</path/to/auth.conf>:/run/secrets/auth_conf' \
  act28/pia-openvpn
```

### Connection between containers behind PIA

Any container started with `--network=container:...` will share the same network stack as the PIA container, therefore they will have the same local IP address.

[Prior to Docker 1.9](https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/) `--link=pia:mycontainer` was the recommended way to connect to a specific container.

[Since Docker 1.9](https://docs.docker.com/engine/userguide/networking/dockernetworks/), it is recommended to use a non default network allowing containers to address each other by name.

#### Creating a network

```Shell
docker network create vpn
```

This creates a network called `vpn` in which containers can address each other by name; the `/etc/hosts` is updated automatically for each container added to the network.

#### Start the PIA container in the vpn

```Shell
docker run ... --network=vpn --name=pia act28/pia-openvpn
```

In `vpn` there is now a resolvable name `pia` that points to that newly created container.

#### Create a container behind the PIA VPN

This step is the same as the previous one:

```Shell
# Create a HTTP service that listens on port 80
docker run ... --network=container:pia --name=myservice
```

This container is not addressable by name in `vpn`, but given that the network stack used by `myservice` is the same as the `pia` container, they have the same IP address and the service running in this container will be accessible at `http://pia:80`.

#### Create a container to access the service

```Shell
docker run --rm --network=vpn appropriate/curl -s http://pia/
```

The container is started within the same network as `pia` but is not behind the VPN.

It can access services started behind the VPN container such as the HTTP service provided in the `myservice` example.
