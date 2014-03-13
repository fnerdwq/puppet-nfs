# creates nfs mounts
define nfs::mount (
  $ensure  = mounted,
  $device  = undef,
  $options = undef,
  $remount = true,
) {

  include nfs

  Class['nfs']
  -> Nfs::Mount[$name]

  file {$name: ensure => directory }

  mount {$name:
    ensure  => $ensure,
    device  => $device,
    options => $options,
    dump    => 0,
    fstype  => nfs,
    pass    => 0,
    remount => $remount,
    require => File[$name],
  }

}
