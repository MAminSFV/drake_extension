#!/usr/bin/env bash
# Inspired by https://github.com/RobotLocomotion/drake/blob/master/tools/wheel/image/build-wheel.sh
set -eu -o pipefail

# Helper function to change the RPATH of libraries. The first argument is the
# (origin-relative) new RPATH to be added. Remaining arguments are libraries to
# be modified. Note that existing RPATH(s) are removed (except for homebrew
# RPATHs on macOS).
chrpath()
{
    rpath=$1
    shift 1

    for lib in "$@"; do
        patchelf --remove-rpath "$lib"
        patchelf --set-rpath "\$ORIGIN/$rpath" "$lib"
    done
}

###############################################################################
bash ./scripts/setup_ubuntu
        export PATH="/opt/drake/bin${PATH:+:${PATH}}"
        export PYTHONPATH="/opt/drake/lib/python$(python3 -c 'import sys; print("{0}.{1}".format(*sys.version_info))')/site-packages${PYTHONPATH:+:${PYTHONPATH}}"
        export LD_LIBRARY_PATH="/opt/drake/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

readonly WHEEL_DIR=./wheels
readonly WHEEL_SHARE_DIR=${WHEEL_DIR}/pydrake/share

# TODO(mwoehlke-kitware) Most of this should move to Bazel.
mkdir -p ${WHEEL_DIR}/drake
mkdir -p ${WHEEL_DIR}/pydrake/lib
mkdir -p ${WHEEL_DIR}/pydrake/share/drake
cd ${WHEEL_DIR}

cp -r -t ${WHEEL_DIR}/drake \
    /opt/drake/lib/python*/site-packages/drake/*

cp -r -t ${WHEEL_DIR}/pydrake \
    /opt/drake/share/doc \
    /opt/drake/lib/python*/site-packages/pydrake/*

cp -r -t ${WHEEL_DIR}/pydrake/lib \
    /opt/drake/lib/libdrake*.so

cp -r -t ${WHEEL_DIR}/pydrake \
    /opt/drake-wheel-content/*

###############################################################################
python3 setup.py bdist_wheel

 GLIBC_VERSION=$(ldd --version | sed -n '1{s/.* //;s/[.]/_/p}')

auditwheel repair --plat manylinux_${GLIBC_VERSION}_x86_64 dist/drake_extenstion_*.whl
