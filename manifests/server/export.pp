# exports a filesystem, buy only if server is configured (private)
class nfs::server::export {

  # prepare /etc/exports if not already done
  concat {'/etc/exports':
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Exec['reexport filesystems'],
  }

  concat::fragment {'exports_header':
    target  => '/etc/exports',
    order   => 01,
    content => "# Managed by puppet.\n\n",
  }

  create_resources('nfs::server::exports_fragment', $nfs::exports)

  exec {'reexport filesystems':
    command     => 'exportfs -r',
    refreshonly => true,
    path        => ['/usr/bin'],
  }

}
