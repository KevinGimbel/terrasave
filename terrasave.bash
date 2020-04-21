# Only allow "terraform apply" if -target is specified
function terraform_save() {
  # Since we define an alias we need to get the "real" terraform
  terraform_cmd=$(which terraform)
  CAN_RUN=${TERRAFORM_SAVE_DISABLE_I_KNOW_WHAT_I_DO:-0}

  # Only handle "apply" command
  if [[ $(echo "$@" | grep "apply") != "" ]]; then
    # Check if -target is set 
    if [[ $(echo "$@" | grep "\-target") == "" ]]; then 
      echo "Please run \"terraform apply\" with -target option"
    else
      CAN_RUN=1
    fi
  else
    CAN_RUN=1
  fi

  # Check if we can run this terraform command
  if [[ $CAN_RUN -gt 0 ]]; then
    $terraform_cmd "$@"
  fi
}

alias terraform=terraform_save