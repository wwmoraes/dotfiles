#!/bin/bash

echo -e "\e[1;33mKubernetes CLI & powerups\e[0m"

echo "Checking kubectl..."
type -p kubectl &> /dev/null
if [ $? -ne 0 ]; then
  curl -Lo ~/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ~/bin/kubectl
fi

echo "Checking kubebox..."
type -p kubebox &> /dev/null
if [ $? -ne 0 ]; then
  case "$(uname | tr '[:upper:]' '[:lower:]')" in
    "linux")
      curl -Lo ~/bin/kubebox https://github.com/astefanutti/kubebox/releases/download/v0.6.0/kubebox-linux;;
    "darwin")
      curl -Lo kubebox https://github.com/astefanutti/kubebox/releases/download/v0.6.0/kubebox-macos;;
    ""|*)
      echo "Sorry, platform unsupported by kubebox";;
  esac

  [ -f ~/bin/kubebox ] && chmod +x ~/bin/kubebox
fi
