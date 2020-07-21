# Home raspberry cluster ansible playbooks

Ansible playbook that manages a cluster of local Raspberry Pi machnes running
Pihole and Time Machine.

This is a personal learning project, please don't use that in production ;) If
you see that I did something _very wrong_ here, please do file an issue or DM
me, I'd be very grateful for an opportunity to learn more.

## Usage

If you have a bunch of PIs and you'd like to play around with Ansible, do this:

1. Fork and clone the repo
2. Edit the `hosts` file to include the list of your Raspberry PIs hostnames
3. Edit the `group_vars/all.yaml`, most importantly the dotfiles repo and github
   username used for ssh keys.

### Setting up a Raspberry PI node

1. Follow the docs on starting the Pi up. Preparing the OS microsd memory card
   and enabling wifi on it are not covered by this repo's playbooks.
2. Manually ssh into the new PI and setup it's hostname in `/etc/hostname` and
   `/etc/hosts`. I'm using mDNS and naming `rpiX.local`.
3. Add the new host to `hosts` inventory.
4. `ansible-playbook site.yaml` will run `ssh-keys`, `prereq`, and `pihole`
   roles on applicable machines.

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

- `github_username` in `group_vars/all` — sets username in github to grab public
  keys from.

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

### `docker`

This is an internal dependency role. It sets up docker, requires pip3 and
`docker` and `docker-compose` pip packages to be installed so that we can later
manage the cluster's docker and docker-compose via ansible.

### `pihole`

Installs and runs pihole in a docker container in all machines in pihole group.

_Note:_ `group_vars/dockerized.yaml` is vaulted, and has pihole and time machine
passwords in there. For your own cluster, you'll want to rm the file, and create
your own vars file, optionally vaulting it, too.

Settings:

- `pihole_hostname` — which hostname to set for pihole. That might be specific
  to your network.

### `time-machine`

Runs
[`mbentley/docker-timemachine`](https://github.com/mbentley/docker-timemachine)
in the cluster in docker-compose. Takes `timemachine_password` variable in, it's
defined in the vaulted `group_vars/dockerized.yaml` by default.
