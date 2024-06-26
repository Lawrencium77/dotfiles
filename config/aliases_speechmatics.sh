# -------------------------------------------------------------------
# General and Navigation
# -------------------------------------------------------------------

HOST_IP_ADDR=$(hostname -I | awk '{ print $1 }') # This gets the actual ip addr
export DEFAULT_WORK_DIR=$HOME/git/aladdin/
export DEFAULT_SIF=$(cat $DEFAULT_WORK_DIR/env/GLOBAL_SIF)

function maybe_singularity_exec() {
    cmd=''
    if [ -z $SINGULARITY_CONTAINER ]; then
        cmd+="singularity exec $DEFAULT_SIF"
    fi
    echo $cmd
}

# Quick navigation add more here
alias a="cd ~/git/aladdin"
alias a2="cd ~/git/aladdin2"
alias a3="cd ~/git/aladdin3"
alias a4="cd ~/git/aladdin4"
alias a5="cd ~/git/aladdin5"
alias e="cd /exp/$(whoami)"
alias cdt="cd ~/tb"
alias cdn="cd ~/git/notebooks"

# Perish machines
alias p1="cd /perish_aml01"
alias p2="cd /perish_aml02"
alias p3="cd /perish_aml03"
alias p4="cd /perish_aml04"
alias p5="cd /perish_aml05"
alias g1="cd /perish_g01"
alias g2="cd /perish_g02"
alias g3="cd /perish_g03"

for i in {1..14}; do
    num=$(printf "%03d" $i)
    alias b${i}="ssh gpu${num}.grid.speechmatics.io"
done

# Change to aladdin directory and activate SIF
alias msa="make -C /home/$(whoami)/git/aladdin/ shell"
alias msa2="make -C /home/$(whoami)/git/aladdin2/ shell"
# Activate aladdin SIF in current directory
alias msad="/home/$(whoami)/git/aladdin/env/singularity.sh -c "$SHELL""
alias msad2="/home/$(whoami)/git/aladdin2/env/singularity.sh -c "$SHELL""

# Misc
alias jp="jupyter lab --no-browser --ip $HOST_IP_ADDR --ServerApp.token='123'"
alias ls='ls -hF --color' # add colors for filetype recognition

# make file
alias m='make'
alias mc="make check"
alias ms='make shell'
alias mf="make format"
alias mtest="make test"
alias mft="make functest"
alias mut="make unittest"

# -------------------------------------------------------------------
# Tensorboard
# -------------------------------------------------------------------
function tb () {
    if [ "$#" -eq 0 ]; then
        logdir=$PWD
    else
        logdir=$1
    fi
    
    $(maybe_singularity_exec) tensorboard \
      --load_fast false \
      --host=$HOST_IP_ADDR \
      --reload_multifile true \
      --logdir=$logdir \
      --reload_interval 8 \
      --extra_data_server_flags=--no-checksum \
      --max_reload_threads 4 \
      --window_title $PWD |& grep -v "TensorFlow installation not found"
}


tblink () {
    # Creates simlinks from specified folders to ~/tb/x where x is an incrmenting number
    # and launches tensorboard
    # example: `tblink ./lm/20210824 ./lm/20210824_ablation ./lm/20210825_updated_data`
    if [ "$#" -eq 0 ]; then
        logdir=$(pwd)
    else
        # setup tensorboard directory
        tbdir="$HOME/tb"
        if [ -d "$tbdir" ]; then
            last="$(printf '%s\n' $tbdir/* | sed 's/.*\///' | sort -g -r | head -n 1)"
            new=$((last+1))
            echo "last folder $last, new folder $new"
            logdir="$tbdir/$new"
        else
            logdir="$tbdir/0"
        fi
        # softlink into tensorboard directory
        _linkdirs "$logdir" "$@"
    fi
    tb $logdir
}

_linkdirs() {
    logdir="$1"
    mkdir -p $logdir
    for linkdir in "${@:2}"; do
        linkdir=$(readlink -f $linkdir)
        if [ ! -d $linkdir ]; then
            echo "linkdir $linkdir does not exist"
            return
        fi
        echo "symlinked $linkdir into $logdir"
        ln -s $linkdir $logdir
    done
}

tbadd() {
    # Add experiment folder to existing tensorboard directory (see tblink)
    # example: `tbadd ./lm/20210825 25` will symlink ./lm/20210824 to ~/tb/25
    if [ "$#" -gt 1 ]; then
        tbdir="$HOME/tb"
        logdir=$tbdir/$1
        _linkdirs $logdir "${@:2}"
    else
        echo "tbadd <tb number> <exp dirs>"
    fi
}

tbr () {
     jobs=$(qdesc | awk '{print $1}')
     args=()
     for job in ${=jobs}; do
         exp_dir="$(qexp "$job")"
         args+=($exp_dir)
     done
     tblink $args
}


# -------------------------------------------------------------------
# Queue management
# -------------------------------------------------------------------

# Short aliases
full_queue="qstat -f -u '*' | less "
alias q='qstat'
alias qtop='qalter -p 1024'
alias qq=$full_queue # Display full queue
alias gq='qstat -q aml-gpu.q -f -u \*' # Display just the gpu queues
alias hq='qstat -q "gcp-gpu.q" -f -u \* | less' #Display GCP queues
alias gqf='qstat -q aml-gpu.q -u \* -r -F gpu | egrep -v "jobname|Master|Binding|Hard|Soft|Requested|Granted"' # Display the gpu queues, including showing the preemption state of each job
alias cq='qstat -q "aml-cpu.q@gpu*" -f -u \*' # Display just the cpu queues
alias wq="watch qstat"
alias wqq="watch $full_queue"

# Queue functions
qlogin () {
  if [ "$#" -eq 1 ]; then
    /usr/bin/qlogin -now n -pe smp $1 -q aml-gpu.q -l gpu=$1 -N D_$(whoami)
  elif [ "$#" -eq 2 ]; then
    if [ "$1" = "cpu" ]; then
            /usr/bin/qlogin -now n -pe smp $2 -q aml-cpu.q -N D_$(whoami)
    else
            /usr/bin/qlogin -now n -pe smp $1 -q $2 -l gpu=$1 -N D_$(whoami)
    fi
  elif [ "$#" -eq 3 ]; then
    /usr/bin/qlogin -now n -pe smp $2 -q $3 -N D_$(whoami)
  else
    echo "Usage: qlogin <num_gpus>" >&2
    echo "Usage: qlogin <num_gpus> <queue>" >&2
    echo "Usage: qlogin cpu <num_slots>" >&2
    echo "Usage: qlogin cpu <num_slots> <queue>" >&2
  fi
}
qtail () {
  tail -f $(qlog $@)
}
qlast () {
  # Tail the last running job
  job_id=$(qstat | awk '$5=="r" {print $1}' | grep -E '[0-9]' | sort -r | head -n 1)
  echo "qtail of most recent job ${job_id}"
  qtail ${job_id} 
}
qless () {
  less $(qlog $@)
}
qcat () {
  cat $(qlog $@)
}
qlog () {
  # Get log path of job
  if [ "$#" -eq 1 ]; then
    echo $(qstat -j $1 | grep stdout_path_list | cut -d ":" -f4)
  elif [ "$#" -eq 2 ]; then
    log_path=$(qlog $1)
    base_dir=$(echo $log_path | rev | cut -d "/" -f3- | rev)
    filename=$(basename $log_path)
    echo ${base_dir}/log/${filename%.log}.${2}.log
  else
    echo "Usage: qlog <jobid>" >&2
    echo "Usage: qlog <array_jobid> <sub_jobid>" >&2
  fi
}

qdesc () {
  qstat | tail -n +3 | while read line; do
    job=$(echo $line | awk '{print $1}')
    if [[ ! $(qstat -j $job | grep "job-array tasks") ]]; then
      echo $job $(qlog $job)
    else
      qq_dir=$(qlog $job)
      job_status=$(echo $line | awk '{print $5}')
      if [ $job_status = 'r' ]; then
        sub_job=$(echo $line | awk '{print $10}')
        echo $job $sub_job $(qlog $job $sub_job)
      else
        echo $job $qq_dir $job_status
      fi
    fi
  done
}

qrecycle () {
    [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qrecycle $@" || command qrecycle "$@";
}

qupdate () {
    [ ! -z $SINGULARITY_CONTAINER ] && ssh localhost "qupdate"|| command qupdate ;
}

qexp () {
    # Get exp dir of job
    echo $(dirname $(qlog $@))
}

# Only way to get a gpu is via queue
if [ -z $CUDA_VISIBLE_DEVICES ]; then
  export CUDA_VISIBLE_DEVICES=
fi

# -------------------------------------------------------------------
# Cleaning processes
# -------------------------------------------------------------------

clean_vm () {
    ps -ef | grep zsh | awk '{print $2}' | xargs sudo kill
    ps -ef | grep vscode | awk '{print $2}' | xargs sudo kill
}

