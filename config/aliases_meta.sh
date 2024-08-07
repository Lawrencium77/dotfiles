# -------------------------------------------------------------------
# On-Demand Control
# -------------------------------------------------------------------

alias dl='dev list'
alias dr='dev release'

function dc() {
    if [[ -z $1 ]]; then
        echo "Please provide an instance ID"
    else
        dev connect --hostname $1.od.fbinfra.net
    fi
}

# -------------------------------------------------------------------
# Sapling
# -------------------------------------------------------------------

alias sls='sl show'
alias hgs='hg shelve'
alias hgu='hg unshelve'

# -------------------------------------------------------------------
# Arc
# -------------------------------------------------------------------

alias al='arc lint'
