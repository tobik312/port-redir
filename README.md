# Port-redir
Minimal docker image with TCP/UDP port redirector, to work along with dockerized VPN client.

Feel free to contribute and give suggestions ;)

### Configuration
Image uses [redir](https://github.com/troglobit/redir "redir") and [uredir](https://github.com/troglobit/uredir "uredir") to redirect traffic between interfaces. 

Config file stores information about `src`, `dst` and port type (tcp/udp). Interface syntax is equivalent to redir/uredir commandline interface [syntax](https://github.com/troglobit/redir#usage "cmd syntax").

**Example config:**
```
#src; dst; tcp/udp
:8080; 192.168.1:80; tcp
127.0.0.1:4433; 192.168.1:433; tcp
:6969; 192.168.2:69; udp
```

To comment/disable line use `#` char in the beginning of the line.

### Usage
Run image with `network_mode` on container/service with VPN client

```yaml
#docker-compose.yml
version: '3'

services:
  vpn-client:
    ...
  ports:
    - '80:8080'

  port-redir:
    image: port-redir:latest
    network_mode: service:vpn-client
    #Map our config file
    volumes:
      - './my-ports-config:/port-redir/ports'
```

Apply configuration file ex.:
```
#my-ports-config
:8080; ipInsideVpn:80; tcp
```

Now you can get direct access to services via your VPN on docker host machine.
