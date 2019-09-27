#!/bin/bash

echo -e "\e[1;34mKubernetes CLI & powerups\e[0m"

echo -e "Checking \e[96mkubectl\e[0m..."
type -p kubectl &> /dev/null
if [ $? -ne 0 ]; then
  curl -Lo ~/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ~/bin/kubectl
fi

echo -e "Checking \e[96mkubebox\e[0m..."
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
