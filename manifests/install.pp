# installs the nfs-common package (private)
class nfs::install {

  package { ['nfs-common', 'rpcbind']: ensure => latest }


# quota?

}
