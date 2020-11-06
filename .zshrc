autoload -Uz promptinit
promptinit
autoload -U colors && colors

export PROMPT="%{$fg[green]%}youri%{$reset_color%}🐙 %~ $ "
export RPROMPT="%{$fg[green]%} %t%{$reset_color%}"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
