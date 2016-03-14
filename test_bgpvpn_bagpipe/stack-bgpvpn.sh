#!/bin/bash

sudo ovs-vsctl del-br br-mpls
sudo ovs-vsctl add-br br-mpls

#sudo service bagpipe-fakerr restart
#sudo service bagpipe-bgp restart

#OFFLINE=True ./stack.sh
RECLONE=True ./stack.sh
