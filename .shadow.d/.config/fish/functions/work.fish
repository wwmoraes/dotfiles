function work -a cmd -d "Work commands to keep myself sane and productive"
  switch "$cmd"
    case non-prod
      echo "logging in to AWS"
      awscreds --account "$AWS_ACCOUNT_NON_PROD" --role "$AWS_ROLE_NON_PROD"

      echo "retrieving EKS cluster credentials"

      aws eks update-kubeconfig \
        --name gts-cloudbees-dev \
        --alias cloudbees-dev

      # last one = "default", as it sets the current context
      aws eks update-kubeconfig \
        --name gts-devops-pipeline-tools-dev \
        --alias pipeline-tools-dev
    case "*"
      echo (status function)": unknown command '$cmd'" > /dev/stderr
      return 2
  end
end

complete -xc work -n __fish_use_subcommand -a "non-prod" -d "logs in and gets all credentials needed to work in peace on non-prod"
