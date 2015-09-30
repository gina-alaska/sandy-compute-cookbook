#
# Cookbook Name:: sandy-compute
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
Chef::Resource::Bash.send(:include, ::SandyCompute::Helpers)

# Libvirt packages
%w(libvirt qemu-kvm qemu-kvm-tools).each do |pkg|
  package pkg do
    action :install
  end
end

# virt-manager packages
%w(virt-manager xorg-x11-xauth dejavu-lgc-sans-fonts).each do |pkg|
  package pkg do
    action :install
  end
end

service 'libvirtd' do
  action [:enable, :start]
end

node.default['glusterfs']['client']['version'] = 3.6
node.default['glusterfs']['yum']['baseurl'] = "http://download.gluster.org/pub/gluster/glusterfs/3.6/LATEST/EPEL.repo/epel-$releasever/$basearch/"
include_recipe 'gina-gluster::client'

directory '/var/lib/libvirt/images' do
  action :create
  owner 'qemu'
  group 'qemu'
  recursive true
end

include_recipe "xfs"
include_recipe "lvm"

lvm_logical_volume 'lv_libvirt_images' do
  group 'system'
  size '500G'
  filesystem 'xfs'
end

node['sandy']['libvirt']['pools'].each do |pool, attrs|
  directory "create-directory-for-#{pool}" do
    path attrs['local_path']
    action :create
    owner 'qemu'
    group 'qemu'
    recursive true
    not_if { attrs['local_path'].nil? }
  end

  template "#{Chef::Config[:file_cache_path]}/template-#{pool}.xml" do
    source "#{attrs['type']}.xml.erb"
    variables({ name: pool, opts: attrs })
  end

  bash "create-pool-#{pool}" do
    code <<-EOH
      virsh pool-define #{Chef::Config[:file_cache_path]}/template-#{pool}.xml
      virsh pool-autostart #{pool}
      virsh pool-start #{pool}
    EOH
    not_if { libvirt_pool_exists?(pool) }
  end
end
