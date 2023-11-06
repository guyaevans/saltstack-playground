#!/usr/bin/env bash

WORKDIR="/workspace"

function install_basics() {
  export DEBIAN_FRONTEND=noninteractive
  sudo apt update && sudo apt -y dist-upgrade
  sudo apt install -y --no-install-recommends \
    iputils-ping \
    python3-pip \
    python3-argcomplete
  sudo rm -rf /var/lib/apt/lists/*
  sudo apt -y clean
  sudo apt -y autoclean
  sudo apt -y autoremove

  if [[ ! -f /usr/bin/python ]]; then
    sudo ln -s /usr/bin/python3 /usr/bin/python
  fi
}
function setup_python_argcomplete() {
  if type -p activate-global-python-argcomplete &>/dev/null; then
    sudo activate-global-python-argcomplete --dest /etc/bash_completion.d/
  elif type -p activate-global-python-argcomplete3 &>/dev/null; then
    sudo activate-global-python-argcomplete3 --dest /etc/bash_completion.d/
  fi
}
function install_salt_completion() {
  curl -sL -o "/etc/bash_completion.d/salt.bash" --url "https://raw.githubusercontent.com/saltstack/salt/develop/pkg/salt.bash"
}
function generate_config_files() {
  if find "${HOME}" -type f -name '.functions' | grep -q .; then
    return 0
  fi
  MY_SHELL=$(awk -F: '/^'$(whoami)'/ {print $NF}' /etc/passwd)
  MY_SHELL=${MY_SHELL##*/}
  cat <<_EOF >>"${HOME}/.${MY_SHELL}rc"
########################################
###### ADDED BY 'post-create-command.sh'
########################################
files=(.functions .paths)
for file in "\${files[@]}"; do
    if [[ ! -f "\${HOME}/\${file}" ]]; then
        touch "\${HOME}/\${file}"
    else
        source "\${HOME}/\${file}"
    fi
done
if [[ -f /etc/bash_completion ]]; then
  MY_SHELL=\$(awk -F: '/^'\$(whoami)'/ {print \$NF}' /etc/passwd)
  MY_SHELL=\${MY_SHELL##*/}
  if [[ \${MY_SHELL} == "bash" ]]; then
    . /etc/bash_completion
  fi
fi
function source_saltstack_aliases() {
  if ! grep -q 'logs-master'< <(alias); then
    . /workspace/.devcontainer/scripts/.aliases
    return 0
  fi
}
source_saltstack_aliases
########################################
_EOF

  files=(.functions .paths)
  for file in "${files[@]}"; do
    touch "${HOME}/${file}"
  done

  EXPAND_PATHS=("${HOME}/.local/bin")
  for EXPAND_PATH in "${EXPAND_PATHS[@]}"; do
    if ! grep -q "{EXPAND_PATH}" "${HOME}/.paths"; then
      echo "PATH=\${PATH}:${EXPAND_PATH}" >>"${HOME}/.paths"
    fi
  done
}
### PRE COMMIT
command_exists() {
  # Function to check if a command exists
  command -v "$1" >/dev/null 2>&1
}
install_pre_commit_linux() {
  # Function to install pre-commit on Linux
  echo "Installing pre-commit on Linux..."
  $PIP_CMD install pre-commit
}

install_pre_commit_macos() {
  # Function to install pre-commit on macOS
  echo "Installing pre-commit on macOS..."
  $PIP_CMD install pre-commit
}
check_pip_command() {
  # Check if pip is installed
  if command_exists pip; then
    PIP_CMD="pip"
  elif command_exists pip3; then
    PIP_CMD="pip3"
  else
    echo "pip is not installed. Please install pip (https://pip.pypa.io/en/stable/installing/) and run the script again."
    exit 1
  fi
}
install_pre_commit() {
  # Check if pre-commit is already installed
  if command_exists pre-commit; then
    echo "pre-commit is already installed."
    return 0
  else
    case "$(uname)" in
    Linux)
      install_pre_commit_linux
      ;;
    Darwin)
      # Check if Homebrew is installed
      if command_exists brew; then
        install_pre_commit_macos
      else
        echo "Homebrew is not installed. Please install Homebrew (https://brew.sh/) and run the script again."
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS. This script only supports Linux and macOS."
      exit 1
      ;;
    esac
  fi
}
activate_pre_commit() {
  pre-commit install
}
function main() {
  install_basics
  setup_python_argcomplete
  install_salt_completion
  generate_config_files
  # build_docker_images
  # start_docker_images
  # check_pip_command
  # install_pre_commit
  # activate_pre_commit
}
main
