# creates nfs mounts
define nfs::mount (
  $ensure   = mounted,
  $device   = undef,
  $options  = undef,
  $remounts = true,
) {

  include nfs

  Class['nfs']
  -> Nfs::Mount[$name]

  file {$name: ensure => directory }

  mount {$name:
    ensure   => $ensure,
    device   => $device,
    options  => $options,
    dump     => 0,
    fstype   => 'nfs',
    pass     => 0,
    remounts => $remounts,
    require  => File[$name],
  }

}
