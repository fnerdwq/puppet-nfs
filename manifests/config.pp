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

  $fix_ports           = $nfs::fix_ports
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
  if str2bool($nfs::fix_ports) {
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

  #/etc/services



  # quota?

}
