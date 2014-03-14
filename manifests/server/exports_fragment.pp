# adds an export as concat fragment (private)
define nfs::server::exports_fragment (
  $hosts,
  $directory = $title,
) {
  validate_absolute_path($directory)

  $exports_content = join(any2array($hosts),' ')

  concat::fragment{"exports: ${directory}":
    target  => '/etc/exports',
    order   => 10,
    content => "${directory} ${exports_content}\n",
  }
}
