# docker-mininet-mac
Mac instructions for using docker for [Mininet](http://mininet.org/)

# Setup Development Environment

Use docker with ssh port for remote dev in an IDE like PyCharm
```sh
# # pull image
# docker pull leonmak/mininet
# # or build
docker build -t mininet .
docker run -it --rm --privileged  \
    -e DISPLAY="`hostname`:0"  \
    -v /tmp/.X11-unix:/tmp/.X11-unix  \
    -v /lib/modules:/lib/modules \
    -p 3022:22 \
    --security-opt seccomp:unconfined \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --name mininet \
    mininet
```

## XTerm
After starting XQuartz, to add local hostname run:
```
xhost + $(hostname)
```

## Remote connection in Pycharm
Go to Tools > Deployment > Configuration.
- Create new SFTP config, set:
	- host `0.0.0.0` 
	- port `3022` (see docker run)
	- username and password to be both `root`
	- set automatic upload to edit in pycharm and upload / let it sync 
- See `Dockerfile` for `sshd` configuration


# Starting POX controller & network

## Run Controller 
- Controller handles switch logic
    - by subscribing to events by switches 
- Copy files into `pox/` folder so that python2.7 will pick up pox
	- Pycharm: Use `upload to mininet`
	- Docker `cp`: `docker cp . mininet:/home/pox`
- In container:
    - `cd` into `pox/`
    - run `pox.py` with `controller.py` in same directory
```
cp controller.py mininetTopo.py policy.in topology.in pox/

./pox.py controller
```

## Start mininet w/ custom topology
In another window, run network with custom topology.
```
# edit IP=0.0.0.0 for remote controller
# python mininetTopo.py 
mn --custom mininetTopo.py --topo main
```
Network instance connects to remote controller, delegates handler logic to it.

# Debug tools
In terminal,
```
mn -c
```

In mininet shell,
```
# check topology
h1 ifconfig

# check PORT_DOWN for spanning tree fixes for looped topo
dpctl dump-ports-desc

# check switch flow tables
dpctl dump-flows

# test firewall tcp blocking
h1 python -m SimpleHTTPServer 80 &
h2 wget -O - h1
```
