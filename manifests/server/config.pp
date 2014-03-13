# configure the nfs-kernel-server package (private)
class nfs::server::config {

  # /etc/default/nfs-kernel-server
  if str2bool($nfs::svcgssd_start) {
    $need_svcgssd = 'yes'
  } else {
    $need_svcgssd = 'no'
  }

  $fix_ports           = $nfs::fix_ports
  $mountd_port         = "--port ${nfs::mountd_port}"
  if $nfs::disable_version {
    $no_nfs_version = "--no-nfs-version ${nfs::disable_version}"
  }
  file {'/etc/default/nfs-common':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nfs/nfs-common.erb'),
  }

  # configure nfsd_callback_port, fix_ports
  file {'/etc/modprobe.d/nfs.conf':
    ensure  => $nfs::fix_ports,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "# Managed by pupppet.
options nfs callback_tcpport=${nfs::nfsd_callback_port}
"
  }

  #/etc/services


  # quota?

}
