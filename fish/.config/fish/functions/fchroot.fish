function fchroot -d "Fuzzy chroots into partitions, even with distinct architectures"
  test (id -u) -eq 0
  or begin
    # Ask for the administrator password upfront
    sudo -v
    or begin
      echo "sudo is needed to mount disks and pseudo-filesystems, aborting"
      return 2
    end

    # Keep-alive: update existing `sudo` time stamp until the parent has finished
    bash -c 'while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null' &
    set -l keepalivePID (jobs -lp)
    function _clean_keepalive -j %self -V keepalivePID
      kill $keepalivePID
      functions -e _clean_keepalive
    end
    disown $keepalivePID
  end

  # fuzzy selects partition
  set partition (lsblk -p -l | awk 'NR == 1 || $6 ~ /part|lvm/' | fzf --header-lines=1 --prompt="which partition you want to chroot into? " --preview="lsblk -p -as {1}" | awk '{print $1}')
  printf "\r"
  test -z $partition; and echo "no partition selected, aborting" && return 2

  # select host architecture
  set targetArch (find /bin/ -type f -executable -name 'qemu-system-*' | awk -F '-' '{print $3}' | sort -h | fzf --prompt="Which architecure is the target system? ")
  test -z $targetArch; and echo "no architecture selected, aborting" && return 2

  # use current mount point, if mounted
  set mountPoint (lsblk -p -l $partition | tail -n 1 | awk '{print $7}')

  # set flags
  set useQemu (test "$targetArch" = (uname -m); echo $status)
  set isPreMounted (test -z "$mountPoint"; echo $status)

  # lazy check if the host has qemu-user-static binaries
  if test $useQemu -eq 1
    printf "QEMU needed to run $targetArch. Checking binary..."
    type -q qemu-$targetArch-static
    or begin
      echo " qemu-$targetArch-static not found."
      echo "Install qemu-user-static package to run cross-arch binaries"
      return 1
    end
    printf " OK\n"
  end

  # if not mounted, creates a temporary mount point and mounts
  if test $isPreMounted -eq 0
    echo "target is not mounted. Creating temporary mount point..."
    set mountPoint (mktemp -d -t chroot-XXXXXXXX)
    echo "mounting partition..."
    sudo mount $partition $mountPoint
  end

  # check if there's available shells on the target mount
  test -f $mountPoint/etc/shells
  and begin
    echo "no shells available on the target mount, aborting"
    test $isPreMounted -eq 0
    and begin
      sudo umount $mountPoint
      rm -rf $mountPoint
    end
    return 2
  end

  # select target shell to run
  set targetShell (cat $mountPoint/etc/shells | grep -v -e "^\$" -e "^#" | sort -h | uniq | fzf --prompt="Which shell you want to use? ")
  test -z $targetShell
  and begin
    echo "no shell selected, aborting"
    test $isPreMounted -eq 0
    and begin
      sudo umount $mountPoint
      rm -rf $mountPoint
    end
  return 2
  end

  echo "preparing to chroot to $partition, a $targetArch system, mounted on $mountPoint, running $targetShell..."

  # mount pseudo-filesystems
  echo "mounting pseudo-filesystems..."
  mkdir -p $mountPoint/dev/{shm,pts}
  sudo mount -o bind /dev $mountPoint/dev
  sudo mount -o bind /dev/pts $mountPoint/dev/pts
  sudo mount -o bind /dev/shm $mountPoint/dev/shm
  mkdir -p $mountPoint/proc
  sudo mount -o bind /proc $mountPoint/proc
  mkdir -p $mountPoint/sys
  sudo mount -o bind /sys $mountPoint/sys

  # copy qemu
  test $useQemu -eq 1; and begin
    echo "copying qemu-$targetArch-static to target's binary path..."
    mkdir -p $mountPoint/usr/bin
    sudo cp (realpath (which qemu-$targetArch-static)) $mountPoint/usr/bin
  end

  # clean up at exit
  function _exit -j %self -V useQemu -V isPreMounted -V mountPoint -V targetArch
    # remove qemu static from target
    test $useQemu -eq 1
    and begin
      echo "[cleanup] removing qemu-$targetArch-static..."
      sudo rm $mountPoint/usr/bin/qemu-$targetArch-static
    end

    # umount system mounts
    echo "[cleanup] unmounting pseudo-filesystems..."
    sudo umount $mountPoint/sys
    sudo umount $mountPoint/proc
    sudo umount $mountPoint/dev/shm
    sudo umount $mountPoint/dev/pts
    sudo umount $mountPoint/dev

    # umount and cleanup
    test $isPreMounted -eq 0
    and begin
      echo "[cleanup] unmounting partition..."
      sudo umount $mountPoint
      rm -rf $mountPoint
    end

    functions -e _exit
  end

  # DO EET D:
  echo "chrooting..."
  sudo chroot $mountPoint qemu-$targetArch-static $targetShell

  printf "\n"
  echo "waiting buffers to flush to disk..."
  sync
end
