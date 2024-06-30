#!/bin/bash

cd /etc/nixos/

git add *.*
git commit -am nano
git clean repo -f
