# creation of mountpoints (private)
class nfs::mount {

  create_resources('nfs::create_mount', $nfs::mounts)

}
