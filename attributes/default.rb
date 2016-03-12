default['sandy']['libvirt']['pools'] = {
  'scratch' => {
    'type' => 'logical',
    'source_name' => 'vg_scratch',
    'source_path' => '/dev/vg_scratch'
  },
  'local-os' => {
    'type' => 'fs',
    'source_path' => '/dev/mapper/system-lv_libvirt_images',
    'local_path' => '/var/lib/libvirt/images/local-os',
    'format' => 'xfs'
  }
}
