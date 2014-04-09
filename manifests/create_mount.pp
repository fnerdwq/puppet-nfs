# creates nfs mounts (private)
define nfs::create_mount (
  $ensure   = mounted,
  $device   = undef,
  $options  = undef,
  $remounts = true,
) {

  file { $name: ensure => directory }

  mount { $name:
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
