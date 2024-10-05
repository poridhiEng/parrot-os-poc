ignite run \
    sagoresarker/parrotos-novnc:3.0.2 \
    --name parrotos-novnc-vm1 \
    --kernel-image weaveworks/ignite-kernel:5.10.51 \
    --memory 2GB \
    --cpus 2 \
    --network-plugin=cni