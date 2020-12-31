#!/bin/bash

set -Eeuo pipefail

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

printf "\e[1;34mGCP tools\e[0m\n"

printf "Checking \e[96mgcloud\e[0m...\n"
if ! _=$(type -p gcloud &> /dev/null); then
  printf "Downloading and installing \e[96mGoogle SDK\e[0m...\n"
  curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir=$HOME/.local/

  printf "Authenticating \e[96mgcloud\e[0m user...\n"
  gcloud auth login

  printf "Authenticating \e[96mgcloud\e[0m application-default...\n"
  gcloud auth application-default login

  printf "Setting up \e[96mgcloud\e[0m config-helper...\n"
  gcloud config config-helper
fi

printf "\e[1;34mKubernetes CLI & powerups\e[0m\n"

printf "Checking \e[96mkubectl\e[0m...\n"
if ! _=$(type -p kubectl &> /dev/null); then
  curl -Lo ~/.local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/${SYSTEM}/amd64/kubectl
  chmod +x ~/.local/bin/kubectl
fi

printf "Checking \e[96mkubeval\e[0m...\n"
if ! _=$(type -p kubeval &> /dev/null); then
  VERSION=$(curl -fsSL https://api.github.com/repos/instrumenta/kubeval/tags | jq -r '.[0].name')

  if [ "${ARCH}" != "" ]; then
    TMP=$(mktemp -d)
    printf "Downloading \e[96mkubeval\e[0m...\n"
    curl -fsSL https://github.com/instrumenta/kubeval/releases/download/$VERSION/kubeval-$SYSTEM-$ARCH.tar.gz |\
      tar -C $TMP -xzf -
    printf "Installing \e[96mkubeval\e[0m...\n"
    install $TMP/kubeval ~/.local/bin/kubeval
    rm -rf $TMP
  fi
fi

printf "Checking \e[96mhelm\e[0m...\n"
if ! _=$(type -p helm &> /dev/null); then
  VERSION=$(curl -fsSL https://api.github.com/repos/helm/helm/tags | jq -r '.[0].name')

  TMP=$(mktemp -d)
  curl -fsSL https://get.helm.sh/helm-$VERSION-$SYSTEM-$ARCH.tar.gz | tar -C $TMP -xzf - $SYSTEM-$ARCH/helm
  mv $TMP/$SYSTEM-$ARCH/helm ~/.local/bin/helm
  chmod +x ~/.local/bin/helm
  rm -rf $TMP
fi

printf "Checking \e[96mkustomize\e[0m...\n"
if ! _=$(type -p kustomize &> /dev/null); then

  VERSION=$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/tags | jq -r '.[0].name')

  TMP=$(mktemp -d)
  curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
    grep browser_download |\
    grep $SYSTEM |\
    cut -d '"' -f 4 |\
    grep /kustomize/v |\
    sort | tail -n 1 |\
    xargs curl -fsSL |\
    tar -C $TMP -xzf -
  mv $TMP/kustomize ~/.local/bin/kustomize
  chmod +x ~/.local/bin/kustomize
  rm -rf $TMP
fi

printf "Checking \e[96mkapp\e[0m...\n"
if ! _=$(type -p kapp &> /dev/null); then

  VERSION=$(curl -fsSL https://api.github.com/repos/k14s/kapp/tags | jq -r '.[0].name')

  curl -so ~/.local/bin/kapp https://github.com/k14s/kapp/releases/download/${VERSION}/kapp-${SYSTEM}-amd64
  chmod +x ~/.local/bin/kapp
fi

printf "Checking \e[96mlab\e[0m...\n"
if ! _=$(type -p lab &> /dev/null); then

  VERSION=$(curl -fsSL https://api.github.com/repos/zaquestion/lab/tags | jq -r '.[0].name')

  TMP=$(mktemp -d)
  curl -fsSL https://github.com/zaquestion/lab/releases/download/${VERSION}/lab_$(echo ${VERSION} | tr -d 'v')_${SYSTEM}_${ARCH}.tar.gz |\
    tar -C $TMP -xzf -
  mv $TMP/lab ~/.local/bin/lab
  chmod +x ~/.local/bin/lab
  rm -rf $TMP
fi

printf "Checking \e[96mopa\e[0m...\n"
if ! _=$(type -p opa &> /dev/null); then

  curl -fsSLo ~/.local/bin/opa https://openpolicyagent.org/downloads/latest/opa_${SYSTEM}_${ARCH}
  chmod +x ~/.local/bin/opa
fi
