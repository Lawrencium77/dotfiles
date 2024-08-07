# Dotfiles

Follows the structure of [this simple repo](https://github.com/erees1/simple-dotfiles).

## Installation

### Step 1

Clone the repo

```bash
git clone git@github.com:Lawrencium77/dotfiles.git ~/git/dotfiles
```

### Step 2

Install [iTerm2](https://iterm2.com/). Then install `./iterm/Default.json` using [these](https://stackoverflow.com/questions/35211565/how-do-i-import-an-iterm2-profile/66923620#66923620) instructions.

### Step 3

Install dependencies (e.g. oh-my-zsh and related plugins). You can specify options to install specific programs: tmux, zsh. Note that a remote machine will likely have tmux and zsh pre-installed so you don't need to provide any options in this case but you may need to provide these if you are installing locally.

Installation on a mac machine requires homebrew; install [from here](https://brew.sh/) if you haven't already.

```bash
# Install just the dependencies
./install.sh
# Install extras (tmux, zsh, nvim, git delta)
./install.sh --all
```

### Step 4

Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings etc..)

```bash
# Remote Linux machine
./deploy.sh  --remote
# Local Mac machine
./deploy.sh --local
```

### Step 5

Run `p10k configure` to reconfigure powerlevel10k theme.

## Reset

For dev, it can be useful to undo all effects of running `deply.sh`. The `reset.sh` script is used for this:

```bash
# Remote Linux machine
./deploy.sh  --remote
# Local Mac machine
./deploy.sh --local
```
