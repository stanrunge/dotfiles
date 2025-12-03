DOTFILES_PATH="$HOME/dev/dotfiles"

ZSH_SOURCE="$DOTFILES_PATH/zsh/.zshrc"
TMUX_CONFIG_SOURCE="$DOTFILES_PATH/.tmux.conf"
TMUX_FOLDER_SOURCE="$DOTFILES_PATH/.tmux"
NVIM_SOURCE="$DOTFILES_PATH/nvim"
GHOSTTY_SOURCE="$DOTFILES_PATH/ghostty"
GIT_SOURCE="$DOTFILES_PATH/git/.gitconfig"

ZSH_CONFIG="$HOME/.zshrc"
TMUX_CONFIG="$HOME/.tmux.conf"
TMUX_FOLDER="$HOME/.tmux"
NVIM_CONFIG="$HOME/.config/nvim"
GHOSTTY_CONFIG="$HOME/.config/ghostty"
GIT_CONFIG="$HOME/.gitconfig"

rm -f $ZSH_CONFIG
rm -f $TMUX_CONFIG
rm -f $GIT_CONFIG
rm -rf $TMUX_FOLDER
rm -rf $NVIM_CONFIG
rm -rf $GHOSTTY_CONFIG

mkdir -p ~/.tmux
mkdir -p ~/.config/nvim
mkdir -p ~/.config/ghostty

ln -s $ZSH_SOURCE $ZSH_CONFIG
ln -s $TMUX_CONFIG_SOURCE $TMUX_CONFIG
ln -s $TMUX_FOLDER_SOURCE $TMUX_FOLDER
ln -s $NVIM_SOURCE/* $NVIM_CONFIG/
ln -s $GHOSTTY_SOURCE/* $GHOSTTY_CONFIG/
ln -s $GIT_SOURCE $GIT_CONFIG

echo "Setup complete! Please run 'source ~/.zshrc'"
