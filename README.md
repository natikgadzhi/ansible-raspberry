# Nate's Raspberry PI Ansible Playbooks

A set of simple ansible playbooks that make adding new Pis, managing their
configuration (dotfiles), and updating their packages easier.

## Usage

This is a very newbish setup, and my goal with this is to learn. Please don't
use these in production.

If you have a bunch of PIs and you'd like to play around with Ansible, do this:

1. Fork and clone the repo
2. Edit the `hosts` file to include the list of your PI computers hostnames
3. Edit the `vars/variables.yaml`, most importantly the dotfiles repo and github
   username used for ssh keys.

If you see that I did something _very wrong_ here, please do file an issue or DM
me, I'd be very grateful for an opportunity to learn more.

### Setting up a Raspberry PI node

1. Follow the docs on starting the Pi up. Preparing the OS microsd memory card
   and enabling wifi on it are not covered by this repo's playbooks.
2. Manually ssh into the new PI and setup it's hostname in `/etc/hostname` and
   `/etc/hosts`. I'm using mDNS and naming `rpiX.local`.
3. Add the new host to `hosts` inventory.
4. Use `ansible-playbook ssh-keys.yaml` to put your ssh keys to all hosts in
   `rpi` group. If you don't have sshpass or don't want to install it, you can
   do that manually.
5. Run `ansible-playbook packages.yaml` to install minimal set of packages,
   including `fish`, `vim`, `git`, `tmux`.
6. Run `ansible-playbook dotfiles.yaml` to setup your dotfiles.

### Preparing the microsd card

Assuming the card already have a fresh raspberrian lite on it:

```bash
cd /Volumes/boot # Assuming you're doing this in mac OS.
touch ssh        # To enable SSH by default on the new PI
vim wpa_supplicant.conf # Wifi network, if needed.
```

See
[more here](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md).

## TODOS

#### Housekeeping

- [x] Write down a guide on how to add a new PI and describe the workflow.
- [x] A task to setup timezone
- [x] A task to automatically disable password login for pi
- [x] Add `ansible-lint` to the repo, so I'll be annoyed and fix all the
      warnings.
- [ ] Role + task to check and remount hfsplus on network storage pi

#### Applications

- [ ] Make sure pihole is working correctly and has a correct hostname
- [ ] Create a templated `docker-compose.yml`, managed and run by Ansible. This
      will require roles and vault.

- [ ] Move pihole, time machine, and portainer to the docker-compose playbook

- [ ] Setup a dynamic inventory, and use it to set dnsmasq in pihole
- [ ] Setup a DHCP server in pihole?

#### Documentation

- [ ] Add a link to an article describing my current Pi setup.
