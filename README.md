# vim\_config

A portable, automated installer for my personal Vim configuration.

This repository contains:

* `vim_folder/` — expected location for the `.vimrc` that will be copied to `~/.vimrc` by the installer.
* `install.sh` — the automated installer script that detects the package manager, installs required packages, clones Vundle, installs plugins and (optionally) builds YouCompleteMe.
* `LICENSE` and `README.md` (this file).

---

## Quick overview

The installer expects your working directory to look like this (already present in this repo):

```
.git/
install.sh
vim_folder/
```

Before running the installer, copy your `.myvimrc` to `vim_folder/.vimrc` (the installer will `cp ./vim_folder/.vimrc ~/.vimrc`):

```bash
# from repo root
chmod +x install.sh
# run installer (may prompt for sudo)
sudo ./install.sh
```

If you prefer to keep the file elsewhere, you can pass a path to `install.sh`:

```bash
sudo ./install.sh /path/to/your/.vimrc
```
else:

```bash
sudo ./install.sh
```

---

## What the script does

1. Detects your package manager (`apt`, `dnf`, `pacman` or `zypper`).
2. Installs a recommended set of system packages for development (Git, Vim, compilers, Python dev headers, Node, Java, etc.).
3. Clones or updates Vundle into `~/.vim/bundle/Vundle.vim`.
4. Backs up any existing `~/.vimrc` (creates `~/.vimrc.bak.TIMESTAMP`).
5. Copies `./vim_folder/.vimrc` to `~/.vimrc` using the `cp` command.
6. Runs `vim +PluginInstall +qall` to install plugins via Vundle.
7. If YouCompleteMe is installed by Vundle, it optionally runs its `install.py --all --verbose` to build YCM.

---

## Supported distributions

The script includes package lists for common distros and will try to install packages with one of the supported package managers. If your distro is not supported or uses different package names, edit `install.sh` and add/adjust package names.

Supported managers: `apt` (Ubuntu/Debian), `dnf` (Fedora/RHEL), `pacman` (Arch), `zypper` (openSUSE/SLES).

---

## Notes & troubleshooting

* **YouCompleteMe build failures:** YCM often needs additional dev packages like `clang`, `libclang-dev` (name varies by distro). If the build fails, inspect the output and install the missing packages, then re-run `python3 install.py --all --verbose` in `~/.vim/bundle/YouCompleteMe`.

* **Headless PluginInstall:** The script runs `vim +PluginInstall +qall` non-interactively. If you prefer to see plugin installation progress, run `vim` and run `:PluginInstall` manually.

* **Security:** Inspect `install.sh` before running. Do not run random scripts from the internet without review.

---

## References

* Upstream inspiration / related config: [https://github.com/PsymoNiko/vim\_config.git](https://github.com/PsymoNiko/vim_config.git)

---

## License

This repo includes a `LICENSE` file. Check it for license details.

---


