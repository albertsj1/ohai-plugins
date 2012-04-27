# Ohai Plugins for Chef #

This repository contains plugins I have written for use with Ohai and Chef

## Plugins ##

**vserver.rb**

Provides additional information for [Linux VServer](http://linux-vserver.org) hosts.
This plugin provides information such as: versions, configuration dirs, running guests, guest details, cgroup usage, etc.

**Example:**

    "virtualization": {
      "system": "linux-vserver",
      "role": "host",
      "vserver": {
        "apiversion": "0x00020306",
        "config_dir": "/etc/vservers",
        "root_dir": "/vservers",
        "running_guests": [
          "guest1",
          "guest2"
        ],
        "guests": {
          "guest1": {
            "config_dir": "/etc/vservers/guest1",
            "status": "running",
            "ctx": "40000",
            "running_processes": "473",
            "vsz": "143.9G",
            "rss": "15.9G",
            "usertime": "6d01h28",
            "systime": "7d12h24",
            "uptime": "213d04h55",
            "cgroup": {
              "ram": "16777216kB",
              "swap": "33554432kB"
            }
          },
          "guest2": {
            "config_dir": "/etc/vservers/guest2",
            "status": "running",
            "ctx": "40001",
            "running_processes": "242",
            "vsz": "119.4G",
            "rss": "11.8G",
            "usertime": "8d18h24",
            "systime": "5d22h18",
            "uptime": "168d11h24",
            "cgroup": {
              "ram": "16777216kB",
              "swap": "33554432kB"
            }
          }
        },
        "guest_ram_total": "33554432kB",
        "guest_swap_total": "67108864kB",
        "guest_cpuset_total": "0-7,8-15"
      }

**kvm_extensions.rb**

Provides additional information for [KVM](http://linux-kvm.org) hosts similiar to my VServer Ohai plugin.

**Example:**

    "virtualization": {
      "system": "kvm",
      "role": "host",
      "kvm": {
        "guests": {
          "dc02vg0226na": {
            "id": "1",
            "state": "running",
            "Name": "dc02vg0226na",
            "UUID": "ee29f7d2-fe39-1468-01a7-bb4b3adbab1f",
            "OS Type": "hvm",
            "State": "running",
            "CPU(s)": "4",
            "CPU time": "47243.5s",
            "Max memory": "8388608 kB",
            "Used memory": "8388608 kB",
            "Persistent": "yes",
            "Autostart": "enable"
          },
          "dc02vg0108na": {
            "id": "2",
            "state": "running",
            "Name": "dc02vg0108na",
            "UUID": "136a0510-d3f3-6b0a-23e9-2e7b37592a16",
            "OS Type": "hvm",
            "State": "running",
            "CPU(s)": "4",
            "CPU time": "123711.2s",
            "Max memory": "8388608 kB",
            "Used memory": "8388608 kB",
            "Persistent": "yes",
            "Autostart": "enable"
          },
          "dc02vg0228na": {
            "id": "3",
            "state": "running",
            "Name": "dc02vg0228na",
            "UUID": "42537746-e7f5-64f9-58eb-afd33940c036",
            "OS Type": "hvm",
            "State": "running",
            "CPU(s)": "4",
            "CPU time": "56315.5s",
            "Max memory": "8388608 kB",
            "Used memory": "8388608 kB",
            "Persistent": "yes",
            "Autostart": "enable"
          }
        },
        "guest_maxmemory_total": "25165824 kB",
        "guest_usedmemory_total": "25165824 kB"
      }
