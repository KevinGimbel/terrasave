#!/usr/bin/env fish
# Only allow "terraform apply" if -target is specified
function terraform
  set terraform_cmd (which terraform)
  set CAN_RUN 0

  if string match -q  -- "$argv" "apply"
    if not string match -q -- "$argv" "-target"
      echo "Please run \"terraform apply\" with -target option"
      return 1
    else
      CAN_RUN = 1
    end
  end

  if test $CAN_RUN > 0
    $terraform_cmd $argv
  end
end
