# dotfiles

Install dependancies (e.g. oh-my-zsh, homebrew etc...), can specify options to install specific programs: tmux, zsh, pyenv.
```bash
# Install dependancies + tmux & zsh
./install.sh --tmux --zsh
```

Deploy (e.g. source aliases for .zshrc, apply oh-my-zsh settings etc..)

```bash
./deploy.sh --remote  # Remote linux machine
./deploy.sh --local   # Local mac machine
```

It may be the case that ```./deploy.sh``` runs successfully but is missing some dependencies. If this is the case, simply install and then re-run.
Install tmux plugins with `ctrl+a I`


