# General aliases
alias colab="/google/bin/releases/grp-ix-team/rapid/colab-cli/cli.par"
alias dm_python="/google/bin/releases/deepmind/python/dm_python3/dm_python3.par"
alias ce="gcert"
alias cns2util='/google/bin/releases/cns2/tools/cns2util'
alias fls="fileutil ls"

# Fig aliases
alias hgl="hg lint"
alias hgau="hg amend && hg upload chain"

# Blaze Aliases
alias bcl="build_cleaner"
alias blr="blaze run"
alias blb="blaze build"
alias blt="blaze test"

# Flaze
alias flaze="/google/bin/releases/ix-ml/rapid/flaze/flaze"

# XManager
alias xmanager="/google/bin/releases/xmanager/cli/xmanager.par"

# Gemini CLI
alias gemini='/google/bin/releases/gemini-cli/tools/gemini'
alias gem='/google/bin/releases/gemini-cli/tools/gemini'

# Debugpy
alias debugpy='/google/bin/releases/debugpy-team/public/debugpy'

# Pyfactor
alias pyfactor=/google/data/ro/teams/youtube-code-health/pyfactor

export DEEPMIND_BINFS_PUBLIC="/google/bin/releases/deepmind/public"

# Standard Google things
alias bisect="/google/data/ro/teams/tetralight/bin/bisect"

function export_function() {
  if [[ -n "${ZSH_VERSION+x}" ]]; then
    zle -N "$1"  # zsh-specific, turn function into widget.
  else
    export -f "$1"  # Bash or others, use export -f hack.
  fi
}

# export_alias is like `alias`, but it exports to subshells.
function export_alias() {
  local ALIAS="${1}"
  shift
  # All our args, then all the generated function's args.
  eval "function ${ALIAS}() { ${@} \"\${@}\"; }"
  export_function "${ALIAS}"
}

export_alias bbb '${DEEPMIND_BINFS_PUBLIC}/bbb.sar'

source /etc/bash_completion.d/g4d
source /etc/bash_completion.d/hgd

# Like regular `guitar`, but with verbose output
function guitar() {
  if [[ ! -x /usr/bin/guitar ]]; then
    echo "Please install the guitar CLI via apt; see http://go/guitar-cli."
  elif [[ $# -eq 0 ]]; then
     # If no arguments are given, just call `guitar` as is to produce the help text.
     /usr/bin/guitar
  else
    echo "Google DeepMind 'guitar' wrapper; adds verbose output. Use /usr/bin/guitar to bypass."
    /usr/bin/guitar "${@}" --verbose_notifications --verbose_status_update_period=3s
  fi
}

# Switch to blaze-bin and back
function bb() {
  if [[ $PWD =~ '(.*)/blaze-bin(.*)' ]]; then
    cd "${match[1]}${match[2]}" # If in blaze-bin, remove blaze_bin/ from pwd
  else
    cd "${PWD/\/google3//google3/blaze-bin}"
  fi
}

function clear_deepmind_binary_caches() {
  local binary=$1
  if [[ -z "$binary" ]]; then
    >&2 echo "No binary argument supplied."
  else
    local local_directory="/export/hda3/tmp/${binary}"
    >&2 echo "Removing locally cached binary: ${local_directory}"
    rm -R "${local_directory}"
  fi
}
