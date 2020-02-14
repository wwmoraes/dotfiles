#!/bin/bash

printf "\e[1;34mGCP tools\e[0m\n"

printf "Checking \e[96mgcloud\e[0m...\n"
type -p gcloud &> /dev/null
if [ $? -ne 0 ]; then
  printf "Downloading and installing \e[96mGoogle SDK\e[0m...\n"
  curl https://sdk.cloud.google.com | bash -- --disable-prompts --install-dir=$HOME/.local/

  printf "Authenticating \e[96mgcloud\e[0m user...\n"
  gcloud auth login

  printf "Authenticating \e[96mgcloud\e[0m application-default...\n"
  gcloud auth application-default login

  printf "Setting up \e[96mgcloud\e[0m config-helper...\n"
  gcloud config config-helper
fi

printf "\e[1;34mKubernetes CLI & powerups\e[0m\n"

printf "Checking \e[96mkubectl\e[0m...\n"
type -p kubectl &> /dev/null
if [ $? -ne 0 ]; then
  curl -Lo ~/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ~/bin/kubectl
fi

printf "Checking \e[96mkubebox\e[0m...\n"
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

printf "Checking \e[96mkubeval\e[0m...\n"
type -p kubeval &> /dev/null
if [ $? -ne 0 ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/instrumenta/kubeval/tags | jq -r '.[0].name')
  SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]')

  ARCH=
  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    x86|386)
      ARCH=386
      ;;
    x86_64|amd64)
      ARCH=amd64
      ;;
    ""|*)
      printf "Unsupported arch\n"
      ;;
  esac

  if [ "${ARCH}" != "" ]; then
    TMP=$(mktemp -d)
    printf "Downloading \e[96mkubeval\e[0m...\n"
    curl -fsSL https://github.com/instrumenta/kubeval/releases/download/$VERSION/kubeval-$SYSTEM-$ARCH.tar.gz |\
    printf "Installing \e[96mkubeval\e[0m...\n"
      tar -C $TMP -xzf -
    install $TMP/kubeval ~/.local/bin/kubeval
    rm -rf $TMP
  fi
fi

printf "Checking \e[96mhelm\e[0m...\n"
type -p helm &> /dev/null
if [ $? -ne 0 ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/helm/helm/tags | jq -r '.[0].name')
  SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]')

  ARCH=
  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    armv8)
      ARCH=arm64
      ;;
    x86|386)
      ARCH=386
      ;;
    arm*)
      ARCH=arm
      ;;
    x86_64|amd64|""|*)
      ARCH=amd64
      ;;
  esac

  TMP=$(mktemp -d)
  curl -fsSL https://get.helm.sh/helm-$VERSION-$SYSTEM-$ARCH.tar.gz | tar -C $TMP -xvzf - $SYSTEM-$ARCH/helm
  mv $TMP/$SYSTEM-$ARCH/helm ~/.local/bin/helm
  chmod +x ~/.local/bin/helm
  rm -rf $TMP
fi

printf "Checking \e[96mkustomize\e[0m...\n"
type -p kustomize &> /dev/null
if [ $? -ne 0 ]; then

  SYSTEM=windows
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    SYSTEM=linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    SYSTEM=darwin
  fi
  VERSION=$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/tags | jq -r '.[0].name')

  TMP=$(mktemp -d)
  curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
    grep browser_download |\
    grep $SYSTEM |\
    cut -d '"' -f 4 |\
    grep /kustomize/v |\
    sort | tail -n 1 |\
    xargs curl -fsSL |\
    tar -C $TMP -xvzf -
  mv $TMP/kustomize ~/.local/bin/kustomize
  chmod +x ~/.local/bin/kustomize
  rm -rf $TMP
fi

printf "Checking \e[96mkapp\e[0m...\n"
type -p kapp &> /dev/null
if [ $? -ne 0 ]; then

  VERSION=$(curl -fsSL https://api.github.com/repos/k14s/kapp/tags | jq -r '.[0].name')
  SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]')

  curl -so ~/.local/bin/kapp https://github.com/k14s/kapp/releases/download/${VERSION}/kapp-${SYSTEM}-amd64
  chmod +x ~/.local/bin/kapp
fi

printf "Checking \e[96mlab\e[0m...\n"
type -p lab &> /dev/null
if [ $? -ne 0 ]; then

  VERSION=$(curl -fsSL https://api.github.com/repos/zaquestion/lab/tags | jq -r '.[0].name')
  SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]')

  ARCH=
  case "$(uname -m | tr '[:upper:]' '[:lower:]')" in
    armv8)
      ARCH=arm64
      ;;
    x86|386)
      ARCH=386
      ;;
    arm*)
      ARCH=arm
      ;;
    x86_64|amd64|""|*)
      ARCH=amd64
      ;;
  esac

  TMP=$(mktemp -d)
  curl -fsSL https://github.com/zaquestion/lab/releases/download/${VERSION}/lab_$(echo ${VERSION} | tr -d 'v')_${SYSTEM}_${ARCH}.tar.gz |\
    tar -C $TMP -xzf -
  mv $TMP/lab ~/.local/bin/lab
  chmod +x ~/.local/bin/lab
  rm -rf $TMP
fi
