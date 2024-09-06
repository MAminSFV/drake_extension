# Main reference: https://github.com/RobotLocomotion/drake-external-examples/blob/main/scripts/setup/linux/ubuntu/jammy/install_prereqs
# Removed some unused dependencies

#!/bin/bash

# Copyright (c) 2020, Massachusetts Institute of Technology.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its contributors
#   may be used to endorse or promote products derived from this software
#   without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

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
  bazel
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
