#!/bin/bash
mkdir -p external
cd external

# Clone PiFeNet
if [ ! -d PiFeNet ]; then
    git clone --recursive https://github.com/ldtho/PiFeNet.git
fi

# Clone spconv v1.2.1
if [ ! -d spconv ]; then
    git clone --recursive -b v1.2.1 https://github.com/traveller59/spconv.git /spconv_1.2.1
fi
