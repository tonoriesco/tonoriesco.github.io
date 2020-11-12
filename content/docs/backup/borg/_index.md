---
title: "Borg"
date: 2020-11-12Z01:41:36
draft: false
weight: 10
description: "Borg Backups"
---

# Description

Borg Backup (aka: Borg) is a deduplicating backup program that supports compression and authenticated encryption.The main goal of Borg is to provide an efficient and secure way to backup data. The data deduplication technique used in Borg backup makes it suitable for daily backups since only changes are stored and the authenticated encryption technique makes it suitable for backups to not fully trusted targets. This article covers installation and usage of Borg Backup in Ubuntu 16 and other Linux flavors.

# Main features of Borg Backup

## Space efficient storage

* Deduplication is based on content-defined chunking which is used to reduce the number of bytes stored. Each file is split into a number of variable length chunks and only chunks that have never been seen before are added to the repository.
* To deduplicate, all the chunks in the same repository are considered, no matter whether they come from different machines, from previous backups, from the same backup or even from the same single file.
* Compared to other deduplication approaches, the method used in borg does NOT depend on
  * File/Directory names staying the same: So you can move files and directories without killing the deduplication, even between machines sharing a repository.
  * Complete files or time stamps staying the same: If a big file changes a little, only a few new chunks need to be stored - this is great for VMs or raw disks.
  * The absolute position of a data chunk inside a file: Stuff may get shifted and will still be found by the deduplication algorithm.

## Speed

* Performance critical code (chunking, compression, encryption) is implemented in C/Cython
* Local caching of files/chunks index data
* Quick detection of unmodified files

## Data encryption

* All data can be protected using 256-bit AES encryption, data integrity and authenticity is verified using HMAC-SHA256. Data is encrypted client side.

## Compression

* All data can be compressed by lz4 (super fast, low compression), zlib (medium speed and compression) or lzma (low speed, high compression).

## Off-site backups

* Borg can store data on any remote host accessible over SSH. If Borg is installed on the remote host, big performance gains can be achieved compared to using a network filesystem (sshfs, nfs, ...).

## Backups mountable as filesystems

* Backup archives are mountable as userspace filesystems for easy interactive backup examination and restores (e.g. by using a regular file manager).

## Free and Open Source Software

* Security and functionality can be audited independently
* Licensed under the BSD (3-clause) license, see License for the complete license

# Install Borg

To install Borg backup in Ubuntu, execute the following command in the terminal.

    #  sudo apt-get install borgbackup borgbackup-doc

You can also download borg binary from github and move it in a location pointed by PATH environment variable.

    # wget https://github.com/borgbackup/borg/releases/download/1.0.10/borg-linux64
    # mv borg-linux64 /usr/local/bin/borg
    # chmod u+x /usr/local/bin/borg
    # chown root:root /usr/local/bin/borg

# Usages of Borg

Borg consists of a number of commands. Each command accepts a number of arguments and options. The following sections will describe each command in detail.

## borg init

Initialize a new backup repository and create a backup archive.

    # Local repository (default is to use encryption in repokey mode)
    borg init /path/to/repo

    # Local repository (no encryption)
    borg init --encryption=none /path/to/repo

    # Remote repository (accesses a remote borg via ssh)
    borg init user@hostname:backup

    # Remote repository (store the key your home dir)
    borg init --encryption=keyfile user@hostname:backup
    Use encryption as it will protect you in case an unauthorized user has access to the backup repository.

## borg create

This command creates a borg backup archive containing all files found while recursively traversing all paths specified. When giving '-' as path, borg will read data from standard input and create a file 'stdin' in the created archive from that data. The archive will consume almost no disk space for files or parts of files that have already been stored in other archives.

    # Backup ~/Documents into an archive named "my-documents"
    borg create /path/to/repo::my-documents ~/Documents

    # same, but verbosely list all files as we process them
    borg create -v --list /path/to/repo::my-documents ~/Documents

    # Backup ~/Documents and ~/src but exclude pyc files
    borg create /path/to/repo::my-files \
    ~/Documents                       \
    ~/src                             \
    --exclude '*.pyc'

    # Backup home directories excluding image thumbnails (i.e. only
    # /home/*/.thumbnails is excluded, not /home/*/*/.thumbnails)
    borg create /path/to/repo::my-files /home \
    --exclude 're:^/home/[^/]+/\.thumbnails/'

    # Do the same using a shell-style pattern
    borg create /path/to/repo::my-files /home \
    --exclude 'sh:/home/*/.thumbnails'

    # Backup the root filesystem into an archive named "root-YYYY-MM-DD"
    # use zlib compression (good, but slow) - default is no compression
    borg create -C zlib,6 /path/to/repo::root-{now:%Y-%m-%d} / --one-file-system

    # Make a big effort in fine granular deduplication (big chunk management
    # overhead, needs a lot of RAM and disk space, see formula in internals
    # docs - same parameters as borg < 1.0 or attic):
    borg create --chunker-params 10,23,16,4095 /path/to/repo::small /smallstuff

    # Backup a raw device (must not be active/in use/mounted at that time)
    $ dd if=/dev/sdx bs=10M | borg create /path/to/repo::my-sdx -

    # No compression (default)
    borg create /path/to/repo::arch ~

    # Super fast, low compression
    borg create --compression lz4 /path/to/repo::arch ~

    # Less fast, higher compression (N = 0..9)
    borg create --compression zlib,N /path/to/repo::arch ~

    # Even slower, even higher compression (N = 0..9)
    borg create --compression lzma,N /path/to/repo::arch ~

    # Use short hostname, user name and current time in archive name
    borg create /path/to/repo::{hostname}-{user}-{now} ~
    # Similar, use the same datetime format as borg 1.1 will have as default
    borg create /path/to/repo::{hostname}-{user}-{now:%Y-%m-%dT%H:%M:%S} ~
    # As above, but add nanoseconds
    borg create /path/to/repo::{hostname}-{user}-{now:%Y-%m-%dT%H:%M:%S.%f} ~

## borg extract

This command extracts the contents from an archive and writes in the current directory.

    # Extract entire archive
    borg extract /path/to/repo::my-files

    # Extract entire archive and list files while processing
    borg extract -v --list /path/to/repo::my-files

    # Extract the "src" directory
    borg extract /path/to/repo::my-files home/USERNAME/src

    # Extract the "src" directory but exclude object files
    borg extract /path/to/repo::my-files home/USERNAME/src --exclude '*.o'

    # Restore a raw device (must not be active/in use/mounted at that time)
    borg extract --stdout /path/to/repo::my-sdx | dd of=/dev/sdx bs=10M

## borg check

The check command verifies the consistency of a repository and the corresponding archives.

    # check for corrupt chunks / segments:
    borg check -v --repository-only REPO
    # repair the repo:
    borg check -v --repository-only --repair REPO
    # make sure everything is fixed:
    borg check -v --repository-only REPO

# borg rename

This command renames an archive in the repository.

    borg create /path/to/repo::archivename ~
    borg list /path/to/repo archivename
    borg rename /path/to/repo::archivename newname
    borg list /path/to/repo/newname

## borg list

This command lists the contents of a repository or an archive.

    borg list /path/to/repository
    borg list /path/to/repo::root-2017-03-06
    borg list /path/to/repo::archiveA --list-format="{mode} {user:6} {group:6} {size:8d} {isomtime} {path}{extra}{NEWLINE}"
    # see what is changed between archives, based on file modification time, size and file path
    borg list /path/to/repo::archiveA --list-format="{mtime:%s}{TAB}{size}{TAB}{path}{LF}" |sort -n > /tmp/list.archiveA
    borg list /path/to/repo::archiveB --list-format="{mtime:%s}{TAB}{size}{TAB}{path}{LF}" |sort -n > /tmp/list.archiveB
    $ diff -y /tmp/list.archiveA /tmp/list.archiveB

# borg delete

This command deletes an archive from the repository or the complete repository. Disk space is reclaimed accordingly. If you delete the complete repository, the local cache for it (if any) is also deleted.

    # delete a single backup archive:
    borg delete /path/to/repo::Monday

    # delete the whole repository and the related local cache:
    borg delete /path/to/repo

## borg prune

The prune command prunes a repository by deleting all archives not matching any of the specified retention options. This command is normally used by automated backup scripts wanting to keep a certain number of historic borg backup.

    # Keep 7 end of day and 4 additional end of week archives.
    # Do a dry-run without actually deleting anything.
    borg prune -v --list --dry-run --keep-daily=7 --keep-weekly=4 /path/to/repo

    # Same as above but only apply to archive names starting with the hostname
    # of the machine followed by a "-" character:
    borg prune -v --list --keep-daily=7 --keep-weekly=4 --prefix='{hostname}-' /path/to/repo

    # Keep 7 end of day, 4 additional end of week archives,
    # and an end of month archive for every month:
    borg prune -v --list --keep-daily=7 --keep-weekly=4 --keep-monthly=-1 /path/to/repo

    # Keep all backups in the last 10 days, 4 additional end of week archives,
    # and an end of month archive for every month:
    borg prune -v --list --keep-within=10d --keep-weekly=4 --keep-monthly=-1 /path/to/repo

## borg info

This command displays some detailed information about the specified archive.

    borg info /path/to/repo::root-2017-03-06

## borg mount

This command mounts an archive as a FUSE filesystem. This can be useful for browsing an archive or restoring individual files.

    borg mount /path/to/repo::root-2017-03-06 /tmp/mymountpoint
    $ ls /tmp/mymountpoint

## borg umount

This command un-mounts a FUSE filesystem that was mounted with borg mount.

    borg umount /tmp/mymountpoint

## borg key export

If repository encryption is used, the repository is inaccessible without the key. This command allows to backup this essential key.

    borg key export /path/to/repo /path/to/export

## borg key import

This command allows restore a key previously backed up with the export command.

    borg key import /path/to/repo /path/to/import

## borg change-passphrase

The key files used for repository encryption are optionally passphrase protected. This command can be used to change this passphrase.

# Create a key file protected repository

    borg init --encryption=keyfile -v /path/to/repo

# Change key file passphrase

    borg change-passphrase -v /path/to/repo

## borg break-lock

This command breaks the repository and cache locks. Please use carefully and only while no borg process (on any machine) is trying to access the Cache or the Repository.

    borg break-lock /path/to/repo
