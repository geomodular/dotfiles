# dotfiles

This repo contains config files (mostly vim stuff) and `Makefile` capable of
installing them locally.

To quickly install files, clone repo and type:

```shell
make deploy
```

This will initialize git submodules within project folder and copy dotfiles to
appropriate places locally. Warning: existing files will be overwritten.


If you feel the vim packages need update type:

```shell
make update
```

You may want to `deploy` it locally afterwards.

To add a vim package into repo e.g. `NERD Commenter`:

```shell
make add PKG=https://github.com/scrooloose/nerdcommenter
```

... and `deploy` it locally or push it to the repo.

