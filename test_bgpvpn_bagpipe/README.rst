Scripts to launch devstack with the BGPVPN extension, and its bagpipe implementation
====================================================================================

Here is an easy way to use the bgpvpn extension for Openstack/Neutron,
with the bagpipe driver.

We are going to deploy two nodes with devstack, and use BGP between those nodes
to create a MPLS tunnel between two Neutron networks.

Prerequisites
-------------

Those prerequisites are valid for the two nodes.

Install OVS Trunk (including the dkms module), by recompiling it :

https://github.com/openvswitch/ovs

Install bagpipe by cloning and installing it :

https://github.com/Orange-OpenSource/bagpipe-bgp

create a br-mpls bridge
modify the following default parameters in bgp.conf :

| local_address=YOUR_IP
| dataplane_driver=mpls_ovs_dataplane.MPLSOVSDataplaneDriver
| ovs_bridge=br-mpls


Launching devstack on the first node
------------------------------------

Modify local.conf and local.sh :

| ln -s local.conf.bgpvpn.neutron-only local.conf
| ln -s local.sh.bgpvpn local.sh


launch devstack with a subnet to create :

FIXED_RANGE=10.0.0.0/24 NETWORK_GATEWAY=10.0.0.1 ./stack-bgpvpn.sh

Launching devstack on the second node
-------------------------------------

Prerequisites are the same as the first node.
Configure bagpipe to peer with the first node, in bgp.conf :

peers=FIRST_NODE_IP

Modify local.conf and local.sh :

| ln -s local.conf.bgpvpn.neutron-only local.conf
| ln -s local.sh.bgpvpn local.sh


launch devstack with another subnet :

FIXED_RANGE=10.1.0.0/24 NETWORK_GATEWAY=10.1.0.1 ./stack-bgpvpn.sh

Tests
-----

Those scripts are going to create a probe namespace on each node.
To validate your deployment, use the probe namespace deployed on the first node
to ping the ip of the probe namespace created on the second node.
