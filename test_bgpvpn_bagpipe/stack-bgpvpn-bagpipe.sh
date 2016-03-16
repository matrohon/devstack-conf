#!/bin/bash

sudo ovs-vsctl del-br br-mpls
sudo ovs-vsctl add-br br-mpls

./stack.sh

source openrc admin demo

STACK_NAME=bgpvpn

heat stack-create -f stack.yaml -P cidr=$CIDR $STACK_NAME
sleep 5

NET_ID=$(neutron net-list | grep $STACK_NAME | awk '{print $2}')
SUBNET_ID=$(neutron subnet-list | grep $STACK_NAME | awk '{print $2}')
GW=$(neutron subnet-show $SUBNET_ID |grep gateway | awk '{print $4}')

neutron-debug --config-file /etc/neutron/l3_agent.ini probe-create $NET_ID
PROBE_PORT_ID=$(neutron port-list -- --device-owner=network:probe --network-id=$NET_ID | grep ip_address | awk '{print $2}')

sudo ip netns exec qprobe-$PROBE_PORT_ID ip r add default via $GW
