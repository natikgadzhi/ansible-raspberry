# TODOS

- [ ] Restart the K3s cluster with 3 nodes.
- [ ] Re-implement dns system as dnscrypt-proxy in K8s
- [ ] Setup backups for all nodes with `restic` to a remote location.
- [ ] Make K8s Prometheus accessible from outsite of the K8s cluster, and add a
      Grafana dashboard with Pi machines metrics.

## Learn

- [ ] How does persistent storage work in k8s? How do I monitor disks for
      capacity and make sure all of k8s cluster volumes are in a secure
      location?

## Ubuntu-specific tasks

- [ ] Render cloud-init configs with templates locally, so that I can use
      ansible to burn new SD-cards with the right configs. Support both Ubuntu
      20.04 and Raspbian. Setup custom config variables to store image paths.
- [ ] Implement a playbook to burn a new SD card given an OS image.
- [ ] Implement a task to copy over templated files to the /boot of the new
      image.

## Improving DNS system

- [ ] Check if pihole handles IPv6 requests, fix it if not
- [ ] See if I can run pihole in k3s cluster instead of Docker.
- [ ] Setup unbound (docker? k3s?) to serve as the local DNS server and double
      check that our DNS requests are not leaking out.
- [x] Generate dnsmasq config with a template, iterating over hosts and their
      fqdns, instead of a static file.

## Archive

### Done in July 2020

#### Features / Urgent

- [x] Fix `ssh-keys.yaml` to only change specific lines of the `sshd_config`
      without copying the whole file. Looks like Ubuntu locks me out if I copy
      the config from Debian :D
- [x] Make sure `time-machine` role works on Ubuntu and resume the backups.
  - [x] Install `hfsprogs` in the role.
  - [x] Checkfs needs to be templated, and variable defaults need to be set
  - [x] Mount the partition to a specified mount point
  - [x] Add the partition to fstab
  - [x] Tweak the docker volumes to ~/volumes/
  - [x] Test that the time machine works
  - [x] In checkfs, add docker-compose invocation to stop the time machine
        container before checking the file system and remounting.
- [x] Extract setting up an hfsplus partition into a separate configuragble
      role, and use that role as a requirement for time machine.

#### Refactoring

- [x] Split `site.yaml` into smaller playbooks, included in the main one, to be
      able to run only the parts I need to debug, without editing `site.yaml`.
- [x] Use `geerlingguy.docker` instead of my own `docker` role to clean up the
      repo.
- [x] Refactor setting the shell to using the user module
- [x] Move `docker-compose` specifications into separate files from the
      playbooks in `pihole` and `time-machine`

#### Improving DNS system

- [x] Generate dnsmasq config with a template, iterating over hosts and their
      fqdns, instead of a static file.
