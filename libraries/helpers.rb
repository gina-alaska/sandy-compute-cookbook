module SandyCompute
  module Helpers
    def libvirt_pool_exists?(pool_name)
      cmd = shell_out!("virsh pool-list --all")
      pools = cmd.stdout.split('\n')
      cmd.stderr.empty? && (pools.select{|line| line =~ /^#{pool_name}/}.any?)
    end
  end
end
