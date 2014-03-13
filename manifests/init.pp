# handles nfs
class nfs (
  $fix_ports           = true,
  $statd_start         = true,
  $statd_port          = '2046',
  $statd_outgoing_port = '2047',
  $idmapd_start        = false,
  $gssd_start          = false,
) {

  contain nfs::install
  contain nfs::config
  contain nfs::service

  Class['nfs::install']
  -> Class['nfs::config']
  ~> Class['nfs::service']

}
