# installs the nfs-kernel-server package (private)
class nfs::server::install {

  package {'nfs-kernel-server': ensure => latest }

# quota?

}
