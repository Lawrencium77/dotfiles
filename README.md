## Status of Install Scripts
Works locally. Need to check that it works on remote - especially git delta and neovim.

## Installation

### Step 1
Clone the repo
```bash
git clone git@github.com:Lawrencium77/dotfiles.git ~/git/dotfiles
```

### Step 2
Install dependencies (e.g. oh-my-zsh and related plugins). You can specify options to install specific programs: tmux, zsh. Note that a remote machine will likely have tmux and zsh pre-installed so you don't need to provide any options in this case but you may need to provide these if you are installing locally. 

Installation on a mac machine requires homebrew; install [from here](https://brew.sh/) first if you haven't already.

```bash
# Install just the dependencies 
./install.sh
# Install dependencies + tmux & zsh 
./install.sh --tmux --zsh
```

### Step 3
Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings etc..)
```bash
# Remote Linux machine
./deploy.sh  --remote
# Local Mac machine
./deploy.sh --local   
```

### Step 4
Run `p10k configure` to reconfigure powerlevel10k theme.
