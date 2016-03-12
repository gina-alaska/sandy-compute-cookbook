module SandyCompute
  module Helpers
    def libvirt_pool_exists?(pool_name)
      cmd = shell_out!("virsh pool-list --all")
      pools = cmd.stdout.split('\n')
      cmd.stderr.empty? && (pools.select{|line| line =~ /^#{pool_name}/}.any?)
    end

    def vg_exists?(vg_name)
      cmd = shell_out("vgdisplay #{vg_name}")
      cmd.status == 0
    end
  end
end

Chef::Resource::Bash.send(:include, ::SandyCompute::Helpers)
Chef::Resource::LvmLogicalVolume.send(:include, ::SandyCompute::Helpers)
Chef::Provider::LvmLogicalVolume.send(:include, ::SandyCompute::Helpers)
