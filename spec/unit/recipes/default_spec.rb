#
# Cookbook Name:: sandy-compute
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'sandy-compute::default' do
  context 'When all attributes are default, on Centos 6.5' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '6.5'
      )
      runner.converge(described_recipe)
    end
    before { allow_any_instance_of(Chef::Resource::Bash).to receive(:libvirt_pool_exists?).and_return(true) }

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs libvirt' do
      expect(chef_run).to install_package('libvirt')
      expect(chef_run).to install_package('qemu-kvm')
      expect(chef_run).to install_package('qemu-kvm-tools')
      expect(chef_run).to install_package('virt-manager')
    end

    it 'enables and starts libvirtd' do
      expect(chef_run).to enable_service('libvirtd')
      expect(chef_run).to start_service('libvirtd')
    end

    it 'includes gina-gluster::client' do
      expect(chef_run).to include_recipe('gina-gluster::client')
    end

    it 'creates local libvirt space' do
      expect(chef_run).to include_recipe 'xfs::default'
      expect(chef_run).to include_recipe 'lvm::default'

      expect(chef_run).to create_lvm_logical_volume('lv_libvirt_images').with({
        group: 'system',
        size: '500G',
        filesystem: 'xfs'
      })
    end

    context 'storage pools exist' do
      before { allow_any_instance_of(Chef::Resource::Bash).to receive(:libvirt_pool_exists?).and_return(true) }

      it 'creates the gluster-vm-pool storage pool' do
        expect(chef_run).to_not run_bash('create-pool-gluster-vm-pool')
      end

      it 'creates the scratch storage pool' do
        expect(chef_run).to_not run_bash('create-pool-scratch')
      end
    end

    context 'storage pools dont exist' do
      before { allow_any_instance_of(Chef::Resource::Bash).to receive(:libvirt_pool_exists?).and_return(false) }

      it 'creates the gluster-vm-pool storage pool' do
        expect(chef_run).to run_bash('create-pool-gluster-vm-pool')
      end

      it 'creates the scratch storage pool' do
        expect(chef_run).to run_bash('create-pool-scratch')
      end
    end
    # it 'configures storage pools' do
    #   expect(chef_run).
    # end
  end
end
