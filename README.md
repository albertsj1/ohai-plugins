# Ohai Plugins for Chef #

This repository contains plugins I have written for use with Ohai and Chef

## Plugins ##

**vserver.rb**

Provides additional information for [Linux VServer](http://linux-vserver.org) hosts.
This plugin provides information such as: versions, configuration dirs, running guests, guest details, cgroup usage, etc.

**Example:**

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

