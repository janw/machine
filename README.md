# Machine 💻

Machine is a script to set up macOS for development and comfortable "expert-level" use.

It can be run multiple times on the same machine safely. It installs, upgrades, or skips packages based on what is already installed on the machine.

## Requirements

I currently use this on macOS Catalina (10.15) only.

## Install

Download the script:

```sh
curl --remote-name https://raw.githubusercontent.com/janw/machine/master/machine
```

Review the script (avoid running scripts you haven't read!):

```sh
less machine
```

Execute the downloaded script:

```sh
sh machine 2>&1 | tee ~/machine.log
```

Machine will ask for confirmation before continuing through the major sections of the configuration. To skip those confirmations, set `MACHINE_NO_CONFIRM=1`:

```sh
MACHINE_NO_CONFIRM=1 sh machine 2>&1 | tee ~/machine.log
```

Optionally, review the log:

```sh
less ~/machine.log
```

Optionally, [install janw/dotfiles](https://github.com/janw/dotfiles).

## Debugging

Your last Machine run will be saved to `~/machine.log`. Read through it to see if you can debug the issue.

## What it sets up

macOS tools:

* [Homebrew](http://brew.sh/) for managing operating system libraries.

Unix tools:

* [Git](https://git-scm.com/) for version control
* [Zsh](http://www.zsh.org/) as your shell
* A whole bunch more (check the [Brewfile](Brewfile) for more details)

It should take less than 15 minutes to install.

## Customize in `~/.machine.local`

Your `~/.machine.local` is run at the end of the Machine script. Put your customizations there. For example:

```sh
#!/bin/bash

brew bundle --file=- <<EOF
brew "Caskroom/cask/dockertoolbox"
brew "go"
brew "ngrok"
brew "watch"
EOF

default_docker_machine() {
  docker-machine ls | grep -Fq "default"
}

if ! default_docker_machine; then
  docker-machine create --driver virtualbox default
fi

default_docker_machine_running() {
  default_docker_machine | grep -Fq "Running"
}

if ! default_docker_machine_running; then
  docker-machine start default
fi

fancy_echo "Cleaning up old Homebrew formulae ..."
brew cleanup
brew cask cleanup

if [ -r "$HOME/.rcrc" ]; then
  fancy_echo "Updating dotfiles ..."
  rcup
fi
```

Write your customizations such that they can be run safely more than once.
See the `machine` script for examples. Machine functions such as `fancy_echo` and `gem_install_or_update` can be used in your `~/.machine.local`.

## License

Machine is based on [Laptop](https://github.com/thoughtbot/laptop) which is © 2011-2017 thoughtbot, inc and licensed under MIT License.

Just like its foundation Machine is free software, and may be redistributed under the terms specified in the [LICENSE](LICENSE) file.
