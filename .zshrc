# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  autojump
  bgnotify
  fzf
  git
  vi-mode
  yarn
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
bindkey '^V' edit-command-line
bindkey -M viins jj vi-cmd-mode
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#--- Custom config for vi-mode
export VI_MODE_SET_CURSOR=true
#kill the log when press esc
export KEYTIMEOUT=1
#--- END Custom config for vi-mode
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
# keep folder vim and terminal same
# https://stackoverflow.com/a/12241861/1743046
function s()
{
    local CWDFILE=/tmp/cd_vim
    test -e $CWDFILE && cd "$(cat $CWDFILE)"
}

bindkey '^F' fzf-file-widget

cross_open(){
  case "$OSTYPE" in
    darwin*)
      open $1
      ;;
    linux*)
      xdg-open $1
      ;;
  esac
}

# circleci
ci() {
  cross_open https://circleci.com/gh/Thinkei/workflows/$1
}
cio() {
  ci `basename $(pwd)`
}
# open circleci in currrent branch
cc() {
   ci `basename $(pwd)`/tree/"${$(git rev-parse --abbrev-ref HEAD)//\//%2F}"
}

pr() {
  cross_open $(hub pr list --format='%H %U %n' | grep $(git rev-parse --abbrev-ref HEAD) | awk '{print $2}')
}

# kill and open telegram app
kt() {
  kill -9 $(ps aux | fzf -e -1 -0 -q 'telegram !fzf' | awk '{print $2}')
}

ot() {
  open -a "/Applications/Telegram.app/Contents/MacOS/Telegram"
}
# fetch and merge master to current branch
gfm() {
 git fetch origin master
 git merge origin/master
}
# git checkout interactive
gcoi(){
 checkoutToBranch=$(git branch | fzf -1 | xargs)
 print -s "git checkout $checkoutToBranch"
 git checkout $checkoutToBranch
}

# Quickly merge staging
deploySbx() {
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  # git stash
  echo "FETCH ORIGIN CODE"
  git fetch origin $1
  echo "MERGE $currentBranch"
  git checkout $1
  git reset --hard origin/$1
  git merge $currentBranch -m "Merge branch '$currentBranch' into $1"
  echo "PUSH CODE"
  git push origin HEAD
  cc # Open CircleCI
  echo "CHECKOUT BACK"
  git checkout $currentBranch
  # git stash apply
  echo "DONE"
}

alias dsb='deploySbx $(git branch | fzf --height 40% -q "^sbx | stag" -1)'

gmr() {
    # A quick way to open a GitLab merge request URL for the current git branch
    # you're on. The optional first argument is the target branch.

    repo_path=$(git remote get-url origin --push | sed 's/^.*://g' | sed 's/.git$//g')
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [[ -n $1 ]]; then
        target_branch="&merge_request[target_branch]=$1"
    else
        target_branch=""
    fi

    open "https://gitlab.com/$repo_path/merge_requests/new?merge_request[source_branch]=$current_branch$target_branch"

}

# staging
alias heroclistag='herocli --server hero2.staging.ehrocks.com:443'

# production
alias herocliprod='herocli --server hero2.ehrocks.com:443'

# integration
alias herocliint='herocli --server hero2.integration.ehrocks.com:443'

source <(fzf --zsh)
source ~ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh

# fix problem with unmatching
unsetopt nomatch

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
