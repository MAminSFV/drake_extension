#!/bin/bash
# Main reference: https://github.com/RobotLocomotion/drake-external-examples/blob/main/scripts/setup/linux/ubuntu/jammy/install_prereqs
# Removed some unused dependencies

set -euxo pipefail

apt-get update
apt-get install --no-install-recommends lsb-release

if [[ "$(lsb_release -sc)" != 'jammy' ]]; then
  echo 'This script requires Ubuntu 22.04 (Jammy)' >&2
  exit 3
fi

apt-get install --no-install-recommends $(cat <<EOF
  ca-certificates
  wget
EOF
)

wget -O drake.tar.gz \
  https://drake-packages.csail.mit.edu/drake/nightly/drake-latest-jammy.tar.gz
trap 'rm -f drake.tar.gz' EXIT
tar -xf drake.tar.gz -C /opt

# Show version for debugging; use echo for newline / readability.
echo -e "\ndrake VERSION.TXT: $(cat /opt/drake/share/doc/drake/VERSION.TXT)\n"

/opt/drake/share/drake/setup/install_prereqs

apt-get install --no-install-recommends gnupg

apt-key adv --fetch-keys https://bazel.build/bazel-release.pub.gpg
echo 'deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8' \
  > /etc/apt/sources.list.d/bazel.list

apt-get update
apt-get install --no-install-recommends $(cat <<EOF
  cmake
  default-jdk
  file
  gfortran
  git
  libblas-dev
  libclang-15-dev
  libeigen3-dev
  libgflags-dev
  libgl-dev
  libglib2.0-dev
  libglx-dev
  liblapack-dev
  libmumps-seq-dev
  libopengl-dev
  libspdlog-dev
  libx11-dev
  locales
  nasm
  ocl-icd-opencl-dev
  opencl-headers
  openssh-client
  patch
  patchelf
  pkg-config
  python-is-python3
  python3-all-dev
  python3-ipywidgets
  python3-matplotlib
  python3-munkres
  python3-numpy
  python3-pil
  python3-pydot
  python3-pygame
  python3-yaml
  zlib1g-dev
EOF
)

locale-gen en_US.UTF-8
