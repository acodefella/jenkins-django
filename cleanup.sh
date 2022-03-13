#!/bin/bash

export PATH=~/bin:$PATH
kind delete cluster --name django-cluster || true
rm ./django.config || true
rm -rf ~/bin || true