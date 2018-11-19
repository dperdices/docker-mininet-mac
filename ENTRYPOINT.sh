#!/usr/bin/env bash

service openvswitch-switch start
ovs-vsctl set-manager ptcp:6640s

/usr/sbin/sshd

bash

service openvswitch-switch stop
