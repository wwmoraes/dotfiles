#!/bin/sh

set -eum
trap 'kill 0' INT HUP TERM

: "${ARCH:?unknown architecture}"
: "${SYSTEM:?unknown system}"

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# create temp work dir and traps cleanup
TMP=$(mktemp -d)
OLD_PWD="${PWD}"
cd "${TMP}"
trap 'cd "${OLD_PWD}"; rm -rf "${TMP}"' EXIT

printf "\e[1;34mGCP tools\e[0m\n"

printf "Checking \e[96mgcloud\e[0m...\n"
if ! _=$(command -V gcloud >/dev/null 2>&1); then
  printf "Downloading and installing \e[96mGoogle SDK\e[0m...\n"
  curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir="${HOME}/.local/"

  printf "Setting up \e[96mgcloud\e[0m config-helper...\n"
  gcloud config config-helper
fi

printf "\e[1;34mKubernetes CLI & powerups\e[0m\n"

printf "Checking \e[96mkubectl\e[0m...\n"
if ! _=$(command -V kubectl >/dev/null 2>&1); then
  curl -Lo kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/${SYSTEM}/amd64/kubectl"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 kubectl "${HOME}/.local/bin/kubectl"
fi

printf "Checking \e[96mkubeval\e[0m...\n"
if ! _=$(command -V kubeval >/dev/null 2>&1); then
  VERSION=$(curl -fsSL https://api.github.com/repos/instrumenta/kubeval/tags | jq -r '.[0].name')

  if [ "${ARCH}" != "" ]; then
    printf "Downloading \e[96mkubeval\e[0m...\n"
    curl -fsSLo kubeval.tar.gz "https://github.com/instrumenta/kubeval/releases/download/${VERSION}/kubeval-${SYSTEM}-${ARCH}.tar.gz"
    tar xzf kubeval.tar.gz
    printf "Installing \e[96mkubeval\e[0m...\n"
    install -g "$(id -g)" -o "$(id -u)" -m 0750 kubeval "${HOME}/.local/bin/kubeval"
  fi
fi

printf "Checking \e[96mhelm\e[0m...\n"
if ! _=$(command -V helm >/dev/null 2>&1); then
  VERSION=$(curl -fsSL https://api.github.com/repos/helm/helm/tags | jq -r '.[0].name')

  printf "Downloading \e[96mhelm\e[0m...\n"
  curl -fsSLo helm.tar.gz "https://get.helm.sh/helm-${VERSION}-${SYSTEM}-${ARCH}.tar.gz"
  tar xzf helm.tar.gz "${SYSTEM}-${ARCH}/helm"

  printf "Installing \e[96mhelm\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 "${SYSTEM}-${ARCH}/helm" "${HOME}/.local/bin/helm"
fi

printf "Checking \e[96mhelmfile\e[0m...\n"
if ! _=$(command -V helmfile >/dev/null 2>&1); then
  VERSION=$(curl -fsSL https://api.github.com/repos/roboll/helmfile/tags | jq -r '.[0].name')

  printf "Downloading \e[96mhelmfile\e[0m...\n"
  curl -fsSLo helmfile "https://github.com/roboll/helmfile/releases/download/${VERSION}/helmfile_${SYSTEM}_${ARCH}"

  printf "Installing \e[96mhelmfile\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 helmfile "${HOME}/.local/bin/helmfile"
fi

printf "Checking \e[96mkustomize\e[0m...\n"
if ! _=$(command -V kustomize >/dev/null 2>&1); then

  VERSION=$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/releases |\
    jq -r '[.[].name | select(. | contains("kustomize/"))][0] // "" | sub("^kustomize/"; "")')

  printf "Downloading \e[96mkustomize\e[0m...\n"
  curl -fsSLo kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/kustomize_${VERSION}_${SYSTEM}_${ARCH}.tar.gz"
  tar xzf kustomize.tar.gz

  printf "Installing \e[96mkustomize\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 kustomize "${HOME}/.local/bin/kustomize"
fi

printf "Checking \e[96mkapp\e[0m...\n"
if ! _=$(command -V kapp >/dev/null 2>&1); then
  VERSION=$(curl -fsSL https://api.github.com/repos/k14s/kapp/releases | jq -r '.[0].name')

  printf "Downloading \e[96mkapp\e[0m...\n"
  curl -fsSLo kapp "https://github.com/k14s/kapp/releases/download/${VERSION}/kapp-${SYSTEM}-${ARCH}"

  printf "Installing \e[96mkapp\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 kapp "${HOME}/.local/bin/kapp"
fi

printf "Checking \e[96mlab\e[0m...\n"
if ! _=$(command -V lab >/dev/null 2>&1); then
  VERSION=$(curl -fsSL https://api.github.com/repos/zaquestion/lab/releases | jq -r '.[0].name')

  printf "Downloading \e[96mlab\e[0m...\n"
  curl -fsSLo lab.tar.gz "https://github.com/zaquestion/lab/releases/download/${VERSION}/lab_$(echo "${VERSION}" | tr -d 'v')_${SYSTEM}_${ARCH}.tar.gz"
  tar xzf lab.tar.gz

  printf "Installing \e[96mlab\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 lab "${HOME}/.local/bin/lab"
fi

printf "Checking \e[96mopa\e[0m...\n"
if ! _=$(command -V opa >/dev/null 2>&1); then
  printf "Downloading \e[96mopa\e[0m...\n"
  curl -fsSLo opa "https://openpolicyagent.org/downloads/latest/opa_${SYSTEM}_${ARCH}"

  printf "Installing \e[96mopa\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 opa "${HOME}/.local/bin/opa"
fi

printf "Checking \e[96mpluto\e[0m...\n"
if ! _=$(command -V pluto >/dev/null 2>&1); then
  printf "Downloading \e[96mpluto\e[0m...\n"
  VERSION=$(curl -fsSL https://api.github.com/repos/FairwindsOps/pluto/releases | jq -r '.[0].name')
  curl -fsSLo - "https://github.com/FairwindsOps/pluto/releases/download/${VERSION}/pluto_${VERSION#v*}_${SYSTEM}_${ARCH}.tar.gz" | tar xzf -

  printf "Installing \e[96mpluto\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 pluto "${HOME}/.local/bin/pluto"
fi

printf "Checking \e[96mcalicoctl\e[0m...\n"
if ! _=$(command -V calicoctl >/dev/null 2>&1); then
  printf "Downloading \e[96mcalicoctl\e[0m...\n"
  VERSION=3.21.6
  curl -fsSLo calicoctl "https://github.com/projectcalico/calico/releases/download/v3.21.6/calicoctl-${SYSTEM}-${ARCH}"

  printf "Installing \e[96mcalicoctl\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 calicoctl "${HOME}/.local/bin/calicoctl"
fi

printf "Checking \e[96msonobuoy\e[0m...\n"
if ! _=$(command -V sonobuoy >/dev/null 2>&1); then
  printf "Downloading \e[96msonobuoy\e[0m...\n"
  VERSION=$(curl -fsSL https://api.github.com/repos/vmware-tanzu/sonobuoy/releases | jq -r '.[0].name')
  curl -fsSLo - "https://github.com/vmware-tanzu/sonobuoy/releases/download/${VERSION}/sonobuoy_${VERSION#v*}_${SYSTEM}_${ARCH}.tar.gz" | tar xzf -

  printf "Installing \e[96msonobuoy\e[0m...\n"
  install -g "$(id -g)" -o "$(id -u)" -m 0750 sonobuoy "${HOME}/.local/bin/sonobuoy"
fi
