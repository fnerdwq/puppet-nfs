# exports a filesystem, buy only if server is configured
define nfs::export (
  $hosts,
  $directory = $name,
) {

  include nfs

  if ! $nfs::install_server {
    fail('NFS Server must be configured. Set $nfs::install_server=true')
  }

  $exports_content = join(any2array($hosts),' ')
  concat::fragment{"exports: ${directory}":
    target  => '/etc/exports',
    order   => 10,
    content => "${directory} ${exports_content}\n",
  }

#  exec {'reexportg filesystems':
#    command     => 'exportfs -ra'
#    refreshonly => true,
#    path        => ['/usr/bin'],
#  }
}
