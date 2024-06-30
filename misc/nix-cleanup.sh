#!/bin/bash

cd /home/derrik/.nixos-configs/

git add *.*
git commit -am nano
git clean repo -f
