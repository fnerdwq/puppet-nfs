# sets a service in /etc/services (private)
define nfs::set_service (
  $port,
  $protocol,
  $comment,
  $service_name = $title,
) {

  # set the service only, when there is no corresponding service
  # with the name/port/protocol
  # Existing services (i.e. the name) is _not_ replaced!
  $changes = [
    'ins service-name after service-name[last()]',
    "set service-name[last()] ${service_name}",
    "set service-name[last()]/port ${port}",
    "set service-name[last()]/protocol ${protocol}",
    "set service-name[last()]/#comment ${comment}",
  ]

  augeas { $title:
    context => '/files/etc/services',
    changes => $changes,
    onlyif  => "match service-name[. = '${service_name}'][port = '${port}'][protocol = '${protocol}'] size == 0",
  }
}

