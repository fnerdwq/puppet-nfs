# == Class: nfs
#
# This installs nfs client and/or server.
# NFSv3 is really supported by now.
#
# This works on Debian.
# Puppet Version >= 3.4.0
#
# === Parameters
#
# [*fixed_ports*]
#   Should we fix ports for firewalling?
#   *Optional* (defaults to true)
#
# [*statd_start*]
#   Should we start the rpc.statd?
#   *Optional* (defautls to true)
#
# [*statd_port*]
#   Which fixed port to use for rpc.statd.
#   *Optional* (defaults to 32765)
#
# [*statd_outgoing_port*]
#   Wich fixed ports to use for outging rpc.statd.
#   *Optional* (defaults to 32766).
#
# [*idmapd_start*]
#   Should we start the idmapd?
#   *Optional* (defaults to false)
#
# [*gssd_start*]
#   Should we start the gssd?
#   *Optional* (defaults to false)
#
# [*lockd_port*]
#   Which fixed port to use for rpc.lockd.
#   *Optional* (defaults to 32768)
#
# [*mounts*]
#   Hash of NFS mountpoints (see README).
#   *Optional* (defaults to {})
#
# [*install_server*]
#   Install nfs server packages?
#   *Optional* (defaults to false)
#
# [*mountd_port*]
#   Which fixed port to use for rpc.mountd.
#   *Optional* (defaults to 32767)
#
# [*disable_version*]
#   Should we disable NFS version on mountd?
#   *Optional* (defaults to 4)
#
# [*svcgssd_start*]
#   Should we start the svcgssd?
#   *Optional* (defaults to false)
#
# [*nfsd_callback_port*]
#   Which fixed port to use for nfs callbacks.
#   *Optional* (defaults to 32764)
#
# [*exports*]
#   Hash of NFS exports (see README).
#   *Optional* (defaults to {})
#
# === Examples
#
# include nfs
#
# === Authors
#
# Frederik Wagner <wagner@wagit.de>
#
# === Copyright
#
# Copyright 2014 Frederik Wagner
#

class nfs (
  $fixed_ports         = true,
  $statd_start         = true,
  $statd_port          = '32765',
  $statd_outgoing_port = '32766',
  $idmapd_start        = false,
  $gssd_start          = false,
  $lockd_port          = '32768',
  $mounts              = {},
  $install_server      = false,
  $mountd_port         = '32767',
  $disable_version     = '4',
  $svcgssd_start       = false,
  $nfsd_callback_port  = '32764',
  $exports             = {},
) {
  validate_bool($fixed_ports)
  validate_bool($statd_start)
  validate_bool($idmapd_start)
  validate_bool($gssd_start)
  validate_hash($mounts)
  validate_bool($install_server)
  validate_bool($svcgssd_start)
  validate_hash($exports)

  contain nfs::install
  contain nfs::config
  contain nfs::service
  contain nfs::mount

  Class['nfs::install']
  -> Class['nfs::config']
  ~> Class['nfs::service']
  -> Class['nfs::mount']

  if $install_server {

    contain nfs::server::install
    contain nfs::server::config
    contain nfs::server::service
    contain nfs::server::export

    Class['nfs::service']
    -> Class['nfs::server::install']
    -> Class['nfs::server::config']
    ~> Class['nfs::server::service']
    -> Class['nfs::server::export']

  }

}
