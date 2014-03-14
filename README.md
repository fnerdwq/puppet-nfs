#puppet-nfs

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What nfs affects](#what-nfs-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nfs](#beginning-with-nfs)
4. [Usage](#usage)
5. [Limitations](#limitations)
6. [TODOs](#todos)

##Overview

This small nfs module installs and configures nfs clients and/or server.
It handles nfs mounts and nfs exports as well.

Working for NFSv4 so far.
Written for Puppet >= 3.4.0.

##Module Description

See [Overview](#overview) for now.

##Setup

###What nfs affects

* Installs nfs server/client.
* Manages the services.
* Can fix ports and update /etc/services.

###Setup Requirements

Sensfull parameters should be given.
	
###Beginning with nfs	

Simply include it to make nfs mounting possible. You can specify a hash for
nfs::mounts.
If the server shoudl be installed es well, set nfs::install\_server=true.
Then exports can be added by supplying a hash for nfs::exports.

##Usage

Just include the module by 
```puppet
include nfs
```
and supply sensfull parameters in hiera (see init.pp).

The nfs server can be installed by:
```puppet
class { 'nfs':
  install_server => true
}
```
By default the nfs server ports (v4) are fixed to the range 2049, 32764-32769.

To specify exports:
```yaml
nfs::exports:
  /export/mnt:
    hosts:
      - firsthost(rw,sync,no_subtree_check)
      - secondhost(rw,sync,no_subtree_check)
  /export/stuff:
    ensure: absent
```

To specify mounts:
```yaml
nfs::mounts:
  /mnt:
    device: nfsserver:/export/mnt
    options: vers=3,tcp
  /mnt2:
    ...
```

##Limitations:

Tested only on 
* Debian 7 and NFSv3
so far.

Puppet Version >= 3.4.0, due to specific hiera/*contain* usage.

##TODOs:

* Make it work on RedHat like systems.
* Add quota support
* Add hosts.allow/deny handling
* Make usefull for NFSv4
* ... suggestions? Open an issue on github...
