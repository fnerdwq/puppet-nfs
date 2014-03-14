# configure the nfs-kernel-server package (private)
class nfs::server::config {

  # /etc/default/nfs-kernel-server
  if str2bool($nfs::svcgssd_start) {
    $need_svcgssd = 'yes'
  } else {
    $need_svcgssd = 'no'
  }

  $fixed_ports = $nfs::fixed_ports
  $mountd_port = "--port ${nfs::mountd_port}"
  if $nfs::disable_version {
    $no_nfs_version = "--no-nfs-version ${nfs::disable_version}"
  }
  file {'/etc/default/nfs-kernel-server':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nfs/nfs-kernel-server.erb'),
  }

  # configure nfsd_callback_port
  if str2bool($nfs::fixed_ports) {
    $ensure_modprobe = present
  } else {
    $ensure_modprobe = absent
  }
  file {'/etc/modprobe.d/nfs.conf':
    ensure  => $ensure_modprobe,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "# Managed by pupppet.
options nfs callback_tcpport=${nfs::nfsd_callback_port}
"
  }

  # set /etc/services entries
  if $fixed_ports {
    nfs::set_service {'rpc.mountd: tcp':
      service_name => 'rpc.mountd',
      port         => $nfs::mountd_port,
      protocol     => 'tcp',
      comment      => 'RPC mountd'
    }
    nfs::set_service {'rpc.mountd: udp':
      service_name => 'rpc.mountd',
      port         => $nfs::mountd_port,
      protocol     => 'udp',
      comment      => 'RPC mountd'
    }

    nfs::set_service {'rpc.nfs-cb: tcp':
      service_name => 'rpc.nfs-cb',
      port         => $nfs::nfsd_callback_port,
      protocol     => 'tcp',
      comment      => 'RPC nfs callback'
    }
    nfs::set_service {'rpc.nfs-cb: udp':
      service_name => 'rpc.nfs-cb',
      port         => $nfs::nfsd_callback_port,
      protocol     => 'udp',
      comment      => 'RPC nfs callback'
    }
  }


  # TODO quota: defeault fixed Port
  # rpc.quotad      32769/tcp                       # RPC quotad
  # rpc.quotad      32769/udp                       # RPC quotad

}
