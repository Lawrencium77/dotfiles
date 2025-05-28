# Aliases
alias colab="/google/bin/releases/grp-ix-team/rapid/colab-cli/cli.par"
alias dm_python="/google/bin/releases/deepmind/python/dm_python3/dm_python3.par"
alias ce="gcert"
alias bcl="build_cleaner"

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
