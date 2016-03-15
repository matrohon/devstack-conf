#!/bin/bash

sudo ovs-vsctl del-br br-mpls
sudo ovs-vsctl add-br br-mpls

./stack.sh

source openrc admin demo

nova keypair-add heat_key > /tmp/heat_key.priv
heat stack-create -f stack.yaml -P key_name=heat_key bgpvpn
