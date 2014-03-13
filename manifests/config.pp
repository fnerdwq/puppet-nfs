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

  #/etc/services



  # quota?

}
