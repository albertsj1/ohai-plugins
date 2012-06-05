# Author: John Alberts
#
# Plugin to give more information about the kvm host and guest

provides 'virtualization/kvm'
require_plugin 'virtualization'
if not virtualization.nil? and virtualization[:system] == 'kvm'
  if virtualization[:role] == 'host'
    guest_maxmemory_total=0
    guest_usedmemory_total=0
    guest_cpu_total=0
    virtualization[:kvm] = Mash.new unless virtualization[:kvm]
    virtualization[:kvm][:guests] = Mash.new unless virtualization[:kvm][:guests]
    %x{virsh list --all | grep -vP '\S*Id|^-|^$'}.each_line do |g|
      id, name, state = g.split
      virtualization[:kvm][:guests][name] = Mash.new
      virtualization[:kvm][:guests][name][:id] = id.strip
      virtualization[:kvm][:guests][name][:state] = state.strip
      # Let's parse dominfo for more guest information
      if "#{id}" == "-"
        domains = %x{virsh dominfo #{name} | grep -v 'Id:'}
      else
        domains = %x{virsh dominfo #{id} | grep -v 'Id:'}
      end
       domains.each_line do |l|
        k, v = l.split(":")
        virtualization[:kvm][:guests][name][k.strip] = v.strip unless v.nil?
        case k.strip
        when 'CPU(s)'
          guest_cpu_total += v.strip.to_i
        when 'Max memory'
          guest_maxmemory_total += v.strip.to_i
        when 'Used memory'
          guest_usedmemory_total += v.strip.to_i
        end
      end
      virtualization[:kvm][:guest_maxmemory_total] = guest_maxmemory_total.to_s + " kB"
      virtualization[:kvm][:guest_usedmemory_total] = guest_usedmemory_total.to_s + " kB"
    end
  elsif virtualization[:role] == 'guest'


  end
end
