# manages the nfs-common/rpcbind(poartmapper) service (private)
class nfs::service {

  service {'rpcbind':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  service {'nfs-common':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Service['rpcbind'],
  }

}
