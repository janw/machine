# Machine 📠

Machine is a collection of scripts to set up macOS for "pro-use" and software development.

The [main script](#usage) is idempotent, i.e. it can be run multiple times on the same machine safely. It installs, upgrades, or skips packages based on what is already installed on the machine.

## Usage

Clone the repository (`git` is available on all recent macOS versions from the start):

```sh
git https://github.com/janw/machine.git
cd machine
```

Review the scripts (avoid running scripts you haven't read!)

Run it!

```sh
sh mac 2>&1 | tee ~/machine.log
```

Optionally, review the log:

```sh
less ~/machine.log
```

## What it sets up

**Not up-to-date. Check the repository files to find out.**

### Base tools

* [Homebrew] for managing packages.
* [MAS] for managing macOS App Store applications.

### Tools and libraries (all managed via the base tools)

* [Git] for version control
* [Zsh] as your shell
* [Node.js] and [NPM], for running apps and installing JavaScript packages

### Additional tools and libraries with custom setup processes

None.

[Homebrew]: http://brew.sh/
[Git]: https://git-scm.com/
[Zsh]: http://www.zsh.org/
[Node.js]: http://nodejs.org/
[NPM]: https://www.npmjs.org/
