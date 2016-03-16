#Scripts to launch devstack with the BGPVPN extension, and its bagpipe implementation

Here is an easy way to use the bgpvpn extension for Openstack/Neutron,
with the bagpipe driver.

We are going to deploy two nodes with devstack that will act as two Openstack
Clouds, and use BGP between those nodes
to create a MPLS tunnel between two Neutron networks.

##Prerequisites

As a prerequisites, you have to install [OVS](#https://github.com/openvswitch/ovs) 2.4 or later (including the dkms module), by recompiling it.
You can also use the deb packages provided in the deb/ directory.

##Launching devstack on the first node

Modify local.conf :

```
ln -s local.conf.bgpvpn.bagpipe local.conf
```

Copy the stack-bgpvpn-bagpipe.sh script and the stack.yaml HOT template in your devstack directory and execute :

```
BAGPIPE_BGP_PEERS=your-ip FAKERR=True CIDR=10.0.0.0/24 ./stack-bgpvpn-bagpipe.sh
```

This will launch devstack with keystone, heat, neutron and bagpipe with its fake route reflector.
It will also deploy a heat stack that creates the bgpvpn and the network attached to it.
Finally, it creates a namespace with a port in the created network.

##Launching devstack on the second node

Do the same as on first node except that you'll pass different env variables to stack-bgpvpn-bagpipe.sh : 

```
BAGPIPE_BGP_PEERS=first_node_ip CIDR=20.0.0.0/24 ./stack-bgpvpn-bagpipe.sh
```

You'll have the same result as on first node, except that bagpipe will peer with the route reflector started on the first node.

##Tests

Probe namespaces have been created on each node.
To validate your deployment, use the probe namespace deployed on the first node
to ping the ip of the probe namespace created on the second node.

```
sudo ip netns exec qprobe-portid ping 20.0.0.3
```
