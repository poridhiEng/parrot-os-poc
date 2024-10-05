ignite run \
    sagoresarker/parrotos-novnc:3.0.0 \
    --name parrotos-novnc-vm \
    --kernel-image weaveworks/ignite-kernel:5.10.51 \
    --memory 2GB \
    --cpus 2 \
    --ssh \
    --ports 80:80 \
    --ports 5901:5901 \
    --network-plugin=cni
