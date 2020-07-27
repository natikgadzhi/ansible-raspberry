# Home raspberry cluster ansible playbooks

Ansible playbook that manages a cluster of local Raspberry Pi machnes running
Pihole and Time Machine.

This is a personal learning project, please don't use that in production ;) If
you see that I did something _very wrong_ here, please do file an issue or DM
me, I'd be very grateful for an opportunity to learn more.

## Usage

If you have a bunch of PIs and you'd like to play around with Ansible, do this:

1. Fork and clone the repo
2. Edit the `inventory/hosts.ini` file to include the list of your Raspberry PIs
   hostnames
3. Edit the `group_vars/all.yaml`, most importantly the dotfiles repo and github
   username used for ssh keys.

### Setting up a Raspberry PI node

The roles will work for both Raspbian and Ubuntu 20.04, you can set your
machines up with whatever system you prefer. I'm using Ubuntu for the docker
host, and the K3s cluster, and Raspbian on Pi Zero machines.

1. Follow the docs on starting the Pi up. Preparing the OS microsd memory card
   and enabling wifi on it are not covered by this repo's playbooks.
2. Manually ssh into the new PI and setup it's hostname in `/etc/hostname` and
   `/etc/hosts`. I'm using mDNS and naming `rpiX.local`.
3. Add the new host to `hosts` inventory.
4. `ansible-playbook site.yaml` will run `ssh-keys`, `prereq`, `pihole`, and
   `time-machine` roles. If you just need pihole OR time machine, you can
   comment out the roles that you don't need in the site.yaml.

### Preparing the microsd card

Assuming the card already have a fresh raspberrian lite on it:

```bash
cd /Volumes/boot # Assuming you're doing this in mac OS.
touch ssh        # To enable SSH by default on the new PI
vim wpa_supplicant.conf # Wifi network, if needed.
```

See
[more here](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md).

## Roles

### `ssh-keys`

Puts your ssh keys from github into the Pi, and disables password authentication
in ssh.

Settings:

- `github_username` in `group_vars/all.yaml` — sets username in github to grab
  public keys from.

### `prereq`

Sets up requirements for any additional roles on the PIs, and prepares the
environment.

What it does:

- Set timezone to `timezone` var. Default: Pacific.
- Add github.com to known_hosts so PI can clone / checkout repos.
- Installs essential packages, for now it explicitly uses `apt`, not `package`
  module. You can setup `packages` var to install additional packages. By
  default, it installs `git`, `fish`, `vim`, and `tmux`.
- Updates all packages to latest versions.
- Check out and install dotfiles from a repo set in `dotfiles_repo`

_*Note*: on Ubuntu, I use a cloud-init `user-data` script that manages the
majority of those tasks, and one of the next steps for this repository is to
have a separate playbook that burns an SD card and sets up all required files,
including `network-config` and `user-data` for Ubuntu, and `ssh` and
`wpa_supplicant` on Raspbian._

### `pihole`

Installs and runs
[pihole in a docker container](https://github.com/pi-hole/docker-pi-hole) in all
machines in pihole group.

_Note: `group_vars/docker.yaml` is vaulted, and has pihole and time machine
passwords in there. For your own cluster, you'll want to rm the file, and create
your own vars file, optionally vaulting it, too._

The role uses `geerlingguy.pip` and `geerlingguy.docker` roles as requirements,
and then uses docker-compose to start and manage pihole.

Settings:

- `pihole_hostname` — which hostname to set for pihole. That might be specific
  to your network.
- Take a look at [`pihole/defaults/main.yaml`](/roles/pihole/defaults/main.yaml)
  \
  for more variables that you can set. They're all optional and have a sensible default
  value.

### `time-machine`

Runs
[`mbentley/docker-timemachine`](https://github.com/mbentley/docker-timemachine)
in the cluster in docker-compose. Takes `timemachine_password` variable in, it's
defined in the vaulted `group_vars/dockerized.yaml` by default.

Settings:

- Take a look at
  [`roles/time-machine/defaults/main.yaml`](/roles/time-machine/defaults/main.yaml)
  to learn more. Hostname, password, and volumes are customizable.

_By default, time machine role uses internal `hfsplus` role to mount an HFS+
(Mac OS Extended) partition on an external drive `/dev/sda2`. If you'd rather
have an Ext4 drive, you could drop the HFS+ dependency._

## How apps are managed

This playbook is runnning apps with Docker Compose. All of the setting and data
of the apps are in mounted volumes, and volumes, by default, are in
`/home/pi/volumes/`. You can change this path by changing `docker_volumes_path`
variable in `group_vars/all`.

`docker-compose.yaml` files for each app are stored in `/home/pi/apps/*`.

## TODOs

Want to help out? Take a look at [TODOs](TODO.md)
