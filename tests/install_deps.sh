#!/bin/bash

DISTRO="$1"
extra_args=""

packages=(
          "iotop"
          "make"
          "sysstat"
          )

case ${DISTRO} in
  fedora*)
    packages+=(
               "procps-ng"
               "psmisc"
               "iproute"
               "elinks"
    )
    dnf install --assumeyes ${packages[@]} || exit $?
    ;;
  rhel*)
    packages+=(
               "psmisc"
               "iproute"
               "lynx"
    )
    dnf install --assumeyes ${packages[@]} || exit $?
  )
  centos*)
    packages+=(
               "psmisc"
               "iproute"
               "elinks"
    )
    version=$(grep -Po "[0-9]+" <<<${DISTRO/*:/})
    if [[ ${version} -ge 8 ]]; then
      packages+=(
        "procps-ng"
      )
      extra_args+="--enablerepo=powertools "
    fi
    yum install --assumeyes ${extra_args} ${packages[@]} || exit $?
    ;;
  debian*|ubuntu*)
    packages+=(
               "gawk"
               "procps"
               "psmisc"
               "iproute2"
               "elinks"
    )
    apt-get update
    apt-get install ${packages[@]} -y || exit $?
    ;;
  *)
    echo "Unknown distro: ${DISTRO}"
    exit 1
    ;;
esac
