Scripts to launch devstack with the BGPVPN extension, and its bagpipe implementation
====================================================================================

Here is an easy way to use the bgpvpn extension for Openstack/Neutron,
with the bagpipe driver.

We are going to deploy two nodes with devstack that will act as two Openstack
Clouds, and use BGP between those nodes
to create a MPLS tunnel between two Neutron networks.

Prerequisites
-------------

Those prerequisites are valid for the two nodes.

Install OVS 2.4 or later (including the dkms module), by recompiling it :

https://github.com/openvswitch/ovs

Launching devstack on the first node
------------------------------------

Modify local.conf and local.sh :

| ln -s local.conf.bgpvpn.bagpipe.node1 local.conf
| ln -s local.sh.bgpvpn.bagpipe.node1 local.sh

launch devstack :

./stack-bgpvpn.sh

Launching devstack on the second node
-------------------------------------

The main differences between node1 and node2 are :
-subnet used for private networks taht we want to interconnect : no overlap
-The second node doesn't have to lauchn the Fake Route Reflector, but its
bagpipe has to peer with the one we instantiated on the first node

Modify local.conf and local.sh :

| ln -s local.conf.bgpvpn.bagpipe.node2 local.conf
| ln -s local.sh.bgpvpn.bagpipe.node2 local.sh

launch devstack with another subnet :

BAGPIPE_BGP_PEERS="node1_ip" ./stack-bgpvpn.sh

Tests
-----

Those scripts are going to create a probe namespace on each node.
To validate your deployment, use the probe namespace deployed on the first node
to ping the ip of the probe namespace created on the second node.
