# setopt nonomatch

export LANG=en_US.UTF-8
export EDITOR=nvim

alias esl="exec $SHELL -l"
alias nv="nvim"
alias ne="nodenv"
alias gh="select-repo"
alias d="docker"
alias dc="docker-compose"
alias ll="ls -l"
alias la="ls -a"
alias tl="tail -f"
alias g="git"
alias t="tig"
alias rmrf="rm -rf"
alias zconf="vim ~/.zshrc"
alias lg="lazygit"

alias -g G="| grep"
alias -g X="| xargs"
alias -g C="| cat"
alias -g L="| less"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/google-cloud-sdk/bin/:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

# init
eval "$(direnv hook zsh)" 
eval "$(nodenv init -)"
eval "$(pyenv init -)"
eval "$(rbenv init -)"

# zplugの初期化
if [ `uname` = "Linux" ]; then
  source $(brew --prefix)/opt/zplug/init.zsh
else
  source ~/.zplug/init.zsh
fi

# plugins
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*darwin*amd64*"
zplug "b4b4r07/enhancd", use:"init.sh"

# install
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

function select-repo() { 
  gh_dir=~/github 
  repo=$(ls $gh_dir | fzf)
  cd $gh_dir/$repo
}

function ssh-key-gen() {
  ssh-keygen -t rsa -b 4096 -C $1
}

function gitignore() {
  curl -sLw "\n" https://www.gitignore.io/api/${@} > .gitignore
}

function gitignore-list() {
  curl https://www.gitignore.io/api/list
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.zsh.inc' ]; then
  source '~/google-cloud-sdk/path.zsh.inc';
fi

# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.zsh.inc' ]; then
  source '~/google-cloud-sdk/completion.zsh.inc';
fi
