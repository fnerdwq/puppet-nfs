# exports a filesystem, buy only if server is configured
define nfs::export (
  $hosts,
  $directory = $name,
) {

  if ! $nfs::server {
    fail('NFS Server must be configured. Set $nfs::install_server=true')
  }

  include nfs

  Class['nfs::server::config']
  -> Nfs::Export[$name]
  -> Class['nfs::server::service']

  $exports_content = join(any2array($hosts),' ')
  concat::fragment{"exports: ${directory}":
    target  => '/etc/exports',
    order   => 10,
    content => $exports_content,
  }

#  exec {'reexportg filesystems':
#    command     => 'exportfs -ra'
#    refreshonly => true,
#    path        => ['/usr/bin'],
#  }
}
