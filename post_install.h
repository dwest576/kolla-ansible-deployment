

openstack flavor create --id 0 --ram 512   --vcpus 1 --disk 10  m1.tiny
openstack flavor create --id 1 --ram 1024  --vcpus 1 --disk 20  m1.small
openstack flavor create --id 2 --ram 2048  --vcpus 2 --disk 40  m1.medium
openstack flavor create --id 3 --ram 4096  --vcpus 2 --disk 80  m1.large
openstack flavor create --id 4 --ram 8192  --vcpus 4 --disk 160 m1.xlarge
openstack flavor create --id 5 --ram 16384 --vcpus 6 --disk 320 m1.jumbo
openstack flavor create --id 6 --ram 32768  --vcpus 8 --disk 250 m1.infra




wget https://download.cirros-cloud.net/0.6.2/cirros-0.6.2-x86_64-disk.img
openstack image create \
    --container-format bare \
    --disk-format qcow2 \
    --file cirros-0.6.2-x86_64-disk.img \
    CirrOS-6.2
