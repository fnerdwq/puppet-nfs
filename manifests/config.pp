# configure the nfs-common package (private)
class nfs::config {

  # /etc/default/nfs-common
  if str2bool($nfs::statd_start) {
    $need_statd = 'yes'
  } else {
    $need_statd = 'no'
  }
  if str2bool($nfs::idmapd_start) {
    $need_idmapd = 'yes'
  } else {
    $need_idmapd = 'no'
  }
  if str2bool($nfs::gssd_start) {
    $need_gssd = 'yes'
  } else {
    $need_gssd = 'no'
  }

  $fixed_ports         = $nfs::fixed_ports
  $statd_port          = "--port ${nfs::statd_port}"
  $statd_outgoing_port = "--outgoing-port ${nfs::statd_outgoing_port}"
  file {'/etc/default/nfs-common':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nfs/nfs-common.erb'),
  }

  # configure lockd
  if str2bool($nfs::fixed_ports) {
    $ensure_modprobe = present
  } else {
    $ensure_modprobe = absent
  }
  file {'/etc/modprobe.d/lockd.conf':
    ensure  => $ensure_modprobe,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "# Managed by pupppet.
options lockd nlm_udpport=${nfs::lockd_port} nlm_tcpport=${nfs::lockd_port}
",
    notify  => Exec['set lockd ports in /proc'],
  }

  exec {'set lockd ports in /proc':
    command     => "echo ${nfs::lockd_port} > /proc/sys/fs/nfs/nlm_tcpport; echo ${nfs::lockd_port} > /proc/sys/fs/nfs/nlm_udpport",
    refreshonly => true,
    path        => ['/bin'],
  }

  # set /etc/services entries
  if $fixed_ports {
    nfs::set_service {'rpc.statd: tcp':
      service_name => 'rpc.statd',
      port         => $nfs::statd_port,
      protocol     => 'tcp',
      comment      => 'RPC statd (listen)'
    }
    nfs::set_service {'rpc.statd: udp':
      service_name => 'rpc.statd',
      port         => $nfs::statd_port,
      protocol     => 'udp',
      comment      => 'RPC statd (listen)'
    }
    nfs::set_service {'rpc.statd-bc: tcp':
      service_name => 'rpc.statd-bc',
      port         => $nfs::statd_outgoing_port,
      protocol     => 'tcp',
      comment      => 'RPC statd (send)'
    }
    nfs::set_service {'rpc.statd-bc: udp':
      service_name => 'rpc.statd-bc',
      port         => $nfs::statd_outgoing_port,
      protocol     => 'udp',
      comment      => 'RPC statd (send)'
    }


    nfs::set_service {'rpc.lockd: tcp':
      service_name => 'rpc.lockd',
      port         => $nfs::lockd_port,
      protocol     => 'tcp',
      comment      => 'RPC lockd/nlockmgr'
    }
    nfs::set_service {'rpc.lockd: udp':
      service_name => 'rpc.lockd',
      port         => $nfs::lockd_port,
      protocol     => 'udp',
      comment      => 'RPC lockd/nlockmgr'
    }

  }

  # quota?

}
