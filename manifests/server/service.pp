# manages the nfs-kernel-server service (private)
class nfs::server::service {

  service {'nfs-kernel-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
