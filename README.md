# saltstack-playground

## Installing

### Install requirements

1. [vscode](https://code.visualstudio.com/Download)
1. [docker compose](https://docs.docker.com/compose/install/)
1. vscode plugins
   1. [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Clone this repository

```sh
git clone https://github.com/Xenion1987/saltstack-playground.git
```

## Start the playground

### Start the saltstack control container

Open the repository in vscode. Vscode should give you a hint, that it has detected a DevContainer config and asks you to reopen it in DevContainer. Accept to initialize and start the environment.

### Customize `salt-master-debian` container

> **This step will be executed automatically by starting the DevContainer**

Starting the DevContainer will execute the script [post-create-command.sh](./.devcontainer/scripts/post-create-command.sh). Feel free to modify it to fit to your favorite tools and configs.

### Check minion registration

Each minion should try to register to the **salt-master**:

```txt
root ➜ /workspace (main) $ salt-key
Accepted Keys:
Denied Keys:
Unaccepted Keys:
alma.salt.minion
debian.salt.minion
suse.salt.minion
ubuntu.salt.minion
Rejected Keys:
```

Accept them individually via

```sh
salt-key -a <MINION_NAME>
```

or accept them all at once:

```
root ➜ /workspace (main) $ salt-key -y -A
The following keys are going to be accepted:
Unaccepted Keys:
alma.salt.minion
debian.salt.minion
suse.salt.minion
ubuntu.salt.minion
Key for minion alma.salt.minion accepted.
Key for minion debian.salt.minion accepted.
Key for minion suse.salt.minion accepted.
Key for minion ubuntu.salt.minion accepted.
```

### Test minion connection

Test if accepted minions are responsing as expected:

```
root ➜ /workspace (main) $ salt '*' test.version
debian.salt.minion:
    3006.4
alma.salt.minion:
    3006.4
ubuntu.salt.minion:
    3006.4
suse.salt.minion:
    3006.0
```
