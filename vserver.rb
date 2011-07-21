provides "linux/vserver"
require_plugin "virtualization"
if virtualization[:system] == "linux-vserver"
  virtualization[:vserver] = Mash.new
  vserver_info = from("vserver-info - SYSINFO")
  vserver_stat = from("vserver-stat")
  api = vserver_info.match(/VS-API: (.*)$/)[1].to_s
  config_dir = vserver_info.match(/cfg-Directory: (.*)$/)[1].to_s
  root_dir = vserver_info.match(/vserver-Rootdir: (.*)$/)[1].to_s
  guest_ram_total = 0
  guest_swap_total = 0
  guest_cpuset_total = []


  virtualization[:vserver][:apiversion] = api
  virtualization[:vserver][:config_dir] = config_dir
  virtualization[:vserver][:root_dir] = root_dir
  virtualization[:vserver][:running_guests] = %x{grep NodeName /proc/virtual/*/nsproxy | awk '{print $2}'}.split

  virtualization[:vserver][:guests] = Mash.new
  if Dir["#{config_dir}/*/vdir"].each
    Dir["#{config_dir}/*/vdir"].each do |thisdir|
      guestdir = File.basename(thisdir.gsub(/\/vdir/,""))
      guestname = from("cat #{config_dir}/#{guestdir}/name").gsub("\n","")
      virtualization[:vserver][:guests][guestname] = Mash.new
      virtualization[:vserver][:guests][guestname][:config_dir] = "#{config_dir}/#{guestdir}"

      # Guest Status information
      if vserver_stat.match(/^(.*#{guestname}.*$)/)
        this_vserver_stat = vserver_stat.match(/^(.*#{guestname}.*$)/)[1].to_s.split
      else
        this_vserver_stat = ""
      end
      if this_vserver_stat.empty?
        virtualization[:vserver][:guests][guestname][:status] = "stopped"
      else
        virtualization[:vserver][:guests][guestname][:status] = "running"
        virtualization[:vserver][:guests][guestname][:ctx] = this_vserver_stat[0]
        virtualization[:vserver][:guests][guestname][:running_processes] = this_vserver_stat[1]
        virtualization[:vserver][:guests][guestname][:vsz] = this_vserver_stat[2]
        virtualization[:vserver][:guests][guestname][:rss] = this_vserver_stat[3]
        virtualization[:vserver][:guests][guestname][:usertime] = this_vserver_stat[4]
        virtualization[:vserver][:guests][guestname][:systime] = this_vserver_stat[5]
        virtualization[:vserver][:guests][guestname][:uptime] = this_vserver_stat[6]
      end

      # Guest Cgroup information
      tempnum = "20"
      virtualization[:vserver][:guests][guestname][:cgroup] = Mash.new
      { "cpuset.cpus" => "cpuset",
  "memory.limit_in_bytes" => "ram",
        "memory.memsw.limit_in_bytes" => "swap"
      }.each do |limit,limit_name|
        if File.exist?("#{config_dir}/#{guestdir}/cgroup/#{limit}")
          thislimit = from("cat #{config_dir}/#{guestdir}/cgroup/#{limit}").gsub("\n","")
          case limit_name
          when "cpuset"
            guest_cpuset_total.push(thislimit)
          else
            case thislimit.match(/([0-9]*)([KMG]?)/)[2].to_s
            when ""
              thislimit_inkb = "#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i / 1024}"
              eval("guest_#{limit_name}_total += (#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i} / 1024)")
            when "K"
              thislimit_inkb = "#{thislimit.match(/([0-9]*)([KMG]?)/)[1]}"
              eval("guest_#{limit_name}_total += #{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i}")
            when "M"
              thislimit_inkb = "#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i * 1024}"
              eval("guest_#{limit_name}_total += (#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i} * 1024)")
            when "G"
              thislimit_inkb = "#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i * 1048576}"
              eval("guest_#{limit_name}_total += (#{thislimit.match(/([0-9]*)([KMG]?)/)[1].to_i} * 1048576)")
            end
            virtualization[:vserver][:guests][guestname][:cgroup][limit_name] = "#{thislimit_inkb}kB"
          end
        else
          virtualization[:vserver][:guests][guestname][:cgroup][limit_name] = "none"
        end

      end
      virtualization[:vserver][:guest_ram_total] = "#{guest_ram_total}kB"
      virtualization[:vserver][:guest_swap_total] = "#{guest_swap_total}kB"
      virtualization[:vserver][:guest_cpuset_total] = guest_cpuset_total.join(",")
    end
  end

end

