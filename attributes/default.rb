default['sandy']['libvirt']['pools'] = {
  'gluster-vm-pool' => {
    'local_path' => '/var/lib/libvirt/images/gluster-vm-pool',
    'host' => 'pod6.gina.alaska.edu',
    'host_path' => 'gvolSandyVm',
    'type' => 'glusterfs'
  },
  'scratch' => {
    'type' => 'logical',
    'source_name' => 'vg_scratch',
    'source_path' => '/dev/vg_scratch'
  }
}