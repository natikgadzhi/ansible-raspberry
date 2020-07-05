# Nate's Raspberry PI Ansible Playbooks

A set of simple ansible playbooks that make adding new Pis, managing their 
configuration (dotfiles), and updating their packages easier.

### Setting up a Raspberry PI node
1. Follow the docs on starting the Pi up. Preparing the OS microsd memory card and enabling wifi on it are not covered by this repo's playbooks.
2. Manually ssh into the new PI and setup it's hostname in `/etc/hostname` and `/etc/hosts`. I'm using mDNS and naming `rpiX.local`.
3. Add the new host to `hosts` inventory.
4. Use `ansible-playbook ssh_keys.yaml` to put your ssh keys to all hosts in `rpi` group. If you don't have sshpass or don't want to install it, you can do that manually.
5. Run `ansible-playbook dotfiles.yaml` to setup your dotfiles. 
6. Run `ansible-playbook apt-get.yaml` to install minimal set of packages, including fish, vim, and docker.


### Preparing the microsd card
Assuming the card already have a fresh raspberrian lite on it: 

```bash
cd /Volumes/boot # Assuming you're doing this in mac OS. 
touch ssh        # To enable SSH by default on the new PI
vim wpa_supplicant.conf # Wifi network, if needed.
```

See [more here](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)

#### TODOS

- [x] Write down a guide on how to add a new PI and describe the workflow.
- [ ] Automatically disable password login for pi
- [ ] Add a link to an article describing my current Pi setup.
- [ ] Move current docker containers to a managed docker-compose.yml with an ansible role.
