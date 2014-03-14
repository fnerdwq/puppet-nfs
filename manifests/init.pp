# handles nfs
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
  $need_svcgssd        = false,
  $nfsd_callback_port  = '32764',
  $exports             = {},
) {

  #validation!
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
